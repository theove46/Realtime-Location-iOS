import Foundation
import CoreLocation

struct ReportManager: Identifiable {
    let id = UUID()
    let startLocation: CLLocation
    let endLocation: CLLocation
    let totalDistance: Double
    let duration: TimeInterval
    let averageSpeed: Double
    let date: Date
}
