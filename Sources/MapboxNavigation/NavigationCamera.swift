import MapboxMaps

public class NavigationCamera {
    
    public weak var delegate: NavigationCameraDelegate?
    
    fileprivate var navigationCameraState: NavigationCameraState = .idle {
        didSet {
            delegate?.navigationCameraStateDidChange(navigationCameraState)
        }
    }
    
    fileprivate weak var mapView: MapView?
    
    fileprivate var viewportDataSource: ViewportDataSource
    
    fileprivate var stateTransition: NavigationCameraStateTransition
    
    required init(_ mapView: MapView, viewportDataSource: ViewportDataSource = NavigationViewportDataSource()) {
        self.mapView = mapView
        self.viewportDataSource = viewportDataSource
        self.stateTransition = NavigationCameraStateTransition(mapView)
        
        registerObservers()
        // makeGestureRecognizersRespectCourseTracking()
        // makeGestureRecognizersUpdateCourseView()
    }
    
    func registerObservers() {
        viewportDataSource.registerUpdateObserver(self)
    }
    
    public func requestNavigationCameraToFollowing() {
        switch navigationCameraState {
        case .transitionToFollowing, .following:
            return
            
        case .idle, .transitionToOverview, .overview:
            navigationCameraState = .transitionToFollowing
            
            stateTransition.transitionToFollowing(viewportDataSource.getViewportData().cameraForFollowing)
            
            navigationCameraState = .following
            
            break
        }
    }
    
    public func requestNavigationCameraToOverview() {
        switch navigationCameraState {
        case .transitionToOverview, .overview:
            return
            
        case .idle, .transitionToFollowing, .following:
            navigationCameraState = .transitionToFollowing
            
            stateTransition.transitionToOverview(viewportDataSource.getViewportData().cameraForOverview)
            
            navigationCameraState = .following
            
            break
        }
    }
    
    public func requestNavigationCameraToIdle() {
        if navigationCameraState == .idle { return }
        
        // TODO: Switch to idle state after touching map view.
        
        navigationCameraState = .idle
    }
    
    /**
     Modifies the gesture recognizers to also disable course tracking.
     */
    func makeGestureRecognizersRespectCourseTracking() {
        for gestureRecognizer in mapView?.gestureRecognizers ?? []
        where gestureRecognizer is UIPanGestureRecognizer || gestureRecognizer is UIRotationGestureRecognizer {
            // gestureRecognizer.addTarget(self, action: #selector(disableUserCourseTracking))
            
            requestNavigationCameraToIdle()
            break
        }
    }
    
    /**
     
     */
    func makeGestureRecognizersUpdateCourseView() {
        // for gestureRecognizer in mapView?.gestureRecognizers ?? [] {
        //     gestureRecognizer.addTarget(self, action: #selector(updateCourseView(_:)))
        // }
    }
}

extension NavigationCamera: ViewportDataSourceUpdateObserver {
    
    func viewportDataSourceUpdated(_ viewportData: ViewportData) {
        NSLog("!!! \(navigationCameraState)")
        
        switch navigationCameraState {
        case .following:
            stateTransition.updateForFollowing(viewportData.cameraForFollowing)
            break
            
        case .overview:
            stateTransition.updateForFollowing(viewportData.cameraForFollowing)
            break
            
        case .idle, .transitionToFollowing, .transitionToOverview:
            break
        }
    }
}
