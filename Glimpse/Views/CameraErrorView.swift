import SwiftUI

struct CameraErrorView: View {
    let state: CameraState
    let onRetry: () -> Void
    
    var body: some View {
        VStack(spacing: 16) {
            Spacer()
            
            switch state {
            case .permissionDenied:
                permissionDeniedContent
            case .noDevice:
                noDeviceContent
            case .error(let message):
                genericErrorContent(message: message)
            default:
                EmptyView()
            }
            
            Spacer()
        }
        .padding(24)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(nsColor: .windowBackgroundColor).opacity(0.95))
    }
    
    private var permissionDeniedContent: some View {
        VStack(spacing: 14) {
            Image(systemName: "camera.badge.ellipsis")
                .font(.system(size: 44, weight: .medium))
                .foregroundColor(.orange)
            
            Text("Camera Access Required")
                .font(.headline)
                .foregroundColor(.primary)
            
            Text("Glimpse needs permission to access your camera to show your live preview.\n\nEnable camera access in:\nSystem Settings → Privacy & Security → Camera")
                .font(.subheadline)
                .multilineTextAlignment(.center)
                .foregroundColor(.secondary)
                .padding(.horizontal, 8)
            
            VStack(spacing: 8) {
                Button(action: {
                    SystemSettings.openCameraPrivacy()
                }) {
                    Label("Open System Settings", systemImage: "gearshape")
                        .frame(maxWidth: 200)
                }
                .buttonStyle(.borderedProminent)
                .controlSize(.regular)
                
                Button(action: onRetry) {
                    Label("Check Again", systemImage: "arrow.clockwise")
                        .frame(maxWidth: 200)
                }
                .buttonStyle(.bordered)
                .controlSize(.regular)
            }
            .padding(.top, 4)
        }
    }
    
    private var noDeviceContent: some View {
        VStack(spacing: 14) {
            Image(systemName: "camera.trianglebadge.exclamationmark.fill")
                .font(.system(size: 44, weight: .medium))
                .foregroundColor(.yellow)
            
            Text("No Camera Detected")
                .font(.headline)
                .foregroundColor(.primary)
            
            Text("Please connect a webcam or check if your Mac's built-in camera is available.")
                .font(.subheadline)
                .multilineTextAlignment(.center)
                .foregroundColor(.secondary)
                .padding(.horizontal, 16)
            
            Button(action: onRetry) {
                Label("Refresh", systemImage: "arrow.clockwise")
            }
            .buttonStyle(.borderedProminent)
            .controlSize(.regular)
        }
    }
    
    private func genericErrorContent(message: String) -> some View {
        VStack(spacing: 14) {
            Image(systemName: "exclamationmark.triangle.fill")
                .font(.system(size: 44, weight: .medium))
                .foregroundColor(.red)
            
            Text("Camera Unavailable")
                .font(.headline)
                .foregroundColor(.primary)
            
            Text(message)
                .font(.subheadline)
                .multilineTextAlignment(.center)
                .foregroundColor(.secondary)
                .padding(.horizontal, 16)
            
            Button(action: onRetry) {
                Label("Try Again", systemImage: "arrow.clockwise")
            }
            .buttonStyle(.borderedProminent)
            .controlSize(.regular)
        }
    }
}
