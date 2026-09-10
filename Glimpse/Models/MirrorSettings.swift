import SwiftUI

enum MirrorPosition: String, CaseIterable, Identifiable {
    case topCenter
    case topLeft
    case topRight
    case bottomLeft
    case bottomCenter
    case bottomRight
    
    var id: String { rawValue }
    
    var displayName: String {
        switch self {
        case .topCenter: return "Top Center (Under Camera)"
        case .topLeft: return "Top Left"
        case .topRight: return "Top Right"
        case .bottomLeft: return "Bottom Left"
        case .bottomCenter: return "Bottom Center"
        case .bottomRight: return "Bottom Right"
        }
    }
    
    var anchor: UnitPoint {
        switch self {
        case .topCenter: return .top
        case .topLeft: return .topLeading
        case .topRight: return .topTrailing
        case .bottomLeft: return .bottomLeading
        case .bottomCenter: return .bottom
        case .bottomRight: return .bottomTrailing
        }
    }
}

enum MirrorShape: String, CaseIterable, Identifiable {
    case roundedRectangle
    case circle
    
    var id: String { rawValue }
    
    var displayName: String {
        switch self {
        case .roundedRectangle: return "Rounded Rectangle"
        case .circle: return "Circle"
        }
    }
}

struct MirrorMaskShape: Shape {
    let shape: MirrorShape
    
    func path(in rect: CGRect) -> Path {
        switch shape {
        case .circle:
            return Circle().path(in: rect)
        case .roundedRectangle:
            return RoundedRectangle(cornerRadius: 18, style: .continuous).path(in: rect)
        }
    }
}

enum MirrorSize: String, CaseIterable, Identifiable {
    case small
    case medium
    case large
    
    var id: String { rawValue }
    
    var displayName: String {
        switch self {
        case .small: return "Small"
        case .medium: return "Medium"
        case .large: return "Large"
        }
    }
}

final class MirrorSettings: ObservableObject {
    static let shared = MirrorSettings()
    
    private let defaults = UserDefaults.standard
    
    @Published var isMirrored: Bool {
        didSet {
            defaults.set(isMirrored, forKey: "mirror_isMirrored")
        }
    }
    
    @Published var position: MirrorPosition {
        didSet {
            defaults.set(position.rawValue, forKey: "mirror_position")
        }
    }
    
    @Published var shape: MirrorShape {
        didSet {
            defaults.set(shape.rawValue, forKey: "mirror_shape")
        }
    }
    
    @Published var size: MirrorSize {
        didSet {
            defaults.set(size.rawValue, forKey: "mirror_size")
        }
    }
    
    @Published var isEdgeLightEnabled: Bool {
        didSet {
            defaults.set(isEdgeLightEnabled, forKey: "mirror_isEdgeLightEnabled")
        }
    }
    
    @Published var edgeLightIntensity: Double {
        didSet {
            defaults.set(edgeLightIntensity, forKey: "mirror_edgeLightIntensity")
        }
    }
    
    @Published var edgeLightWarmth: Double {
        didSet {
            defaults.set(edgeLightWarmth, forKey: "mirror_edgeLightWarmth")
        }
    }
    
    var currentDimensions: CGSize {
        switch shape {
        case .circle:
            switch size {
            case .small: return CGSize(width: 320, height: 320)
            case .medium: return CGSize(width: 400, height: 400)
            case .large: return CGSize(width: 480, height: 480)
            }
        case .roundedRectangle:
            switch size {
            case .small: return CGSize(width: 300, height: 400)
            case .medium: return CGSize(width: 380, height: 500)
            case .large: return CGSize(width: 460, height: 600)
            }
        }
    }
    
    var ambientColor: Color {
        let w = edgeLightWarmth
        if w < 0.5 {
            let t = w / 0.5
            return Color(red: 1.0, green: 0.72 + 0.20 * t, blue: 0.38 + 0.42 * t)
        } else {
            let t = (w - 0.5) / 0.5
            return Color(red: 1.0 - 0.25 * t, green: 0.92 - 0.06 * t, blue: 0.80 + 0.20 * t)
        }
    }
    
    var tubeColor: Color {
        let w = edgeLightWarmth
        if w < 0.5 {
            let t = w / 0.5
            return Color(red: 1.0, green: 0.82 + 0.14 * t, blue: 0.52 + 0.36 * t)
        } else {
            let t = (w - 0.5) / 0.5
            return Color(red: 1.0 - 0.14 * t, green: 0.96 - 0.03 * t, blue: 0.88 + 0.12 * t)
        }
    }
    
    var coreColor: Color {
        let w = edgeLightWarmth
        return Color(red: 1.0 - 0.06 * w, green: 0.98 + 0.01 * w, blue: 0.92 + 0.08 * w)
    }
    
    private init() {
        if defaults.object(forKey: "mirror_isMirrored") == nil {
            self.isMirrored = true
        } else {
            self.isMirrored = defaults.bool(forKey: "mirror_isMirrored")
        }
        
        if let rawPosition = defaults.string(forKey: "mirror_position"),
           let pos = MirrorPosition(rawValue: rawPosition) {
            self.position = pos
        } else {
            self.position = .topCenter
        }
        
        if let rawShape = defaults.string(forKey: "mirror_shape"),
           let shp = MirrorShape(rawValue: rawShape) {
            self.shape = shp
        } else {
            self.shape = .roundedRectangle
        }
        
        if let rawSize = defaults.string(forKey: "mirror_size"),
           let sz = MirrorSize(rawValue: rawSize) {
            self.size = sz
        } else {
            self.size = .medium
        }
        
        self.isEdgeLightEnabled = defaults.bool(forKey: "mirror_isEdgeLightEnabled")
        
        if defaults.object(forKey: "mirror_edgeLightIntensity") == nil {
            self.edgeLightIntensity = 1.0
        } else {
            self.edgeLightIntensity = defaults.double(forKey: "mirror_edgeLightIntensity")
        }
        
        if defaults.object(forKey: "mirror_edgeLightWarmth") == nil {
            self.edgeLightWarmth = 0.35
        } else {
            self.edgeLightWarmth = defaults.double(forKey: "mirror_edgeLightWarmth")
        }
    }
}
