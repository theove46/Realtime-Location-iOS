import SwiftUI
import PDFKit

class PDFGenerator {
    static func generatePDF(from reports: [ReportManager]) -> Data? {
        let pdfMetaData = [
            kCGPDFContextCreator: "Your App",
            kCGPDFContextAuthor: "Your Name",
            kCGPDFContextTitle: "Reports"
        ]
        let format = UIGraphicsPDFRendererFormat()
        format.documentInfo = pdfMetaData as [String: Any]
        
        let pageWidth = 8.5 * 72.0
        let pageHeight = 11 * 72.0
        let pageRect = CGRect(x: 0, y: 0, width: pageWidth, height: pageHeight)
        let renderer = UIGraphicsPDFRenderer(bounds: pageRect, format: format)
        
        let data = renderer.pdfData { (context) in
            context.beginPage()
            
            let font = UIFont.systemFont(ofSize: 12)
            let attributes = [NSAttributedString.Key.font: font]
            var yPosition: CGFloat = 20
            
            for report in reports {
                let reportString = """
                Date: \(report.date)
                Start: \(report.startLocation.coordinate.latitude), \(report.startLocation.coordinate.longitude)
                End: \(report.endLocation.coordinate.latitude), \(report.endLocation.coordinate.longitude)
                \(formattedDistance(for: report.totalDistance))
                Duration: \(timeString(from: report.duration))
                Avg Speed: \(report.averageSpeed) km/h
                """
                let text = NSAttributedString(string: reportString, attributes: attributes)
                text.draw(at: CGPoint(x: 20, y: yPosition))
                yPosition += 100
                
                if yPosition > pageHeight - 100 {
                    context.beginPage()
                    yPosition = 20
                }
            }
        }
        return data
    }

    private static func formattedDistance(for distance: Double) -> String {
        if distance >= 1000 {
            return String(format: "Distance: %.2f km", distance / 1000)
        } else {
            return String(format: "Distance: %.2f m", distance)
        }
    }

    private static func timeString(from timeInterval: TimeInterval) -> String {
        let hours = Int(timeInterval) / 3600
        let minutes = (Int(timeInterval) % 3600) / 60
        let seconds = Int(timeInterval) % 60
        return String(format: "%02d:%02d:%02d", hours, minutes, seconds)
    }
}
