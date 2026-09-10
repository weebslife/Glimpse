import AppKit
import SwiftUI
import Combine

final class FullScreenEdgeLightController: ObservableObject {
    static let shared = FullScreenEdgeLightController()
    
    @Published var cursorPoint: CGPoint? = nil
    
    private var window: NSPanel?
    private let settings = MirrorSettings.shared
    private var cancellables = Set<AnyCancellable>()
    private var isMirrorActive: Bool = false
    private var mouseMonitor: Any?
    
    private init() {
        setupObservers()
    }
    
    private func setupObservers() {
        settings.$isEdgeLightEnabled
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                guard let self = self else { return }
                self.evaluateVisibility()
            }
            .store(in: &cancellables)
    }
    
    func setMirrorActive(_ active: Bool) {
        isMirrorActive = active
        evaluateVisibility()
    }
    
    private func evaluateVisibility() {
        if isMirrorActive && settings.isEdgeLightEnabled {
            show()
        } else {
            hide()
        }
    }
    
    private func show() {
        let screen = targetScreen()
        let frame = screen.frame
        
        if window == nil {
            let panel = NSPanel(
                contentRect: frame,
                styleMask: [.borderless, .nonactivatingPanel],
                backing: .buffered,
                defer: false
            )
            panel.isFloatingPanel = true
            panel.level = NSWindow.Level(Int(CGWindowLevelForKey(.statusWindow)) - 1)
            panel.isOpaque = false
            panel.backgroundColor = .clear
            panel.hasShadow = false
            panel.ignoresMouseEvents = true
            panel.collectionBehavior = [.canJoinAllSpaces, .fullScreenAuxiliary]
            panel.contentView = NSHostingView(rootView: FullScreenEdgeLightView(controller: self))
            self.window = panel
        }
        
        guard let panel = window else { return }
        panel.setFrame(frame, display: true)
        startMouseTracking()
        
        if !panel.isVisible {
            panel.alphaValue = 0.0
            panel.orderFront(nil)
            NSAnimationContext.runAnimationGroup { context in
                context.duration = 0.25
                panel.animator().alphaValue = 1.0
            }
        }
    }
    
    private func hide() {
        stopMouseTracking()
        guard let panel = window, panel.isVisible else { return }
        NSAnimationContext.runAnimationGroup({ context in
            context.duration = 0.25
            panel.animator().alphaValue = 0.0
        }, completionHandler: {
            panel.orderOut(nil)
        })
    }
    
    private func startMouseTracking() {
        guard mouseMonitor == nil else { return }
        mouseMonitor = NSEvent.addGlobalMonitorForEvents(matching: [.mouseMoved, .leftMouseDragged, .rightMouseDragged]) { [weak self] _ in
            guard let self = self, let panel = self.window, panel.isVisible else { return }
            let mouseLoc = NSEvent.mouseLocation
            let localX = mouseLoc.x - panel.frame.minX
            let localY = panel.frame.height - (mouseLoc.y - panel.frame.minY)
            DispatchQueue.main.async {
                self.cursorPoint = CGPoint(x: localX, y: localY)
            }
        }
    }
    
    private func stopMouseTracking() {
        if let monitor = mouseMonitor {
            NSEvent.removeMonitor(monitor)
            mouseMonitor = nil
        }
        cursorPoint = nil
    }
    
    private func targetScreen() -> NSScreen {
        for screen in NSScreen.screens {
            if screen.localizedName.localizedCaseInsensitiveContains("built-in") {
                return screen
            }
        }
        return NSScreen.main ?? NSScreen.screens.first!
    }
}
