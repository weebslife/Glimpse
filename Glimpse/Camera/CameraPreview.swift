import SwiftUI
import AVFoundation
import AppKit

struct CameraPreview: NSViewRepresentable {
    let session: AVCaptureSession
    var isMirrored: Bool = true
    var cameraState: CameraState = .idle
    
    func makeNSView(context: Context) -> CameraPreviewNSView {
        let view = CameraPreviewNSView()
        view.configure(with: session, isMirrored: isMirrored)
        return view
    }
    
    func updateNSView(_ nsView: CameraPreviewNSView, context: Context) {
        nsView.updateSessionIfNeeded(session, isMirrored: isMirrored)
    }
}

final class CameraPreviewNSView: NSView {
    private var previewLayer: AVCaptureVideoPreviewLayer?
    private var isMirrored: Bool = true
    
    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        setupLayer()
        setupObservers()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupLayer()
        setupObservers()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    private func setupLayer() {
        wantsLayer = true
        layer?.backgroundColor = NSColor.black.cgColor
    }
    
    private func setupObservers() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(handleSessionDidStart),
            name: .AVCaptureSessionDidStartRunning,
            object: nil
        )
    }
    
    @objc private func handleSessionDidStart() {
        DispatchQueue.main.async { [weak self] in
            self?.applyMirroring()
        }
    }
    
    func configure(with session: AVCaptureSession, isMirrored: Bool) {
        self.isMirrored = isMirrored
        if previewLayer == nil {
            let layer = AVCaptureVideoPreviewLayer(session: session)
            layer.videoGravity = .resizeAspectFill
            self.layer?.addSublayer(layer)
            self.previewLayer = layer
        } else {
            previewLayer?.session = session
        }
        applyMirroring()
    }
    
    func updateSessionIfNeeded(_ session: AVCaptureSession, isMirrored: Bool) {
        self.isMirrored = isMirrored
        if previewLayer?.session != session {
            previewLayer?.session = session
        }
        applyMirroring()
    }
    
    override func layout() {
        super.layout()
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        previewLayer?.frame = bounds
        applyMirroring()
        CATransaction.commit()
    }
    
    private func applyMirroring() {
        guard let connection = previewLayer?.connection else {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { [weak self] in
                self?.applyMirroring()
            }
            return
        }
        if connection.isVideoMirroringSupported {
            connection.automaticallyAdjustsVideoMirroring = false
            connection.isVideoMirrored = isMirrored
        }
    }
}
