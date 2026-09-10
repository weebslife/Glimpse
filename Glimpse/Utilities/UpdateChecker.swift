import AppKit

final class UpdateChecker {
    static let shared = UpdateChecker()
    
    private let releaseURL = URL(string: "https://api.github.com/repos/weebslife/Glimpse/releases/latest")!
    
    private init() {}
    
    func checkForUpdates(silent: Bool = false) {
        var request = URLRequest(url: releaseURL)
        request.setValue("Glimpse-App", forHTTPHeaderField: "User-Agent")
        request.setValue("application/vnd.github.v3+json", forHTTPHeaderField: "Accept")
        request.timeoutInterval = 10
        
        let task = URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
            guard let self = self else { return }
            
            if let error = error {
                if !silent {
                    DispatchQueue.main.async {
                        self.showErrorAlert(message: error.localizedDescription)
                    }
                }
                return
            }
            
            guard let data = data,
                  let release = try? JSONDecoder().decode(GitHubRelease.self, from: data) else {
                if !silent {
                    DispatchQueue.main.async {
                        self.showErrorAlert(message: "Failed to parse release information from GitHub.")
                    }
                }
                return
            }
            
            DispatchQueue.main.async {
                self.processRelease(release, silent: silent)
            }
        }
        task.resume()
    }
    
    private func processRelease(_ release: GitHubRelease, silent: Bool) {
        let currentVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "1.0.0"
        let latestVersion = release.tagName.trimmingCharacters(in: CharacterSet(charactersIn: "vV"))
        
        if isVersionNewer(latest: latestVersion, current: currentVersion) {
            showUpdateAvailableAlert(release: release, currentVersion: currentVersion, latestVersion: latestVersion)
        } else if !silent {
            showUpToDateAlert(currentVersion: currentVersion)
        }
    }
    
    private func isVersionNewer(latest: String, current: String) -> Bool {
        return latest.compare(current, options: .numeric) == .orderedDescending
    }
    
    private func showUpdateAvailableAlert(release: GitHubRelease, currentVersion: String, latestVersion: String) {
        let alert = NSAlert()
        alert.messageText = "Update Available"
        alert.informativeText = "Glimpse \(release.tagName) is available (you are currently on v\(currentVersion)). Would you like to view and download the latest release?"
        alert.alertStyle = .informational
        alert.addButton(withTitle: "Download Update")
        alert.addButton(withTitle: "Later")
        
        NSApp.activate(ignoringOtherApps: true)
        let response = alert.runModal()
        if response == .alertFirstButtonReturn {
            if let url = URL(string: release.htmlUrl) {
                NSWorkspace.shared.open(url)
            }
        }
    }
    
    private func showUpToDateAlert(currentVersion: String) {
        let alert = NSAlert()
        alert.messageText = "You're Up to Date"
        alert.informativeText = "Glimpse v\(currentVersion) is currently the newest version available."
        alert.alertStyle = .informational
        alert.addButton(withTitle: "OK")
        
        NSApp.activate(ignoringOtherApps: true)
        alert.runModal()
    }
    
    private func showErrorAlert(message: String) {
        let alert = NSAlert()
        alert.messageText = "Update Check Failed"
        alert.informativeText = "Could not check for updates: \(message)"
        alert.alertStyle = .warning
        alert.addButton(withTitle: "OK")
        
        NSApp.activate(ignoringOtherApps: true)
        alert.runModal()
    }
}

private struct GitHubRelease: Codable {
    let tagName: String
    let htmlUrl: String
    let name: String?
    let body: String?
    
    enum CodingKeys: String, CodingKey {
        case tagName = "tag_name"
        case htmlUrl = "html_url"
        case name
        case body
    }
}
