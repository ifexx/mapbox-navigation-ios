import UIKit
import MapboxMaps
import MapboxCoreNavigation

public class NavigationViewportDataSource: ViewportDataSource {
    
    public var delegate: ViewportDataSourceDelegate?
    
    public var followingMobileCamera: CameraOptions = CameraOptions()
    
    public var followingHeadUnitCamera: CameraOptions = CameraOptions()

    public var overviewMobileCamera: CameraOptions = CameraOptions()
    
    public var overviewHeadUnitCamera: CameraOptions = CameraOptions()
    
    /**
     Returns the altitude that the `NavigationCamera` initally defaults to.
     */
    // TODO: On CarPlay `defaultAltitude` should be set to 500.
    public var defaultAltitude: CLLocationDistance = 1000.0
    
    /**
     Returns the altitude the map conditionally zooms out to when user is on a motorway, and the maneuver length is sufficently long.
     */
    // TODO: Implement ability to handle `zoomedOutMotorwayAltitude` on iOS (2000 meters) and CarPlay (1000 meters).
    public var zoomedOutMotorwayAltitude: CLLocationDistance = 2000.0
    
    /**
     Returns the threshold for what the map considers a "long-enough" maneuver distance to trigger a zoom-out when the user enters a motorway.
     */
    // TODO: On CarPlay `longManeuverDistance` should be set to 500.
    public var longManeuverDistance: CLLocationDistance = 1000.0
    
    /**
     Returns the pitch that the `NavigationCamera` initally defaults to.
     */
    public var defaultPitch: Double = 45.0
        
    weak var mapView: MapView?
    
    public required init(_ mapView: MapView) {
        self.mapView = mapView
        
        subscribeForNotifications()
    }
    
    deinit {
        unsubscribeFromNotifications()
    }
    
    // MARK: - Notifications observer methods
    
