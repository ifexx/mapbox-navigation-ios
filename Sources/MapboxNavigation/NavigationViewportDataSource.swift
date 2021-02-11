import MapboxMaps
import MapboxCoreNavigation

class NavigationViewportDataSource: ViewportDataSource {
    
    fileprivate var targetLocation: CLLocation?
    
    fileprivate var viewportDataSourceUpdateObservers: [ViewportDataSourceUpdateObserver] = []
    
    var cameraForFollowing: CameraOptions
    
    var cameraForOverview: CameraOptions
    
    var viewportData: ViewportData
    
    func getViewportData() -> ViewportData {
        return viewportData
    }
    
    func registerUpdateObserver(_ viewportDataSourceUpdateObserver: ViewportDataSourceUpdateObserver) {
        viewportDataSourceUpdateObservers.append(viewportDataSourceUpdateObserver)
    }
    
    func unregisterUpdateObserver(_ viewportDataSourceUpdateObserver: ViewportDataSourceUpdateObserver) {
        
    }
    
    init() {
        cameraForFollowing = CameraOptions(center: CLLocationCoordinate2D(latitude: 47.605215, longitude: -122.33029),
                                           padding: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0),
                                           anchor: nil,
                                           zoom: 15.0,
                                           bearing: nil,
                                           pitch: 45)
        
        cameraForOverview = CameraOptions(center: CLLocationCoordinate2D(latitude: 47.605215, longitude: -122.33029),
                                          padding: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0),
                                          anchor: nil,
                                          zoom: 15.0,
                                          bearing: nil,
                                          pitch: 45)
        
        viewportData = ViewportData(cameraForFollowing: cameraForFollowing, cameraForOverview: cameraForOverview)
        
        NotificationCenter.default.addObserver(self, selector: #selector(progressDidChange(_ :)), name: .routeControllerProgressDidChange, object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: .routeControllerProgressDidChange, object: nil)
    }
    
    @objc func progressDidChange(_ notification: NSNotification) {
        targetLocation = notification.userInfo?[RouteController.NotificationUserInfoKey.locationKey] as? CLLocation
        let routeProgress = notification.userInfo?[RouteController.NotificationUserInfoKey.routeProgressKey] as? RouteProgress
        // let rawLocation = notification.userInfo?[RouteController.NotificationUserInfoKey.rawLocationKey]
        
        guard let currentLegProgress = routeProgress?.currentLegProgress else {
            return
        }
        
        viewportDataSourceUpdateObservers.forEach {
            $0.viewportDataSourceUpdated(getViewportData())
        }
        
        cameraForFollowing.center = targetLocation?.coordinate
        cameraForFollowing.bearing = targetLocation?.course
        
        // currentLegProgress.currentStepProgress.step.shape?.coordinates
        
        NSLog("!!! \(targetLocation)")
        NSLog("!!! \(routeProgress)")
    }
}
