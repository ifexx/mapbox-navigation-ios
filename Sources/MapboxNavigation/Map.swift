
import Foundation
import MapboxCoreMaps

extension Map {
    func getStyleSourceURLs(_ sourceTypes: [String]) -> [String] {
        let filteredSources = try! getStyleSources().filter {
            return sourceTypes.contains($0.type)
        }
        
        var urls = [String]()
        for source in filteredSources {
            let properties = try! getStyleSourceProperties(forSourceId: source.id)
            
            if properties.isValue() {
                let contents = properties.value as? [String: AnyObject]
                guard var url = contents?["url"] as? String else {
                    continue
                }
                if url.split(separator: ",").count > 1 || !url.hasPrefix("mapbox://") {
                    continue // we ignore composite (https://docs.mapbox.com/studio-manual/reference/styles/#source-compositing.) and non-mapbox sources
                } else {
                    url.removeFirst("mapbox://".count)
                    urls.append(url)
                }
            }
        }
        return urls
    }
}