    func subscribeForNotifications() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(progressDidChange(_:)),
                                               name: .routeControllerProgressDidChange,
                                               object: nil)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(didReroute(_:)),
                                               name: .routeControllerDidReroute,
                                               object: nil)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(progressDidChange(_:)),
                                               name: .passiveLocationDataSourceDidUpdate,
                                               object: nil)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(orientationDidChange),
                                               name: UIDevice.orientationDidChangeNotification,
                                               object: nil)
        
        // TODO: Subscribe for .routeControllerDidPassSpokenInstructionPoint to be able to control
        // change camera in case when building highlighting is required.
    }
    
    func unsubscribeFromNotifications() {
        NotificationCenter.default.removeObserver(self,
                                                  name: .routeControllerProgressDidChange,
                                                  object: nil)
        
        NotificationCenter.default.removeObserver(self,
                                                  name: .routeControllerDidReroute,
                                                  object: nil)
        
        NotificationCenter.default.removeObserver(self,
                                                  name: .passiveLocationDataSourceDidUpdate,
                                                  object: nil)
        
        NotificationCenter.default.removeObserver(self,
                                                  name: UIDevice.orientationDidChangeNotification,
                                                  object: nil)
    }
    
    @objc func progressDidChange(_ notification: NSNotification) {
        let activeLocation = notification.userInfo?[RouteController.NotificationUserInfoKey.locationKey] as? CLLocation
        let routeProgress = notification.userInfo?[RouteController.NotificationUserInfoKey.routeProgressKey] as? RouteProgress
        let passiveLocation = notification.userInfo?[PassiveLocationDataSource.NotificationUserInfoKey.locationKey] as? CLLocation
        let cameraOptions = self.cameraOptions(passiveLocation, activeLocation: activeLocation, routeProgress: routeProgress)
        delegate?.viewportDataSource(self, didUpdate: cameraOptions)
    }
    
    @objc func orientationDidChange() {
        if UIDevice.current.orientation.isPortrait {
            followingMobileCamera.padding = UIEdgeInsets(top: 300.0, left: 0.0, bottom: 0.0, right: 0.0)
        } else {
            followingMobileCamera.padding = UIEdgeInsets(top: 0.0, left: 0.0, bottom: 0.0, right: 0.0)
        }
        
        let cameraOptions = [
            NavigationViewportDataSource.followingMobileCameraKey: followingMobileCamera,
        ]
        delegate?.viewportDataSource(self, didUpdate: cameraOptions)
    }
    
    func cameraOptions(_ passiveLocation: CLLocation?, activeLocation: CLLocation?, routeProgress: RouteProgress?) -> [String: CameraOptions] {
        updateFollowingCamera(passiveLocation, activeLocation: activeLocation, routeProgress: routeProgress)
        updateOverviewCamera(passiveLocation, activeLocation: activeLocation, routeProgress: routeProgress)
        
        let cameraOptions = [
            NavigationViewportDataSource.followingMobileCameraKey: followingMobileCamera,
            NavigationViewportDataSource.overviewMobileCameraKey: overviewMobileCamera,
            NavigationViewportDataSource.followingHeadUnitCameraKey: followingHeadUnitCamera,
            NavigationViewportDataSource.overviewHeadUnitCameraKey: overviewHeadUnitCamera
        ]
        
        return cameraOptions
    }
    
    func updateFollowingCamera(_ passiveLocation: CLLocation?, activeLocation: CLLocation?, routeProgress: RouteProgress?) {
        let location = passiveLocation ?? activeLocation
        var mobileBearing = location?.course
        var mobilePitch = CGFloat(defaultPitch)
        var mobilePadding = UIEdgeInsets(top: 300.0, left: 0.0, bottom: 0.0, right: 0.0)
        if passiveLocation != nil {
            mobileBearing = 0.0
            mobilePitch = 0.0
            mobilePadding = UIEdgeInsets(top: 0.0, left: 0.0, bottom: 0.0, right: 0.0)
        }
        
        // TODO: Change top padding depending on top banner height.
        if UIDevice.current.orientation.isLandscape {
            mobilePadding = UIEdgeInsets(top: 0.0, left: 0.0, bottom: 0.0, right: 0.0)
        }
        
        followingMobileCamera.center = location?.coordinate
        followingMobileCamera.bearing = mobileBearing
        followingMobileCamera.pitch = mobilePitch
        followingMobileCamera.padding = mobilePadding
        
        if let latitude = location?.coordinate.latitude, let size = mapView?.bounds.size {
            followingMobileCamera.zoom = CGFloat(ZoomLevelForAltitude(defaultAltitude,
                                                                      CGFloat(defaultPitch),
                                                                      latitude,
                                                                      size))
        }
        
        var headUnitPadding = UIEdgeInsets(top: 0.0, left: 100.0, bottom: 0.0, right: 0.0)
        var headUnitBearing = location?.course
        var headUnitPitch = CGFloat(0.0)
        if passiveLocation != nil {
            headUnitBearing = 0.0
            headUnitPitch = 0.0
            headUnitPadding = UIEdgeInsets(top: 0.0, left: 0.0, bottom: 0.0, right: 0.0)
        }
        
        followingHeadUnitCamera.center = location?.coordinate
        followingHeadUnitCamera.bearing = headUnitBearing
        followingHeadUnitCamera.padding = headUnitPadding
        
        if let latitude = location?.coordinate.latitude, let size = mapView?.bounds.size {
            followingHeadUnitCamera.zoom = CGFloat(ZoomLevelForAltitude(500.0,
                                                                        CGFloat(defaultPitch),
                                                                        latitude,
                                                                        size))
        }
        
        followingHeadUnitCamera.pitch = headUnitPitch
    }
    
    func updateOverviewCamera(_ passiveLocation: CLLocation?, activeLocation: CLLocation?, routeProgress: RouteProgress?) {
        let location = passiveLocation ?? activeLocation
        if let lineString = routeProgress?.route.shape,
           let cameraOptions = mapView?.cameraManager.camera(fitting: .lineString(lineString)) {
            overviewMobileCamera = cameraOptions
            overviewHeadUnitCamera = cameraOptions
        }
        
        overviewHeadUnitCamera.center = location?.coordinate
        overviewHeadUnitCamera.bearing = 0.0
        overviewHeadUnitCamera.padding = UIEdgeInsets(top: 0.0, left: 0.0, bottom: 0.0, right: 0.0)
        overviewHeadUnitCamera.zoom = 10.0
        overviewHeadUnitCamera.pitch = 0.0
    }
    
    @objc func didReroute(_ notification: NSNotification) {
        // TODO: Change `CameraOptions` when re-reouting occurs.
    }
    
    // @objc func updateCourseView(_ sender: UIGestureRecognizer) {
    //     if sender.state == .ended, let validAltitude = mapView?.altitude {
    //         // altitude = validAltitude
    //         enableFrameByFrameCourseViewTracking(for: 2)
    //     }
    //     
    //     // Capture altitude for double tap and two finger tap after animation finishes
    //     if sender is UITapGestureRecognizer, sender.state == .ended {
    //         DispatchQueue.main.asyncAfter(deadline: .now() + 0.3, execute: {
    //             // if let altitude = self.mapView.altitude {
    //             //     self.altitude = altitude
    //             // }
    //         })
    //     }
    // }
    // 
    // public func enableFrameByFrameCourseViewTracking(for duration: TimeInterval) {
    //     NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(disableFrameByFramePositioning), object: nil)
    //     perform(#selector(disableFrameByFramePositioning), with: nil, afterDelay: duration)
    //     mapView?.preferredFPS = .maximum
    // }
    // 
    // @objc fileprivate func disableFrameByFramePositioning() {
    //     mapView?.preferredFPS = .normal
    // }
}
