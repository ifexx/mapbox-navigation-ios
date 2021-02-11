import MapboxMaps

class NavigationCameraTransition: NavigationCameraTransitionable {

    fileprivate weak var mapView: MapView?
    
    // fileprivate var animatorZoom: UIViewPropertyAnimator!
    
    required init(_ mapView: MapView) {
        self.mapView = mapView
    }
    
    func transitionFromLowZoomToHighZoom(_ cameraOptions: CameraOptions) {
        NSLog("!!! \(mapView)")
        NSLog("!!! \(cameraOptions.center)")
        NSLog("!!! \(cameraOptions.zoom)")
        
        mapView?.cameraManager.setCamera(to: cameraOptions, animated: true, duration: 1.0, completion: nil)
        
        // guard let currentCenter = mapView?.centerCoordinate,
        //       let location = cameraOptions.center?.location.coordinate else { return }
        // 
        // let point1 = CLLocation(latitude: currentCenter.latitude, longitude: currentCenter.longitude)
        // let point2 = CLLocation(latitude: location.latitude, longitude: location.longitude)
        // let centerTranslationDistance = point1.distance(from: point2)
        // let metersPerSecondMaxCenterAnimation: Double = 1500.0
        // let durationCenterAnimation: TimeInterval = max(min(centerTranslationDistance / metersPerSecondMaxCenterAnimation, 1.6), 0.6)
        // let delayCenterAnimation: TimeInterval = 0
        // 
        // let currentZoomLevel = Double(mapView?.zoom ?? 0.0)
        // let zoomLevel = Double(cameraOptions.zoom ?? 0.0)
        // 
        // let zoomLevelDistance: Double = fabs(zoomLevel - currentZoomLevel)
        // let levelsPerSecondMaxZoomAnimation: Double = 3.0
        // let durationZoomAnimation: TimeInterval = max(min(zoomLevelDistance / levelsPerSecondMaxZoomAnimation, 1.6), 0.6)
        // let delayZoomAnimation: TimeInterval = durationCenterAnimation * 0.5
        // let endZoomAnimation: TimeInterval = durationZoomAnimation + delayZoomAnimation
        // 
        // let bezierParamsZoom = UICubicTimingParameters(controlPoint1: CGPoint(x: 0.6, y: 0.0), controlPoint2: CGPoint(x: 0.4, y: 1.0))
        // animatorZoom = UIViewPropertyAnimator(duration: durationZoomAnimation, timingParameters: bezierParamsZoom)
        // animatorZoom.addAnimations {
        //     guard let zoom = cameraOptions.zoom else { return }
        //     
        //     mapView?.zoom = zoom
        // }
        // 
        // animatorZoom.addCompletion { _ in
        //     NSLog("!!! Finished executing zoom animation.")
        // }
        // 
        // animatorZoom.startAnimation(afterDelay: fmax(delayZoomAnimation, 0))
    }
    
    func transitionFromHighZoomToLowZoom(_ cameraOptions: CameraOptions) {
        mapView?.cameraManager.setCamera(to: cameraOptions, animated: true, duration: 1.0, completion: nil)
    }
    
    func transitionLinear(_ cameraOptions: CameraOptions) {
        mapView?.cameraManager.setCamera(to: cameraOptions, animated: true, duration: 1.0, completion: nil)
    }
}
