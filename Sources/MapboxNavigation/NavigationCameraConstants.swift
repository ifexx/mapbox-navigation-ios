import Foundation

public extension Notification.Name {

    static let navigationCameraStateDidChange: Notification.Name = .init(rawValue: "NavigationCameraStateDidChange")
}

extension NavigationCamera {
    
    public static let navigationCameraStateDidChangeKey: String = "NavigationCameraStateDidChange"
}

extension NavigationViewportDataSource {
    
    public static let followingMobileCameraKey: String = "FollowingMobileCamera"
    public static let overviewMobileCameraKey: String = "OverviewMobileCamera"
    public static let followingHeadUnitCameraKey: String = "FollowingHeadUnitCamera"
    public static let overviewHeadUnitCameraKey: String = "OverviewHeadUnitCamera"
}
