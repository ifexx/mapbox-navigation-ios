import MapboxMaps

public class NavigationCameraStateTransition: CameraStateTransition {

    weak public var mapView: MapView?
    
    required public init(_ mapView: MapView) {
        self.mapView = mapView
    }
    
    public func transitionToFollowing(_ cameraOptions: CameraOptions, completion: ((Bool) -> Void)? = nil) {
        // TODO: Replace with specific set of animations.
        mapView?.cameraManager.setCamera(to: cameraOptions,
                                         animated: true,
                                         duration: 1.0,
                                         completion: completion)
    }

    public func transitionToOverview(_ cameraOptions: CameraOptions, completion: ((Bool) -> Void)? = nil) {
        // TODO: Replace with specific set of animations.
        mapView?.cameraManager.setCamera(to: cameraOptions,
                                         animated: true,
                                         duration: 1.0,
                                         completion: completion)
    }

    public func updateForFollowing(_ cameraOptions: CameraOptions, completion: ((Bool) -> Void)? = nil) {
        // TODO: Replace with specific set of animations.
        mapView?.cameraManager.setCamera(to: cameraOptions,
                                         animated: true,
                                         duration: 1.0,
                                         completion: completion)
    }

    public func updateForOverview(_ cameraOptions: CameraOptions, completion: ((Bool) -> Void)? = nil) {
        // TODO: Replace with specific set of animations.
        mapView?.cameraManager.setCamera(to: cameraOptions,
                                         animated: true,
                                         duration: 1.0,
                                         completion: completion)
    }
}
