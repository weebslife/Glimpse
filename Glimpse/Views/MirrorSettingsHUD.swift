import SwiftUI

struct MirrorSettingsHUD: View {
    @ObservedObject var settings: MirrorSettings
    var onClose: () -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack {
                Label("Settings", systemImage: "gearshape.fill")
                    .font(.system(size: 14, weight: .bold))
                    .foregroundColor(.white)
                
                Spacer()
                
                Button(action: onClose) {
                    Image(systemName: "xmark")
                        .font(.system(size: 10, weight: .bold))
                        .foregroundColor(.white.opacity(0.8))
                        .frame(width: 22, height: 22)
                        .background(.ultraThinMaterial)
                        .clipShape(Circle())
                }
                .buttonStyle(.plain)
            }
            
            Divider()
                .background(Color.white.opacity(0.2))
            
            VStack(alignment: .leading, spacing: 10) {
                Toggle(isOn: $settings.isMirrored) {
                    HStack(spacing: 8) {
                        Image(systemName: "arrow.left.and.right.righttriangle.left.righttriangle.right")
                        Text("Mirror Reflection")
                    }
                    .font(.system(size: 12, weight: .medium))
                    .foregroundColor(.white)
                }
                .toggleStyle(.switch)
                
                Divider()
                    .background(Color.white.opacity(0.1))
                
                VStack(alignment: .leading, spacing: 6) {
                    Text("Shape")
                        .font(.system(size: 11, weight: .semibold))
                        .foregroundColor(.white.opacity(0.7))
                    
                    HStack(spacing: 8) {
                        Button(action: {
                            withAnimation(.spring(response: 0.35, dampingFraction: 0.8)) {
                                settings.shape = .roundedRectangle
                            }
                        }) {
                            HStack(spacing: 4) {
                                Image(systemName: "rectangle.roundedtop")
                                Text("Rectangle")
                            }
                            .font(.system(size: 11, weight: .medium))
                            .foregroundColor(settings.shape == .roundedRectangle ? .black : .white)
                            .padding(.horizontal, 10)
                            .padding(.vertical, 6)
                            .frame(maxWidth: .infinity)
                            .background(settings.shape == .roundedRectangle ? Color.white : Color.white.opacity(0.12))
                            .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
                        }
                        .buttonStyle(.plain)
                        
                        Button(action: {
                            withAnimation(.spring(response: 0.35, dampingFraction: 0.8)) {
                                settings.shape = .circle
                            }
                        }) {
                            HStack(spacing: 4) {
                                Image(systemName: "circle")
                                Text("Circle")
                            }
                            .font(.system(size: 11, weight: .medium))
                            .foregroundColor(settings.shape == .circle ? .black : .white)
                            .padding(.horizontal, 10)
                            .padding(.vertical, 6)
                            .frame(maxWidth: .infinity)
                            .background(settings.shape == .circle ? Color.white : Color.white.opacity(0.12))
                            .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
                        }
                        .buttonStyle(.plain)
                    }
                }
                
                VStack(alignment: .leading, spacing: 6) {
                    Text("Size")
                        .font(.system(size: 11, weight: .semibold))
                        .foregroundColor(.white.opacity(0.7))
                    
                    HStack(spacing: 8) {
                        ForEach(MirrorSize.allCases) { sz in
                            Button(action: {
                                withAnimation(.spring(response: 0.35, dampingFraction: 0.8)) {
                                    settings.size = sz
                                }
                            }) {
                                Text(sz.displayName)
                                    .font(.system(size: 11, weight: .medium))
                                    .foregroundColor(settings.size == sz ? .black : .white)
                                    .padding(.horizontal, 6)
                                    .padding(.vertical, 6)
                                    .frame(maxWidth: .infinity)
                                    .background(settings.size == sz ? Color.white : Color.white.opacity(0.12))
                                    .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
                            }
                            .buttonStyle(.plain)
                        }
                    }
                }
                
                VStack(alignment: .leading, spacing: 6) {
                    Text("Screen Position")
                        .font(.system(size: 11, weight: .semibold))
                        .foregroundColor(.white.opacity(0.7))
                    
                    Picker("", selection: $settings.position) {
                        ForEach(MirrorPosition.allCases) { pos in
                            Text(pos.displayName).tag(pos)
                        }
                    }
                    .pickerStyle(.menu)
                    .labelsHidden()
                }
                
                Divider()
                    .background(Color.white.opacity(0.1))
                
                Toggle(isOn: $settings.isEdgeLightEnabled) {
                    HStack(spacing: 8) {
                        Image(systemName: "sun.max.fill")
                        Text("Edge Light")
                    }
                    .font(.system(size: 12, weight: .medium))
                    .foregroundColor(.white)
                }
                .toggleStyle(.switch)
                
                if settings.isEdgeLightEnabled {
                    VStack(spacing: 8) {
                        HStack(spacing: 8) {
                            Image(systemName: "sun.max")
                                .font(.system(size: 11))
                                .foregroundColor(.white.opacity(0.7))
                                .frame(width: 16)
                            
                            Slider(value: $settings.edgeLightIntensity, in: 0.2...1.0)
                                .accentColor(.white)
                        }
                        
                        HStack(spacing: 8) {
                            Image(systemName: "sun.haze.fill")
                                .font(.system(size: 11))
                                .foregroundColor(.white.opacity(0.7))
                                .frame(width: 16)
                            
                            ZStack {
                                RoundedRectangle(cornerRadius: 4, style: .continuous)
                                    .fill(
                                        LinearGradient(
                                            gradient: Gradient(colors: [
                                                Color(red: 1.0, green: 0.70, blue: 0.35),
                                                Color(red: 1.0, green: 0.96, blue: 0.88),
                                                Color(red: 0.78, green: 0.88, blue: 1.0)
                                            ]),
                                            startPoint: .leading,
                                            endPoint: .trailing
                                        )
                                    )
                                    .frame(height: 6)
                                    .opacity(0.85)
                                
                                Slider(value: $settings.edgeLightWarmth, in: 0.0...1.0)
                                    .accentColor(.clear)
                            }
                        }
                    }
                    .padding(.top, 2)
                }
            }
        }
        .padding(16)
        .frame(maxWidth: 300)
        .background(.ultraThinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .stroke(Color.white.opacity(0.2), lineWidth: 1)
        )
        .shadow(color: .black.opacity(0.4), radius: 16, x: 0, y: 8)
    }
}
