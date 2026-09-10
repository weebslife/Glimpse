import AppKit
import SwiftUI
import Combine

final class FloatingMirrorPanel: NSPanel {
    override var canBecomeKey: Bool { true }
    override var canBecomeMain: Bool { true }
}

final class WindowViewModel: ObservableObject {
    @Published var isVisible: Bool = false
}

final class MirrorWindowController: NSObject, NSWindowDelegate {
    private let cameraManager: CameraManager
    private let settings = MirrorSettings.shared
    private let viewModel = WindowViewModel()
    private var panel: FloatingMirrorPanel!
    private var globalEventMonitor: Any?
    private var localEventMonitor: Any?
    private var lastHideTime: Date = .distantPast
    private var cancellables = Set<AnyCancellable>()
    private var isClosing: Bool = false
    
    init(cameraManager: CameraManager) {
        self.cameraManager = cameraManager
        super.init()
        setupPanel()
        setupSettingsObservers()
    }
    
    deinit {
        removeMonitors()
    }
    
    private func setupPanel() {
        let initialSize = settings.currentDimensions
        panel = FloatingMirrorPanel(
            contentRect: NSRect(x: 0, y: 0, width: initialSize.width, height: initialSize.height),
            styleMask: [.borderless, .nonactivatingPanel],
            backing: .buffered,
            defer: false
        )
        
        panel.isFloatingPanel = true
        panel.level = .statusBar
        panel.isOpaque = false
        panel.backgroundColor = .clear
        panel.hasShadow = true
        panel.delegate = self
        panel.collectionBehavior = [.canJoinAllSpaces, .fullScreenAuxiliary]
        
        let mirrorView = MirrorView(
            cameraManager: cameraManager,
            settings: settings,
            isVisible: Binding(
                get: { [weak self] in self?.viewModel.isVisible ?? false },
                set: { [weak self] in self?.viewModel.isVisible = $0 }
            ),
            onClose: { [weak self] in
                self?.hide()
            }
        )
        
        panel.contentView = NSHostingView(rootView: mirrorView)
    }
    
    private func setupSettingsObservers() {
        Publishers.Merge3(
            settings.$position.map { _ in () },
            settings.$shape.map { _ in () },
            settings.$size.map { _ in () }
        )
        .receive(on: DispatchQueue.main)
        .sink { [weak self] _ in
            guard let self = self, self.panel.isVisible else { return }
            self.updatePositionAndSize(animate: true)
        }
        .store(in: &cancellables)
    }
    
    func toggle() {
        if panel.isVisible && !isClosing {
            hide()
        } else {
            if Date().timeIntervalSince(lastHideTime) < 0.3 {
                return
            }
            show()
        }
    }
    
    func show() {
        guard !panel.isVisible || isClosing else { return }
        isClosing = false
        updatePositionAndSize(animate: false)
        cameraManager.start()
        FullScreenEdgeLightController.shared.setMirrorActive(true)
        panel.makeKeyAndOrderFront(nil)
        NSApp.activate(ignoringOtherApps: true)
        setupMonitors()
        
        DispatchQueue.main.async {
            withAnimation(.spring(response: 0.38, dampingFraction: 0.72)) {
                self.viewModel.isVisible = true
            }
        }
    }
    
    func hide() {
        guard panel.isVisible, !isClosing else { return }
        isClosing = true
        lastHideTime = Date()
        FullScreenEdgeLightController.shared.setMirrorActive(false)
        
        withAnimation(.spring(response: 0.26, dampingFraction: 0.85)) {
            self.viewModel.isVisible = false
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.24) { [weak self] in
            guard let self = self, self.isClosing else { return }
            self.panel.orderOut(nil)
            self.cameraManager.stop()
            self.removeMonitors()
            self.isClosing = false
        }
    }
    
    private func updatePositionAndSize(animate: Bool) {
        let screen = targetScreen()
        let screenFrame = screen.frame
        let visibleFrame = screen.visibleFrame
        let dims = settings.currentDimensions
        
        let width = dims.width
        let height = dims.height
        
        let x: CGFloat
        let y: CGFloat
        
        switch settings.position {
        case .topCenter:
            x = screenFrame.midX - (width / 2.0)
            y = screenFrame.maxY - height
        case .topLeft:
            x = screenFrame.minX + 24.0
            y = screenFrame.maxY - height
        case .topRight:
            x = screenFrame.maxX - width - 24.0
            y = screenFrame.maxY - height
        case .bottomLeft:
            x = visibleFrame.minX + 24.0
            y = visibleFrame.minY + 24.0
        case .bottomCenter:
            x = screenFrame.midX - (width / 2.0)
            y = visibleFrame.minY + 24.0
        case .bottomRight:
            x = visibleFrame.maxX - width - 24.0
            y = visibleFrame.minY + 24.0
        }
        
        let targetRect = NSRect(x: x, y: y, width: width, height: height)
        panel.setFrame(targetRect, display: true, animate: animate)
    }
    
    private func targetScreen() -> NSScreen {
        if settings.position == .topCenter {
            for screen in NSScreen.screens {
                if screen.localizedName.localizedCaseInsensitiveContains("built-in") {
                    return screen
                }
            }
        }
        return NSScreen.main ?? NSScreen.screens.first!
    }
    
    private func setupMonitors() {
        removeMonitors()
        
        globalEventMonitor = NSEvent.addGlobalMonitorForEvents(matching: [.leftMouseDown, .rightMouseDown]) { [weak self] _ in
            guard let self = self, self.panel.isVisible, !self.isClosing else { return }
            let mouseLocation = NSEvent.mouseLocation
            if !self.panel.frame.contains(mouseLocation) {
                self.hide()
            }
        }
        
        localEventMonitor = NSEvent.addLocalMonitorForEvents(matching: .keyDown) { [weak self] event in
            if event.keyCode == 53 {
                self?.hide()
                return nil
            }
            return event
        }
    }
    
    private func removeMonitors() {
        if let monitor = globalEventMonitor {
            NSEvent.removeMonitor(monitor)
            globalEventMonitor = nil
        }
        if let monitor = localEventMonitor {
            NSEvent.removeMonitor(monitor)
            localEventMonitor = nil
        }
    }
    
    func windowDidResignKey(_ notification: Notification) {
        if !isClosing {
            hide()
        }
    }
}
