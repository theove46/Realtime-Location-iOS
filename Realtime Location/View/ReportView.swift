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
                                HStack {
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
                                    Spacer()
                                    Button(action: {
                                        if let index = locationManager.reports.firstIndex(where: { $0.id == report.id }) {
                                            locationManager.reports.remove(at: index)
                                        }
                                    }) {
                                        Image(systemName: "trash")
                                            .foregroundColor(.red)
                                    }
                                }
                            }
                            .padding()
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .background(Color.oxfordBlue)
                            .cornerRadius(8)
                            .padding(.horizontal)
                            .padding(.vertical, 4)
                            .contextMenu {
                                Button(action: {
                                    if let index = locationManager.reports.firstIndex(where: { $0.id == report.id }) {
                                        locationManager.reports.remove(at: index)
                                    }
                                }) {
                                    Text("Delete")
                                    Image(systemName: "trash")
                                }
                            }
                        }
                    }
                }
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .principal) {
                        Text("Reports")
                            .foregroundColor(.azure)
                    }
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button(action: downloadReports) {
                            Image(systemName: "square.and.arrow.down")
                                .foregroundColor(.azure)
                        }
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
    
    private func downloadReports() {
        if let pdfData = PDFGenerator.generatePDF(from: locationManager.reports) {
            let fileName = "Reports.pdf"
            let fileManager = FileManager.default
            let documentsURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first!
            let fileURL = documentsURL.appendingPathComponent(fileName)

            do {
                try pdfData.write(to: fileURL)
                print("PDF saved to: \(fileURL.path)")
                sharePDF(fileURL: fileURL)  // Call share function if needed
            } catch {
                print("Could not save PDF file: \(error)")
            }
        }
    }

    private func sharePDF(fileURL: URL) {
        // Present the share sheet
        let activityViewController = UIActivityViewController(activityItems: [fileURL], applicationActivities: nil)
        if let rootViewController = UIApplication.shared.windows.first?.rootViewController {
            rootViewController.present(activityViewController, animated: true, completion: nil)
        }
    }
    
}
