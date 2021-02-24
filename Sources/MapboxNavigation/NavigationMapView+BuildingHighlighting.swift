import CoreLocation
import MapboxMaps
import Turf

extension NavigationMapView {
    
    // MARK: - Building Extrusion Highlighting methods
    
    /**
     Receives coordinates for searching the map for buildings. If buildings are found, they will be highlighted in 2D or 3D depending on the `in3D` value.
     
     - parameter coordinates: Coordinates which represent building locations.
     - parameter extrudesBuildings: Switch which allows to highlight buildings in either 2D or 3D. Defaults to true.
     
     - returns: Bool indicating if number of buildings found equals number of coordinates supplied.
     */
    @discardableResult public func highlightBuildings(at coordinates: [CLLocationCoordinate2D], in3D extrudesBuildings: Bool = true) -> Bool {
        let _ = coordinates.map({buildingIdentifier(at: $0, in3D: extrudesBuildings) })
        DispatchQueue.main.asyncAfter(deadline: .now() + handleAsyncTime, execute: {self.addBuildingsLayer(with: self.foundBuildingIds, in3D: extrudesBuildings)})
        return foundBuildingIds.count == coordinates.count
    }
    
    /**
     Removes the highlight from all buildings highlighted by `highlightBuildings(at:in3D:)`.
     */
    public func unhighlightBuildings() {
        guard let _ = try? mapView.style.getLayer(with: IdentifierString.buildingExtrusionLayer, type: FillExtrusionLayer.self).get() else { return }
        foundBuildingIds = Set<Double>()
        let _ = mapView.style.removeStyleLayer(forLayerId: IdentifierString.buildingExtrusionLayer)
    }

    private func featureIdentifierToDouble(features: [Feature]) -> Double? {
        if let featureIdentifier = features.first?.identifier {
            switch featureIdentifier {
            case .string(let stringId): return Double(stringId)
            case .number(let numberId):
                switch numberId {
                case .double(let doubleId): return Double(doubleId)
                case .int(let intId): return Double(intId)
                }
            }
        }
        return nil
    }

    private func buildingIdentifier(at coordinate: CLLocationCoordinate2D, in3D extrudesBuildings: Bool = true) {
        let screenCoordinate = mapView.point(for: coordinate, in: self)
        if let identifiers = try? mapView.__map.getStyleLayers().compactMap({$0.id}).filter({ $0.contains("building") }) {
            mapView.visibleFeatures(at: screenCoordinate,
                                    styleLayers: Set(identifiers),
                                    completion: { [weak self] result in
                                        guard let validSelf = self else { return }
                                        if case .success(let features) = result {
                                            if let identifier = self?.featureIdentifierToDouble(features: features) {
                                                self?.foundBuildingIds.insert(identifier)
                                            }
                                        }
                                    })
        }
    }

    private func addBuildingsLayer(with identifiers: Set<Double>, in3D: Bool = false, extrudeAll: Bool = false) {
        mapView.style.removeStyleLayer(forLayerId: IdentifierString.buildingExtrusionLayer)
        if identifiers.isEmpty { return }
        var highlightedBuildingsLayer = FillExtrusionLayer(id: IdentifierString.buildingExtrusionLayer)
        highlightedBuildingsLayer.source = "composite"
        highlightedBuildingsLayer.sourceLayer = "building"

        if extrudeAll {
            highlightedBuildingsLayer.filter = Exp(.eq) {
                Exp(.get) {
                    "extrude"
                }
                "true"
            }
        } else {
            highlightedBuildingsLayer.filter = Exp(.all) {
                Exp(.eq) {
                    Exp(.get) {
                        "extrude"
                    }
                    "true"
                }
                Exp(.inExpression) {
                    Exp(.id)
                    Exp(.literal) {
                        identifiers.map({$0})
                    }
                }
            }
        }

        if in3D {
            highlightedBuildingsLayer.paint?.fillExtrusionHeight = .expression(
                Exp(.interpolate) {
                    Exp(.linear)
                    Exp(.zoom)
                    13
                    0
                    13.25
                    Exp(.get) {
                        "height"
                    }
                }
            )
        } else {
            highlightedBuildingsLayer.paint?.fillExtrusionHeight = .constant(0.0)
        }

        highlightedBuildingsLayer.paint?.fillExtrusionBase = .expression(
            Exp(.interpolate) {
                Exp(.linear)
                Exp(.zoom)
                13
                0
                13.25
                Exp(.get) { "min_height"}
            }
        )

        highlightedBuildingsLayer.paint?.fillExtrusionOpacity = .expression(
            Exp(.interpolate) {
                Exp(.linear)
                Exp(.zoom)
                13; 0.5
                17; 0.8
            }
        )

        highlightedBuildingsLayer.paint?.fillExtrusionColor = .constant(.init(color: buildingHighlightColor))
        highlightedBuildingsLayer.paint?.fillExtrusionHeightTransition = StyleTransition(duration: 0.8, delay: 0)
        highlightedBuildingsLayer.paint?.fillExtrusionOpacityTransition = StyleTransition(duration: 0.8, delay: 0)
        mapView.style.addLayer(layer: highlightedBuildingsLayer)
    }

}
