/**
 Possible states which `NavigationCamera` can have.
 */
public enum NavigationCameraState: Int {
    
    /**
     * State when `NavigationCamera` does not execute any transitions.
     * Such state is set after invoking `NavigationCamera.requestNavigationCameraToIdle()`.
     */
    case idle
    
    /**
     
     */
    case transitionToFollowing
    
    /**
     
     */
    case following
    
    /**
     
     */
    case transitionToOverview
    
    /**
     
     */
    case overview
}
