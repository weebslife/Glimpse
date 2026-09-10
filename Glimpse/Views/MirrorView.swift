import SwiftUI

struct MirrorView: View {
    @ObservedObject var cameraManager: CameraManager
    @ObservedObject var settings: MirrorSettings = .shared
    @Binding var isVisible: Bool
    var onClose: () -> Void = {}
    
    @State private var isControlsHovered: Bool = false
    @State private var isSettingsOpen: Bool = false
    
    var body: some View {
        ZStack {
            Color.black
            
            CameraPreview(session: cameraManager.session, isMirrored: settings.isMirrored, cameraState: cameraManager.state)
                .opacity(cameraManager.state == .running ? 1.0 : 0.0)
                .animation(.easeInOut(duration: 0.25), value: cameraManager.state == .running)
            
            if cameraManager.state == .loading || cameraManager.state == .idle {
                loadingView
                    .opacity(cameraManager.state == .loading ? 1.0 : 0.0)
                    .animation(.easeInOut(duration: 0.2), value: cameraManager.state == .loading)
            }
            
            switch cameraManager.state {
            case .permissionDenied, .noDevice, .error:
                CameraErrorView(state: cameraManager.state) {
                    cameraManager.retry()
                }
                .transition(.opacity)
            default:
                EmptyView()
            }
            
            VStack {
                topBar
                    .opacity(isControlsHovered || isSettingsOpen || cameraManager.state != .running ? 1.0 : 0.2)
                    .animation(.easeInOut(duration: 0.2), value: isControlsHovered || isSettingsOpen)
                
                Spacer()
            }
            
            if isSettingsOpen {
                Color.black.opacity(0.3)
                    .contentShape(Rectangle())
                    .onTapGesture {
                        withAnimation(.spring(response: 0.25, dampingFraction: 0.8)) {
                            isSettingsOpen = false
                        }
                    }
                
                MirrorSettingsHUD(settings: settings) {
                    withAnimation(.spring(response: 0.25, dampingFraction: 0.8)) {
                        isSettingsOpen = false
                    }
                }
                .transition(.scale(scale: 0.9).combined(with: .opacity))
            }
        }
        .frame(width: settings.currentDimensions.width, height: settings.currentDimensions.height)
        .clipShape(MirrorMaskShape(shape: settings.shape))
        .overlay(
            MirrorMaskShape(shape: settings.shape)
                .stroke(Color.white.opacity(0.15), lineWidth: 1)
        )
        .scaleEffect(isVisible ? 1.0 : 0.15, anchor: settings.position.anchor)
        .opacity(isVisible ? 1.0 : 0.0)
        .onHover { hovering in
            isControlsHovered = hovering
        }
    }
    
    private var loadingView: some View {
        VStack(spacing: 16) {
            ProgressView()
                .scaleEffect(1.2)
                .progressViewStyle(.circular)
            
            Text("Starting Camera...")
                .font(.system(size: 13, weight: .medium))
                .foregroundColor(.white.opacity(0.85))
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.black.opacity(0.6))
    }
    
    private var topBar: some View {
        HStack(spacing: 8) {
            HStack(spacing: 6) {
                Circle()
                    .fill(statusColor)
                    .frame(width: 8, height: 8)
                
                Text("Glimpse")
                    .font(.system(size: 12, weight: .semibold))
                    .foregroundColor(.white)
            }
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .background(.ultraThinMaterial)
            .clipShape(Capsule())
            
            Spacer()
            
            Button(action: {
                withAnimation(.spring(response: 0.25, dampingFraction: 0.8)) {
                    settings.isEdgeLightEnabled.toggle()
                }
            }) {
                Image(systemName: settings.isEdgeLightEnabled ? "sun.max.fill" : "sun.max")
                    .font(.system(size: 11, weight: .semibold))
                    .foregroundColor(settings.isEdgeLightEnabled ? .yellow : .white.opacity(0.85))
                    .frame(width: 24, height: 24)
                    .background(.ultraThinMaterial)
                    .clipShape(Circle())
            }
            .buttonStyle(.plain)
            .help(settings.isEdgeLightEnabled ? "Turn Off Screen Edge Light" : "Turn On Screen Edge Light")
            
            Button(action: {
                withAnimation(.spring(response: 0.25, dampingFraction: 0.8)) {
                    isSettingsOpen.toggle()
                }
            }) {
                Image(systemName: "gearshape.fill")
                    .font(.system(size: 11, weight: .semibold))
                    .foregroundColor(isSettingsOpen ? .cyan : .white.opacity(0.85))
                    .frame(width: 24, height: 24)
                    .background(.ultraThinMaterial)
                    .clipShape(Circle())
            }
            .buttonStyle(.plain)
            .help("Settings")
            
            Button(action: onClose) {
                Image(systemName: "xmark")
                    .font(.system(size: 10, weight: .bold))
                    .foregroundColor(.white.opacity(0.85))
                    .frame(width: 24, height: 24)
                    .background(.ultraThinMaterial)
                    .clipShape(Circle())
            }
            .buttonStyle(.plain)
            .help("Close Glimpse (Esc)")
            
            Button(action: {
                AppDelegate.confirmQuit()
            }) {
                Image(systemName: "power")
                    .font(.system(size: 10, weight: .bold))
                    .foregroundColor(.red.opacity(0.85))
                    .frame(width: 24, height: 24)
                    .background(.ultraThinMaterial)
                    .clipShape(Circle())
            }
            .buttonStyle(.plain)
            .help("Quit Glimpse")
        }
        .padding(.horizontal, 14)
        .padding(.top, 18)
    }
    
    private var statusColor: Color {
        switch cameraManager.state {
        case .running:
            return .green
        case .loading:
            return .orange
        case .permissionDenied, .error:
            return .red
        case .noDevice:
            return .yellow
        case .idle:
            return .gray
        }
    }
}
