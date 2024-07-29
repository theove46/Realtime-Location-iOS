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
    @Published var reports: [ReportManager] = [] {
        didSet {
            saveReports()
        }
    }
    private var previousLocation: CLLocation?
    var isTracking: Bool = false
    var isPaused: Bool = false

    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        loadReports()
    }

    func startTracking() {
        isTracking = true
        isPaused = false
        distance = 0.0
        startingLocation = location
        endingLocation = nil
        previousLocation = location
        path = [location].compactMap { $0 }
    }

    func stopTracking() {
        isTracking = false
        isPaused = false
        endingLocation = location
        saveReport()
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

    private func saveReport() {
        guard let start = startingLocation, let end = endingLocation else { return }
        let report = ReportManager(
            startLocation: start,
            endLocation: end,
            totalDistance: distance,
            duration: end.timestamp.timeIntervalSince(start.timestamp),
            averageSpeed: distance / end.timestamp.timeIntervalSince(start.timestamp) * 3.6,
            date: Date()
        )
        reports.append(report)
    }

    private func saveReports() {
        let encoder = JSONEncoder()
        if let encodedReports = try? encoder.encode(reports) {
            UserDefaults.standard.set(encodedReports, forKey: "reports")
        }
    }

    private func loadReports() {
        if let savedReports = UserDefaults.standard.data(forKey: "reports") {
            let decoder = JSONDecoder()
            if let decodedReports = try? decoder.decode([ReportManager].self, from: savedReports) {
                reports = decodedReports
            }
        }
    }
}
