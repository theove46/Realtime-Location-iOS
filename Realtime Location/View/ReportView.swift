import SwiftUI

struct ReportView: View {
    @ObservedObject var locationManager: LocationManager

    var body: some View {
        NavigationView {
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

                // List of reports
                ScrollView {
                    VStack {
                        ForEach(locationManager.reports) { report in
                            VStack(alignment: .leading) {
                                Text("Date: \(report.date, formatter: dateFormatter)")
                                    .font(.normal)
                                    .foregroundColor(.azure)
                                Text("Start: \(report.startLocation.coordinate.latitude), \(report.startLocation.coordinate.longitude)")
                                    .font(.normal)
                                    .foregroundColor(.azure)
                                Text("End: \(report.endLocation.coordinate.latitude), \(report.endLocation.coordinate.longitude)")
                                    .font(.normal)
                                    .foregroundColor(.azure)
                                Text(formattedDistance(for: report.totalDistance))
                                    .font(.normal)
                                    .foregroundColor(.azure)
                                Text("Duration: \(timeString(from: report.duration))")
                                    .font(.normal)
                                    .foregroundColor(.azure)
                                Text("Avg Speed: \(report.averageSpeed, specifier: "%.2f") km/h")
                                    .font(.normal)
                                    .foregroundColor(.azure)
                            }
                            .padding()
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .background(Color.oxfordBlue)
                            .cornerRadius(8)
                            .padding(.horizontal)
                            .padding(.vertical, 4)
                        }
                    }
                }
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .principal) {
                        Text("Reports")
                            .foregroundColor(.azure)
                    }
                }
            }
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
    
    private func formattedDistance(for distance: Double) -> String {
            if distance >= 1000 {
                return String(format: "Distance: %.2f km", distance / 1000)
            } else {
                return String(format: "Distance: %.2f m", distance)
            }
        }
}
