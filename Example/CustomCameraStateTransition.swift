import MapboxMaps
import MapboxNavigation

class CustomCameraStateTransition: CameraStateTransition {
    weak var mapView: MapView?
    
    required init(_ mapView: MapView) {
        self.mapView = mapView
    }
    
    func transitionToFollowing(_ cameraOptions: CameraOptions, completion: ((Bool) -> Void)?) {
        mapView?.cameraManager.setCamera(to: cameraOptions)
    }
    
    func transitionToOverview(_ cameraOptions: CameraOptions, completion: ((Bool) -> Void)?) {
        mapView?.cameraManager.setCamera(to: cameraOptions)
    }
    
    func updateForFollowing(_ cameraOptions: CameraOptions, completion: ((Bool) -> Void)?) {
        mapView?.cameraManager.setCamera(to: cameraOptions)
    }
    
    func updateForOverview(_ cameraOptions: CameraOptions, completion: ((Bool) -> Void)?) {
        mapView?.cameraManager.setCamera(to: cameraOptions)
    }
}
