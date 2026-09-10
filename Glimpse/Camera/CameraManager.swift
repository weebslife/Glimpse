import Foundation
import AVFoundation
import Combine

final class CameraManager: NSObject, ObservableObject {
    @Published var state: CameraState = .idle
    
    let session = AVCaptureSession()
    
    private let sessionQueue = DispatchQueue(label: "com.adinshobirin.mirror.sessionQueue", qos: .userInitiated)
    private var isConfigured = false
    private var currentInput: AVCaptureDeviceInput?
    private var isRunningTarget = false
    private var retryCount = 0
    private let maxAutoRetries = 3
    private var cancellables = Set<AnyCancellable>()
    
    override init() {
        super.init()
        setupObservers()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
        if session.isRunning {
            session.stopRunning()
        }
    }
    
    private func setupObservers() {
        session.publisher(for: \.isRunning)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] isRunning in
                guard let self = self else { return }
                if isRunning {
                    self.retryCount = 0
                    self.state = .running
                } else if !self.isRunningTarget {
                    self.state = .idle
                }
            }
            .store(in: &cancellables)
            
        let center = NotificationCenter.default
        center.addObserver(
            self,
            selector: #selector(handleRuntimeError(_:)),
            name: .AVCaptureSessionRuntimeError,
            object: session
        )
        center.addObserver(
            self,
            selector: #selector(handleSessionInterrupted(_:)),
            name: .AVCaptureSessionWasInterrupted,
            object: session
        )
        center.addObserver(
            self,
            selector: #selector(handleSessionInterruptionEnded(_:)),
            name: .AVCaptureSessionInterruptionEnded,
            object: session
        )
    }
    
    func start() {
        isRunningTarget = true
        
        DispatchQueue.main.async {
            if self.state != .running {
                self.state = .loading
            }
        }
        
        sessionQueue.async { [weak self] in
            guard let self = self else { return }
            guard self.isRunningTarget else { return }
            self.retryCount = 0
            self.checkPermissionAndStart()
        }
    }
    
    func stop() {
        isRunningTarget = false
        
        DispatchQueue.main.async {
            self.state = .idle
        }
        
        sessionQueue.async { [weak self] in
            guard let self = self else { return }
            guard !self.isRunningTarget else { return }
            if self.session.isRunning {
                self.session.stopRunning()
            }
        }
    }
    
    func retry() {
        isRunningTarget = true
        isConfigured = false
        retryCount = 0
        
        DispatchQueue.main.async {
            self.state = .loading
        }
        
        sessionQueue.async { [weak self] in
            guard let self = self else { return }
            self.checkPermissionAndStart()
        }
    }
    
    private func checkPermissionAndStart() {
        let authStatus = AVCaptureDevice.authorizationStatus(for: .video)
        
        switch authStatus {
        case .authorized:
            self.configureAndStartSession()
            
        case .notDetermined:
            DispatchQueue.main.async {
                self.state = .loading
            }
            AVCaptureDevice.requestAccess(for: .video) { [weak self] granted in
                guard let self = self else { return }
                self.sessionQueue.async {
                    guard self.isRunningTarget else { return }
                    if granted {
                        self.configureAndStartSession()
                    } else {
                        DispatchQueue.main.async {
                            self.state = .permissionDenied
                        }
                    }
                }
            }
            
        case .denied, .restricted:
            DispatchQueue.main.async {
                self.state = .permissionDenied
            }
            
        @unknown default:
            DispatchQueue.main.async {
                self.state = .error("Unknown camera authorization status.")
            }
        }
    }
    
    private func configureAndStartSession() {
        guard isRunningTarget else { return }
        
        let needsConfiguration = !isConfigured ||
                                 currentInput == nil ||
                                 currentInput?.device.isConnected == false ||
                                 session.inputs.isEmpty
        
        if needsConfiguration {
            session.beginConfiguration()
            session.sessionPreset = .high
            
            for input in session.inputs {
                session.removeInput(input)
            }
            currentInput = nil
            
            guard let device = findDefaultCamera() else {
                session.commitConfiguration()
                DispatchQueue.main.async {
                    self.state = .noDevice
                }
                return
            }
            
            do {
                let input = try AVCaptureDeviceInput(device: device)
                if session.canAddInput(input) {
                    session.addInput(input)
                    self.currentInput = input
                    self.isConfigured = true
                } else {
                    session.commitConfiguration()
                    DispatchQueue.main.async {
                        self.state = .error("Cannot attach camera to capture session.")
                    }
                    return
                }
            } catch {
                session.commitConfiguration()
                DispatchQueue.main.async {
                    self.state = .error(error.localizedDescription)
                }
                return
            }
            
            session.commitConfiguration()
        }
        
        if !session.isRunning && isRunningTarget {
            session.startRunning()
        }
        
        DispatchQueue.main.async {
            if self.isRunningTarget {
                self.state = self.session.isRunning ? .running : .loading
            }
        }
    }
    
    private func findDefaultCamera() -> AVCaptureDevice? {
        if let defaultDevice = AVCaptureDevice.default(for: .video) {
            return defaultDevice
        }
        
        let discoverySession = AVCaptureDevice.DiscoverySession(
            deviceTypes: [
                .builtInWideAngleCamera,
                .externalUnknown
            ],
            mediaType: .video,
            position: .unspecified
        )
        
        return discoverySession.devices.first
    }
    
    @objc private func handleRuntimeError(_ notification: Notification) {
        guard isRunningTarget else { return }
        guard let error = notification.userInfo?[AVCaptureSessionErrorKey] as? AVError else { return }
        
        if retryCount < maxAutoRetries {
            retryCount += 1
            sessionQueue.asyncAfter(deadline: .now() + 0.3) { [weak self] in
                guard let self = self, self.isRunningTarget else { return }
                if !self.session.isRunning {
                    self.session.startRunning()
                }
                DispatchQueue.main.async {
                    if self.session.isRunning {
                        self.state = .running
                    }
                }
            }
        } else {
            DispatchQueue.main.async {
                self.state = .error("Session error: \(error.localizedDescription)")
            }
        }
    }
    
    @objc private func handleSessionInterrupted(_ notification: Notification) {
        guard isRunningTarget else { return }
        DispatchQueue.main.async {
            if self.state == .running {
                self.state = .loading
            }
        }
    }
    
    @objc private func handleSessionInterruptionEnded(_ notification: Notification) {
        guard isRunningTarget else { return }
        sessionQueue.async { [weak self] in
            guard let self = self, self.isRunningTarget else { return }
            if !self.session.isRunning {
                self.session.startRunning()
            }
        }
    }
}
