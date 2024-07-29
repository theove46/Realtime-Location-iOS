import SwiftUI

struct ReportView: View {
    @ObservedObject var locationManager: LocationManager

    var body: some View {
        NavigationView {
            List(locationManager.reports) { report in
                VStack(alignment: .leading) {
                    Text("Date: \(report.date, formatter: dateFormatter)")
                        .font(.headline)
                    Text("Start: \(report.startLocation.coordinate.latitude), \(report.startLocation.coordinate.longitude)")
                    Text("End: \(report.endLocation.coordinate.latitude), \(report.endLocation.coordinate.longitude)")
                    Text("Distance: \(report.totalDistance, specifier: "%.2f") meters")
                    Text("Duration: \(timeString(from: report.duration))")
                    Text("Avg Speed: \(report.averageSpeed, specifier: "%.2f") km/h")
                }
                .padding()
                .background(Color(.secondarySystemBackground))
                .cornerRadius(8)
            }
            .navigationTitle("Reports")
        }
    }

    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        return formatter
    }()

    private func timeString(from timeInterval: TimeInterval) -> String {
        let hours = Int(timeInterval) / 3600
        let minutes = (Int(timeInterval) % 3600) / 60
        let seconds = Int(timeInterval) % 60
        return String(format: "%02d:%02d:%02d", hours, minutes, seconds)
    }
}
