import MapboxMaps

class NavigationCameraStateTransition: NavigationCameraStateTransitionable {

    fileprivate weak var mapView: MapView?
    
    fileprivate var navigationCameraTransition: NavigationCameraTransition!
    
    required init(_ mapView: MapView) {
        self.mapView = mapView
        self.navigationCameraTransition = NavigationCameraTransition(mapView)
    }
    
    func transitionToFollowing(_ cameraOptions: CameraOptions) {
        return navigationCameraTransition.transitionFromLowZoomToHighZoom(cameraOptions)
    }
    
    func transitionToOverview(_ cameraOptions: CameraOptions) {
        let currentZoom = mapView?.zoom ?? 0.0
        
        if currentZoom <= cameraOptions.zoom ?? currentZoom {
            navigationCameraTransition.transitionFromLowZoomToHighZoom(cameraOptions)
        } else {
            navigationCameraTransition.transitionFromHighZoomToLowZoom(cameraOptions)
        }
    }
    
    func updateForFollowing(_ cameraOptions: CameraOptions) {
        navigationCameraTransition.transitionLinear(cameraOptions)
    }
    
    func updateForOverview(_ cameraOptions: CameraOptions) {
        navigationCameraTransition.transitionLinear(cameraOptions)
    }
}
