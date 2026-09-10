import SwiftUI

struct EdgeLightView: View {
    let shape: MirrorShape
    let intensity: Double
    
    var body: some View {
        ZStack {
            MirrorMaskShape(shape: shape)
                .stroke(Color(red: 1.0, green: 0.98, blue: 0.94).opacity(intensity * 0.4), lineWidth: 32)
                .blur(radius: 12)
            
            MirrorMaskShape(shape: shape)
                .stroke(Color.white.opacity(intensity * 0.75), lineWidth: 18)
                .blur(radius: 6)
            
            MirrorMaskShape(shape: shape)
                .stroke(Color.white.opacity(intensity), lineWidth: 10)
        }
        .allowsHitTesting(false)
    }
}
