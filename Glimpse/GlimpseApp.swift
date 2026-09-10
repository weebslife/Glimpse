import SwiftUI

@main
struct GlimpseApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    var body: some Scene {
        Settings {
            EmptyView()
        }
    }
}

final class AppDelegate: NSObject, NSApplicationDelegate {
    private var statusItem: NSStatusItem!
    private var windowController: MirrorWindowController?
    private var edgeLightController: FullScreenEdgeLightController?
    let cameraManager = CameraManager()
    private let settings = MirrorSettings.shared
    
    func applicationDidFinishLaunching(_ notification: Notification) {
        setupStatusItem()
        edgeLightController = FullScreenEdgeLightController.shared
        windowController = MirrorWindowController(cameraManager: cameraManager)
    }
    
    private func setupStatusItem() {
        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
        if let button = statusItem.button {
            button.image = NSImage(systemSymbolName: "camera.fill", accessibilityDescription: "Glimpse")
            button.target = self
            button.action = #selector(statusItemClicked)
            button.sendAction(on: [.leftMouseUp, .rightMouseUp])
        }
    }
    
    @objc private func statusItemClicked() {
        guard let event = NSApp.currentEvent else {
            windowController?.toggle()
            return
        }
        
        if event.type == .rightMouseUp {
            let menu = buildContextMenu()
            statusItem.menu = menu
            statusItem.button?.performClick(nil)
            statusItem.menu = nil
        } else {
            windowController?.toggle()
        }
    }
    
    private func buildContextMenu() -> NSMenu {
        let menu = NSMenu()
        
        let mirrorItem = NSMenuItem(title: "Mirror Reflection", action: #selector(toggleMirrorReflection), keyEquivalent: "")
        mirrorItem.target = self
        mirrorItem.state = settings.isMirrored ? .on : .off
        menu.addItem(mirrorItem)
        
        let edgeLightItem = NSMenuItem(title: "FaceTime Edge Light", action: #selector(toggleEdgeLight), keyEquivalent: "")
        edgeLightItem.target = self
        edgeLightItem.state = settings.isEdgeLightEnabled ? .on : .off
        menu.addItem(edgeLightItem)
        
        menu.addItem(NSMenuItem.separator())
        
        let positionItem = NSMenuItem(title: "Position", action: nil, keyEquivalent: "")
        let positionMenu = NSMenu()
        for pos in MirrorPosition.allCases {
            let item = NSMenuItem(title: pos.displayName, action: #selector(selectPosition(_:)), keyEquivalent: "")
            item.target = self
            item.representedObject = pos
            item.state = settings.position == pos ? .on : .off
            positionMenu.addItem(item)
        }
        positionItem.submenu = positionMenu
        menu.addItem(positionItem)
        
        let shapeItem = NSMenuItem(title: "Shape", action: nil, keyEquivalent: "")
        let shapeMenu = NSMenu()
        for shp in MirrorShape.allCases {
            let item = NSMenuItem(title: shp.displayName, action: #selector(selectShape(_:)), keyEquivalent: "")
            item.target = self
            item.representedObject = shp
            item.state = settings.shape == shp ? .on : .off
            shapeMenu.addItem(item)
        }
        shapeItem.submenu = shapeMenu
        menu.addItem(shapeItem)
        
        let sizeItem = NSMenuItem(title: "Size", action: nil, keyEquivalent: "")
        let sizeMenu = NSMenu()
        for sz in MirrorSize.allCases {
            let item = NSMenuItem(title: sz.displayName, action: #selector(selectSize(_:)), keyEquivalent: "")
            item.target = self
            item.representedObject = sz
            item.state = settings.size == sz ? .on : .off
            sizeMenu.addItem(item)
        }
        sizeItem.submenu = sizeMenu
        menu.addItem(sizeItem)
        
        menu.addItem(NSMenuItem.separator())
        
        let toggleItem = NSMenuItem(title: "Toggle Glimpse", action: #selector(toggleMirrorWindow), keyEquivalent: "")
        toggleItem.target = self
        menu.addItem(toggleItem)
        
        let quitItem = NSMenuItem(title: "Quit Glimpse", action: #selector(terminateApp), keyEquivalent: "q")
        quitItem.target = self
        menu.addItem(quitItem)
        
        return menu
    }
    
    @objc private func toggleMirrorReflection() {
        settings.isMirrored.toggle()
    }
    
    @objc private func toggleEdgeLight() {
        settings.isEdgeLightEnabled.toggle()
    }
    
    @objc private func selectPosition(_ sender: NSMenuItem) {
        if let pos = sender.representedObject as? MirrorPosition {
            settings.position = pos
        }
    }
    
    @objc private func selectShape(_ sender: NSMenuItem) {
        if let shp = sender.representedObject as? MirrorShape {
            settings.shape = shp
        }
    }
    
    @objc private func selectSize(_ sender: NSMenuItem) {
        if let sz = sender.representedObject as? MirrorSize {
            settings.size = sz
        }
    }
    
    @objc private func toggleMirrorWindow() {
        windowController?.toggle()
    }
    
    @objc private func terminateApp() {
        AppDelegate.confirmQuit()
    }
    
    static func confirmQuit() {
        let alert = NSAlert()
        alert.messageText = "Quit Glimpse?"
        alert.informativeText = "Are you sure you want to quit Glimpse?"
        alert.alertStyle = .warning
        alert.addButton(withTitle: "Quit")
        alert.addButton(withTitle: "Cancel")
        NSApp.activate(ignoringOtherApps: true)
        if alert.runModal() == .alertFirstButtonReturn {
            NSApplication.shared.terminate(nil)
        }
    }
}
