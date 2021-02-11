import MapboxMaps

protocol NavigationCameraStateTransitionable {
    
    func transitionToFollowing(_ cameraOptions: CameraOptions)
    
    func transitionToOverview(_ cameraOptions: CameraOptions)
    
    func updateForFollowing(_ cameraOptions: CameraOptions)
    
    func updateForOverview(_ cameraOptions: CameraOptions)
}
