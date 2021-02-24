import Foundation
import MapboxMaps

extension CameraOptions {
    
    public struct NotificationUserInfoKey: Hashable, Equatable, RawRepresentable {
        public typealias RawValue = String

        public var rawValue: String

        public init(rawValue: String) {
            self.rawValue = rawValue
        }
        
        public static let followingMobileCameraKey: NotificationUserInfoKey = .init(rawValue: "FollowingMobileCamera")
        
        public static let overviewMobileCameraKey: NotificationUserInfoKey = .init(rawValue: "OverviewMobileCamera")
        
        public static let followingHeadUnitCameraKey: NotificationUserInfoKey = .init(rawValue: "FollowingHeadUnitCamera")
        
        public static let overviewHeadUnitCameraKey: NotificationUserInfoKey = .init(rawValue: "OverviewHeadUnitCamera")
    }
}
