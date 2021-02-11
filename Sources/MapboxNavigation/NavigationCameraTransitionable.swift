import MapboxMaps

protocol NavigationCameraTransitionable {

    func transitionFromLowZoomToHighZoom(_ cameraOptions: CameraOptions)

    func transitionFromHighZoomToLowZoom(_ cameraOptions: CameraOptions)
    
    func transitionLinear(_ cameraOptions: CameraOptions)
}
