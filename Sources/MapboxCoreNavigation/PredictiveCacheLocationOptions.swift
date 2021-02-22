
import Foundation
import MapboxNavigationNative

/// `PredictiveCacheLocationOptions` controls various configurations for a `Predictive Caching` mechanic.
public class PredictiveCacheLocationOptions {
    
    /// How far around the user's location we're going to cache, in meters.
    ///
    /// Defaults to 20
    public var currentLocationRadiusInMeters: UInt32
    /// How far around the active route we're going to cache, in meters (if route is set).
    ///
    /// Defaults to 5
    public var routeBufferRadiusInMeters: UInt32
    /// How far around the destination location we're going to cache, in meters (if route is set).
    ///
    /// Defaults to 50
    public var destinationLocationRadiusInMeters: UInt32
    /// How many download threads will be used for caching
    ///
    /// Defaults to 2
    public var concurrency: UInt32
    
    /// Default initializer
    public init(currentLocationRadius: UInt32 = 20, routeBufferRadius: UInt32 = 5, destinationLocationRadius: UInt32 = 50, concurrency: UInt32 = 2) {
        currentLocationRadiusInMeters = currentLocationRadius
        routeBufferRadiusInMeters = routeBufferRadius
        destinationLocationRadiusInMeters = destinationLocationRadius
        self.concurrency = concurrency
    }
    
    func toPredictiveLocationTrackerOptions() -> PredictiveLocationTrackerOptions {
        return PredictiveLocationTrackerOptions(currentLocationRadius: currentLocationRadiusInMeters,
                                                routeBufferRadius: routeBufferRadiusInMeters,
                                                destinationLocationRadius: destinationLocationRadiusInMeters)
    }
}
