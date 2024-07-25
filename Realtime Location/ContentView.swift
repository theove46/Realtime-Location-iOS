import SwiftUI

struct ContentView: View {
    @ObservedObject var locationManager = LocationManager()
    @State private var isTracking = false

    var body: some View {
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
                
                Spacer()
                
                // Current Location
                VStack(alignment: .center, spacing: 10) {
                    Text("Current Location")
                        .font(.system(size: 16))
                        .foregroundColor(Color.turquoise)
                    if let location = locationManager.location {
                        Text("Lat: \(location.coordinate.latitude, specifier: "%.4f")")
                            .font(.system(size: 12))
                            .foregroundColor(.white)
                        Text("Lng: \(location.coordinate.longitude, specifier: "%.4f")")
                            .font(.system(size: 12))
                            .foregroundColor(.white)
                    } else {
                        Text("Lat: --.--")
                            .font(.system(size: 12))
                            .foregroundColor(.white)
                        Text("Lng: --.--")
                            .font(.system(size: 12))
                            .foregroundColor(.white)
                    }
                }
                .padding(.leading, 16)
                .padding(.top, 16)

                Spacer()

                HStack(spacing: 50) {
                    // Starting Location
                    VStack(alignment: .center, spacing: 10) {
                        Text("Starting")
                            .font(.system(size: 16))
                            .foregroundColor(Color.turquoise)
                        if let startLocation = locationManager.startingLocation {
                            Text("Lat: \(startLocation.coordinate.latitude, specifier: "%.4f")")
                                .font(.system(size: 12))
                                .foregroundColor(.white)
                            Text("Lng: \(startLocation.coordinate.longitude, specifier: "%.4f")")
                                .font(.system(size: 12))
                                .foregroundColor(.white)
                        } else {
                            Text("Lat: ----")
                                .font(.system(size: 12))
                                .foregroundColor(.white)
                            Text("Lng: ----")
                                .font(.system(size: 12))
                                .foregroundColor(.white)
                        }
                    }
                    .padding(.leading, 32)

                    Spacer()

                    // Ending Location
                    VStack(alignment: .center, spacing: 10) {
                        Text("Ending")
                            .font(.system(size: 16))
                            .foregroundColor(Color.turquoise)
                        if let endLocation = locationManager.endingLocation {
                            Text("Lat: \(endLocation.coordinate.latitude, specifier: "%.4f")")
                                .font(.system(size: 12))
                                .foregroundColor(.white)
                            Text("Lng: \(endLocation.coordinate.longitude, specifier: "%.4f")")
                                .font(.system(size: 12))
                                .foregroundColor(.white)
                        } else {
                            Text("Lat: ----")
                                .font(.system(size: 12))
                                .foregroundColor(.white)
                            Text("Lng: ----")
                                .font(.system(size: 12))
                                .foregroundColor(.white)
                        }
                    }
                    .padding(.trailing, 32)
                }

                Spacer()

                // Distance
                VStack() {
                    Text("Distance")
                        .font(.system(size: 16))
                        .foregroundColor(Color.turquoise)
                    if locationManager.distance < 1000 {
                        HStack(alignment: .firstTextBaseline, spacing: 0) {
                            Text("\(locationManager.distance, specifier: "%.2f")")
                                .font(.system(size: 60))
                                .foregroundColor(.white)
                            Text("m")
                                .font(.system(size: 16))
                                .foregroundColor(.white)
                        }
                    } else {
                        HStack(alignment: .firstTextBaseline, spacing: 0) {
                            Text("\(locationManager.distance / 1000, specifier: "%.2f")")
                                .font(.system(size: 60))
                                .foregroundColor(.white)
                            Text("km")
                                .font(.system(size: 16))
                                .foregroundColor(.white)
                        }
                    }
                }

                Spacer()

                // Start/Stop Button
                Button(action: {
                    if isTracking {
                        locationManager.stopTracking()
                    } else {
                        locationManager.startTracking()
                    }
                    isTracking.toggle()
                }) {
                    Text(isTracking ? "Stop" : "Start")
                        .font(.system(size: 24))
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.turquoise)
                        .foregroundColor(Color.persianBlue)
                        .cornerRadius(16)
                }
                .padding(.horizontal, 16)
                .padding(.bottom, 16)
            }
        }
    }
}
