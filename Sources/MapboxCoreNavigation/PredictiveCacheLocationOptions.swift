
import Foundation
import MapboxNavigationNative

/// `PredictiveCacheLocationOptions` controls various configurations for a `Predictive Caching` mechanic.
public class PredictiveCacheLocationOptions {
    
    /// How far around the user's location we're going to cache, _in meters_.
    ///
    /// Defaults to 2 km
    public var currentLocationRadiusInMeters: UInt32
    /// How far around the active route we're going to cache, _in meters_ (if route is set).
    ///
    /// Defaults to 500 m
    public var routeBufferRadiusInMeters: UInt32
    /// How far around the destination location we're going to cache, _in meters_ (if route is set).
    ///
    /// Defaults to 5 km
    public var destinationLocationRadiusInMeters: UInt32
    /// How many download threads will be used for caching
    ///
    /// Defaults to 2
    public var concurrency: UInt32
    
    /// Default initializer
    public init(currentLocationRadius: UInt32 = 2_000, routeBufferRadius: UInt32 = 500, destinationLocationRadius: UInt32 = 5_000, concurrency: UInt32 = 2) {
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
