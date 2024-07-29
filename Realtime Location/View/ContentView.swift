import SwiftUI

struct ContentView: View {
    @ObservedObject var locationManager = LocationManager()

    var body: some View {
        TabView {
            DistanceView(locationManager: locationManager)
                .tabItem {
                    Image(systemName: "house.circle")
                }

            MapView(locationManager: locationManager)
                .tabItem {
                    Image(systemName: "map.circle")
                }
            
            ReportView(locationManager: locationManager)
                .tabItem {
                    Image(systemName: "newspaper.circle.fill")
                }
        }
        .accentColor(Color.turquoise)
    }
}
