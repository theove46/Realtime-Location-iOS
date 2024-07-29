import Foundation
import CoreLocation

struct ReportManager: Identifiable, Codable {
    var id = UUID()
    let startLocation: CLLocation
    let endLocation: CLLocation
    let totalDistance: Double
    let duration: TimeInterval
    let averageSpeed: Double
    let date: Date
    
    enum CodingKeys: String, CodingKey {
        case id, startLocation, endLocation, totalDistance, duration, averageSpeed, date
    }
    
    enum LocationKeys: String, CodingKey {
        case latitude, longitude
    }
    
    init(startLocation: CLLocation, endLocation: CLLocation, totalDistance: Double, duration: TimeInterval, averageSpeed: Double, date: Date) {
        self.startLocation = startLocation
        self.endLocation = endLocation
        self.totalDistance = totalDistance
        self.duration = duration
        self.averageSpeed = averageSpeed
        self.date = date
    }
    
    // Custom encoding and decoding for CLLocation
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(UUID.self, forKey: .id)
        totalDistance = try container.decode(Double.self, forKey: .totalDistance)
        duration = try container.decode(TimeInterval.self, forKey: .duration)
        averageSpeed = try container.decode(Double.self, forKey: .averageSpeed)
        date = try container.decode(Date.self, forKey: .date)
        
        let startLocationContainer = try container.nestedContainer(keyedBy: LocationKeys.self, forKey: .startLocation)
        let startLatitude = try startLocationContainer.decode(CLLocationDegrees.self, forKey: .latitude)
        let startLongitude = try startLocationContainer.decode(CLLocationDegrees.self, forKey: .longitude)
        startLocation = CLLocation(latitude: startLatitude, longitude: startLongitude)
        
        let endLocationContainer = try container.nestedContainer(keyedBy: LocationKeys.self, forKey: .endLocation)
        let endLatitude = try endLocationContainer.decode(CLLocationDegrees.self, forKey: .latitude)
        let endLongitude = try endLocationContainer.decode(CLLocationDegrees.self, forKey: .longitude)
        endLocation = CLLocation(latitude: endLatitude, longitude: endLongitude)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(totalDistance, forKey: .totalDistance)
        try container.encode(duration, forKey: .duration)
        try container.encode(averageSpeed, forKey: .averageSpeed)
        try container.encode(date, forKey: .date)
        
        var startLocationContainer = container.nestedContainer(keyedBy: LocationKeys.self, forKey: .startLocation)
        try startLocationContainer.encode(startLocation.coordinate.latitude, forKey: .latitude)
        try startLocationContainer.encode(startLocation.coordinate.longitude, forKey: .longitude)
        
        var endLocationContainer = container.nestedContainer(keyedBy: LocationKeys.self, forKey: .endLocation)
        try endLocationContainer.encode(endLocation.coordinate.latitude, forKey: .latitude)
        try endLocationContainer.encode(endLocation.coordinate.longitude, forKey: .longitude)
    }
}
