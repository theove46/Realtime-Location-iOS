//
//  Location_Manger.swift
//  Realtime Location
//
//  Created by BS1098 on 24/7/24.
//

import CoreLocation
import Combine

class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    private let locationManager = CLLocationManager()
    @Published var location: CLLocation?
    @Published var distance: Double = 0.0
    @Published var startingLocation: CLLocation?
    @Published var endingLocation: CLLocation?
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
        }
        self.previousLocation = newLocation
        self.location = newLocation
    }
}
