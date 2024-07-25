//
//  Realtime_LocationApp.swift
//  Realtime Location
//
//  Created by BS1098 on 24/7/24.
//

import SwiftUI
import CoreLocation

//class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
//    private var locationManager = CLLocationManager()
//    
//    @Published var userLocation: CLLocation? = nil
//    
//    override init() {
//        super.init()
//        self.locationManager.delegate = self
//        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
//        self.locationManager.requestWhenInUseAuthorization()
//        self.locationManager.startUpdatingLocation()
//    }
//    
//    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//        guard let location = locations.last else { return }
//        self.userLocation = location
//    }
//}

//func calculateDistance(from: CLLocation, to: CLLocation) -> CLLocationDistance {
//    return from.distance(from: to)
//}

//struct ContentView: View {
//    @StateObject private var locationManager = LocationManager()
//    @State private var destinationLocation: CLLocation? = nil
//    
//    var body: some View {
//        VStack {
//            if let userLocation = locationManager.userLocation {
//                Text("Your Location: \(userLocation.coordinate.latitude), \(userLocation.coordinate.longitude)")
//                
//                Button("Set Destination") {
//                    // Set a sample destination location
//                    self.destinationLocation = CLLocation(latitude: 37.7749, longitude: -122.4194) // San Francisco, CA
//                }
//                
//                if let destination = destinationLocation {
//                    let distance = calculateDistance(from: userLocation, to: destination)
//                    Text("Distance to Destination: \(distance) meters")
//                }
//            } else {
//                Text("Getting user location...")
//            }
//        }
//        .padding()
//    }
//}

//@main
//struct DistanceCalculationApp: App {
//    var body: some Scene {
//        WindowGroup {
//            ContentView()
//        }
//    }
//}
