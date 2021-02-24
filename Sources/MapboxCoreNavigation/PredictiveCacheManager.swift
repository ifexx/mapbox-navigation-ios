
import Foundation
import MapboxNavigationNative

/// `PredictiveCacheManager` is responsible for creating and retaining `Predictive Caching` related components.
///
/// Tupical usage suggests initializing an instance of `PredictiveCacheManager` and retaining it as long as caching is required.
public class PredictiveCacheManager {
    public typealias MapOptions = (tileStore: TileStore, styleSourcePaths: [String])
    
    /// a `Navigator` object which uses caching
    ///
    /// PredictiveCacheManager retains a related `Navigator` instance to maintain it's relation to cache controllers
    var navigator: Navigator {
        navigatorWithHistory.navigator
    }
    private(set) var navigatorWithHistory: NavigatorWithHistory
    private(set) var controllers: [PredictiveCacheController] = []
    
    /// Default initializer
    ///
    /// - parameter predictiveCacheLocationOptions: `PredictiveCacheLocationOptions` which configure various caching parameters like radius area to cache.
    /// - parameter mapOptions: A `MapOptions` which contains info about `Map` tiles like it's location and tilesets to be cached. If set to `nil` - predictive caching won't be enbled for map tiles.
    public convenience init(predictiveCacheLocationOptions: PredictiveCacheLocationOptions, mapOptions: MapOptions?) {
        self.init(predictiveCacheLocationOptions: predictiveCacheLocationOptions,
                  navigatorWithHistory: NavigatorProvider.sharedWeakNavigator(),
                  mapOptions: mapOptions)
    }
    
    init(predictiveCacheLocationOptions: PredictiveCacheLocationOptions, navigatorWithHistory: NavigatorWithHistory, mapOptions: MapOptions?) {
        self.navigatorWithHistory = navigatorWithHistory
        
        initControllers(options: predictiveCacheLocationOptions,
                        mapOptions: mapOptions)
    }
    
    private func initControllers(options: PredictiveCacheLocationOptions,
                                 mapOptions: MapOptions?) {
        controllers.append(initNavigatorController(options: options))
        if let mapOptions = mapOptions {
            controllers.append(contentsOf: initMapControllers(options: options, mapOptions: mapOptions))
        }
    }
    
    private func initMapControllers(options: PredictiveCacheLocationOptions,
                                    mapOptions: MapOptions) -> [PredictiveCacheController] {
        return mapOptions.styleSourcePaths.compactMap {
            createPredictiveCacheController(options: options,
                                            tileStore: mapOptions.tileStore,
                                            dataset: $0)
        }
    }
    
    private func initNavigatorController(options: PredictiveCacheLocationOptions) -> PredictiveCacheController {
        return createPredictiveCacheController(options: options)!
    }
    
    private func createPredictiveCacheController(options: PredictiveCacheLocationOptions,
                                                 tileStore: TileStore? = nil,
                                                 version: String = "",
                                                 dataset: String = "mapbox",
                                                 concurrency: UInt32 = 2) -> PredictiveCacheController? {
        let cacheOptions = PredictiveCacheControllerOptions(version: version,
                                                            dataset: dataset,
                                                            concurrency: concurrency)
        if let tileStore = tileStore {
            return try! navigator.createPredictiveCacheController(for: tileStore,
                                                                  cacheOptions: cacheOptions,
                                                                  locationTrackerOptions: options.toPredictiveLocationTrackerOptions())
        } else {
            return try! navigator.createPredictiveCacheController(for: options.toPredictiveLocationTrackerOptions())
        }
    }
}
