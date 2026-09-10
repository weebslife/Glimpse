import SwiftUI

struct FullScreenEdgeLightView: View {
    @ObservedObject var controller: FullScreenEdgeLightController = .shared
    @ObservedObject var settings: MirrorSettings = .shared
    
    var body: some View {
        GeometryReader { proxy in
            let cornerRadius: CGFloat = min(proxy.size.width, proxy.size.height) * 0.08
            let shape = RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
            let intensity = settings.edgeLightIntensity
            
            ZStack {
                shape
                    .stroke(settings.ambientColor.opacity(intensity * 0.45), lineWidth: 96)
                    .blur(radius: 36)
                
                shape
                    .stroke(settings.tubeColor.opacity(intensity * 0.7), lineWidth: 68)
                    .blur(radius: 16)
                
                shape
                    .stroke(settings.tubeColor.opacity(intensity * 0.9), lineWidth: 50)
                    .blur(radius: 5)
                
                shape
                    .stroke(settings.coreColor.opacity(intensity), lineWidth: 36)
                    .blur(radius: 2)
                
                shape
                    .stroke(Color.white.opacity(intensity), lineWidth: 18)
            }
            .padding(.horizontal, 28)
            .padding(.top, 18)
            .padding(.bottom, 28)
            .mask(
                ZStack {
                    Color.white
                    
                    if let cursor = controller.cursorPoint {
                        RadialGradient(
                            gradient: Gradient(stops: [
                                .init(color: .black, location: 0.0),
                                .init(color: .black.opacity(0.85), location: 0.35),
                                .init(color: .black.opacity(0.4), location: 0.65),
                                .init(color: .clear, location: 1.0)
                            ]),
                            center: UnitPoint(x: cursor.x / proxy.size.width, y: cursor.y / proxy.size.height),
                            startRadius: 0,
                            endRadius: 150
                        )
                        .blendMode(.destinationOut)
                    }
                }
                .compositingGroup()
            )
        }
        .edgesIgnoringSafeArea(.all)
        .allowsHitTesting(false)
    }
}
