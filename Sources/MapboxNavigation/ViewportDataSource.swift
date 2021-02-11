import MapboxMaps

protocol ViewportDataSource {
    
    func getViewportData() -> ViewportData
    
    func registerUpdateObserver(_ viewportDataSourceUpdateObserver: ViewportDataSourceUpdateObserver)

    func unregisterUpdateObserver(_ viewportDataSourceUpdateObserver: ViewportDataSourceUpdateObserver)
}
