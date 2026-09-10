import Foundation

enum CameraState: Equatable {
    case idle
    case loading
    case running
    case permissionDenied
    case noDevice
    case error(String)
}
