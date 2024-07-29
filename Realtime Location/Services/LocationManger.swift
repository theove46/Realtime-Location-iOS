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
    @Published var speed: Double = 0.0
    private var previousLocation: CLLocation?
    var isTracking: Bool = false
    var isPaused: Bool = false

    private var startTime: Date?
    private var endTime: Date?
    @Published var reports: [ReportManager] = []

    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }

    func startTracking() {
        isTracking = true
        isPaused = false
        distance = 0.0
        startingLocation = location
        endingLocation = nil
        previousLocation = location
        path = [location].compactMap { $0 }
        startTime = Date()
        endTime = nil
    }

    func stopTracking() {
        isTracking = false
        isPaused = false
        endingLocation = location
        endTime = Date()

        if let startLocation = startingLocation, let endLocation = endingLocation, let startTime = startTime, let endTime = endTime {
            let report = ReportManager(
                startLocation: startLocation,
                endLocation: endLocation,
                totalDistance: distance,
                duration: endTime.timeIntervalSince(startTime),
                averageSpeed: (distance / endTime.timeIntervalSince(startTime)) * 3.6, // Convert m/s to km/h
                date: endTime
            )
            reports.append(report)
        }
    }

    func pauseTracking() {
        isPaused = true
    }

    func resumeTracking() {
        isPaused = false
        previousLocation = location
    }

    func resetTracking() {
        isTracking = false
        isPaused = false
        distance = 0.0
        startingLocation = nil
        endingLocation = nil
        path = []
        speed = 0.0
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let newLocation = locations.last else { return }

        if isTracking && !isPaused, let previousLocation = previousLocation {
            let locationData = newLocation.distance(from: previousLocation)
            distance += locationData
            path.append(newLocation)
            
            // Calculate speed
            let timeInterval = newLocation.timestamp.timeIntervalSince(previousLocation.timestamp)
            if timeInterval > 0 {
                let speedInMetersPerSecond = locationData / timeInterval
                speed = speedInMetersPerSecond * 3.6
            }
        }
        self.previousLocation = newLocation
        self.location = newLocation
    }
}
