import SwiftUI
import Combine

struct DistanceView: View {
    @ObservedObject var locationManager: LocationManager
    @State private var isTracking = false
    @State private var isPaused = false
    @State private var timerSubscription: AnyCancellable?
    @State private var elapsedTime: TimeInterval = 0
    
    var body: some View {
        VStack {
            ZStack {
                // Gradient Background
                LinearGradient(
                    gradient: Gradient(colors: [
                        Color.oxfordBlue,
                        Color.persianBlue,
                        Color.marianBlue,
                    ]),
                    startPoint: .top,
                    endPoint: .bottom
                )
                .edgesIgnoringSafeArea(.all)

                VStack(spacing: 50) {
                    // Current Location
                    VStack(alignment: .center, spacing: 10) {
                        Text("Current Location")
                            .font(.heading)
                            .foregroundColor(.primary)
                        if let location = locationManager.location {
                            Text("Lat: \(location.coordinate.latitude, specifier: "%.4f")")
                                .font(.normal)
                                .foregroundColor(.secondary)
                            Text("Lng: \(location.coordinate.longitude, specifier: "%.4f")")
                                .font(.normal)
                                .foregroundColor(.secondary)
                        } else {
                            Text("Lat: ----")
                                .font(.normal)
                                .foregroundColor(.secondary)
                            Text("Lng: ----")
                                .font(.normal)
                                .foregroundColor(.secondary)
                        }
                    }
                    .padding(.leading, 16)
                    .padding(.top, 16)

                    HStack(spacing: 50) {
                        // Starting Location
                        VStack(alignment: .center, spacing: 10) {
                            Text("Starting")
                                .font(.heading)
                                .foregroundColor(.primary)
                            if let startLocation = locationManager.startingLocation {
                                Text("Lat: \(startLocation.coordinate.latitude, specifier: "%.4f")")
                                    .font(.normal)
                                    .foregroundColor(.secondary)
                                Text("Lng: \(startLocation.coordinate.longitude, specifier: "%.4f")")
                                    .font(.normal)
                                    .foregroundColor(.secondary)
                            } else {
                                Text("Lat: ----")
                                    .font(.normal)
                                    .foregroundColor(.secondary)
                                Text("Lng: ----")
                                    .font(.normal)
                                    .foregroundColor(.secondary)
                            }
                        }
                        .padding(.leading, 32)

                        Spacer()

                        // Ending Location
                        VStack(alignment: .center, spacing: 10) {
                            Text("Ending")
                                .font(.heading)
                                .foregroundColor(.primary)
                            if let endLocation = locationManager.endingLocation {
                                Text("Lat: \(endLocation.coordinate.latitude, specifier: "%.4f")")
                                    .font(.normal)
                                    .foregroundColor(.secondary)
                                Text("Lng: \(endLocation.coordinate.longitude, specifier: "%.4f")")
                                    .font(.normal)
                                    .foregroundColor(.secondary)
                            } else {
                                Text("Lat: ----")
                                    .font(.normal)
                                    .foregroundColor(.secondary)
                                Text("Lng: ----")
                                    .font(.normal)
                                    .foregroundColor(.secondary)
                            }
                        }
                        .padding(.trailing, 32)
                    }

                    // Distance
                    VStack {
                        if locationManager.distance < 1000 {
                            HStack(alignment: .firstTextBaseline, spacing: 0) {
                                Text("\(locationManager.distance, specifier: "%.2f")")
                                    .font(.large)
                                    .foregroundColor(.primary)
                                Text("m")
                                    .font(.heading)
                                    .foregroundColor(.primary)
                            }
                        } else {
                            HStack(alignment: .firstTextBaseline, spacing: 0) {
                                Text("\(locationManager.distance / 1000, specifier: "%.2f")")
                                    .font(.large)
                                    .foregroundColor(.primary)
                                Text("km")
                                    .font(.heading)
                                    .foregroundColor(.primary)
                            }
                        }
                        
                        // Timer
                        Text(timeString(from: elapsedTime))
                            .font(.heading)
                            .foregroundColor(.secondary)
                        
                        // Speed
                        Text("\(locationManager.speed, specifier: "%.2f") km/h")
                            .font(.heading)
                            .foregroundColor(.secondary)
                    }

                    // Buttons
                    HStack {
                        Button(action: {
                            if isTracking {
                                if isPaused {
                                    locationManager.resumeTracking()
                                    startTimer()
                                    isPaused = false
                                } else {
                                    locationManager.pauseTracking()
                                    timerSubscription?.cancel()
                                    isPaused = true
                                }
                            } else {
                                startTracking()
                            }
                        }) {
                            Text(isTracking ? (isPaused ? "Resume" : "Pause") : "Start")
                                .font(.heading)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.turquoise)
                                .foregroundColor(.background)
                                .cornerRadius(16)
                        }
                        .padding(.leading, 16)
                        .padding(.bottom, 16)
                        
                        Button(action: {
                            if isTracking {
                                stopTracking()
                            } else {
                                locationManager.resetTracking()
                                elapsedTime = 0
                                isTracking = false
                                isPaused = false
                            }
                        }) {
                            Text(isTracking ? "Stop" : "Reset")
                                .font(.heading)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(isTracking ? Color.folly : Color.turquoise)
                                .foregroundColor(isTracking ? .secondary : .background)
                                .cornerRadius(16)
                        }
                        .padding(.trailing, 16)
                        .padding(.bottom, 16)
                    }
                }
            }
        }
    }

    private func startTracking() {
        locationManager.startTracking()
        elapsedTime = 0
        startTimer()
        isTracking = true
        isPaused = false
    }

    private func stopTracking() {
        locationManager.stopTracking()
        timerSubscription?.cancel()
        isTracking = false
        isPaused = false
    }

    private func startTimer() {
        timerSubscription = Timer.publish(every: 1, on: .main, in: .common)
            .autoconnect()
            .sink { _ in
                elapsedTime += 1
            }
    }

    private func timeString(from timeInterval: TimeInterval) -> String {
        let hours = Int(timeInterval) / 3600
        let minutes = (Int(timeInterval) % 3600) / 60
        let seconds = Int(timeInterval) % 60
        return String(format: "%02d:%02d:%02d", hours, minutes, seconds)
    }
}
