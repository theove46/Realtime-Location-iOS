import CoreLocation
import Combine
import MapKit

class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    private let locationManager = CLLocationManager()
    @Published var location: CLLocation?
    @Published var distance: Double = 0.0
    @Published var startingLocation: CLLocation?
    @Published var endingLocation: CLLocation?
    @Published var path: [CLLocation] = []
    @Published var speed: Double = 0.0 // Speed in km/h
    private var previousLocation: CLLocation?
    private var isTracking: Bool = false

    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }

    func startTracking() {
        isTracking = true
        distance = 0.0
        startingLocation = location
        endingLocation = nil
        previousLocation = location
        path = [location].compactMap { $0 }
    }

    func stopTracking() {
        isTracking = false
        endingLocation = location
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let newLocation = locations.last else { return }

        if isTracking, let previousLocation = previousLocation {
            let delta = newLocation.distance(from: previousLocation)
            distance += delta
            path.append(newLocation)
            
            // Calculate speed
            let timeInterval = newLocation.timestamp.timeIntervalSince(previousLocation.timestamp)
            if timeInterval > 0 {
                let speedInMetersPerSecond = delta / timeInterval
                speed = speedInMetersPerSecond * 3.6
            }
        }
        self.previousLocation = newLocation
        self.location = newLocation
    }
}
