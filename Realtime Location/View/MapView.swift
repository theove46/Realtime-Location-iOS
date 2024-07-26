import SwiftUI
import MapKit

struct MapView: UIViewRepresentable {
    @ObservedObject var locationManager: LocationManager

    func makeUIView(context: Context) -> MKMapView {
        let mapView = MKMapView()
        mapView.delegate = context.coordinator
        mapView.showsUserLocation = true
        return mapView
    }

    func updateUIView(_ uiView: MKMapView, context: Context) {
        // Update the map region based on the current location
        if let location = locationManager.location {
            let region = MKCoordinateRegion(center: location.coordinate, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
            uiView.setRegion(region, animated: true)
        }

        // Remove existing overlays and annotations
        uiView.removeOverlays(uiView.overlays)
        uiView.removeAnnotations(uiView.annotations)

        // Add journey track
        let coordinates = locationManager.path.map { $0.coordinate }
        let polyline = MKPolyline(coordinates: coordinates, count: coordinates.count)
        uiView.addOverlay(polyline)

        // Add starting point annotation
        if let startingLocation = locationManager.startingLocation {
            let startAnnotation = MKPointAnnotation()
            startAnnotation.coordinate = startingLocation.coordinate
            startAnnotation.title = "Start"
            uiView.addAnnotation(startAnnotation)
        }

        // Add current location annotation
        if let currentLocation = locationManager.location {
            let currentAnnotation = MKPointAnnotation()
            currentAnnotation.coordinate = currentLocation.coordinate
            currentAnnotation.title = "Current"
            uiView.addAnnotation(currentAnnotation)
        }
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, MKMapViewDelegate {
        var parent: MapView

        init(_ parent: MapView) {
            self.parent = parent
        }

        func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
            if let polyline = overlay as? MKPolyline {
                let renderer = MKPolylineRenderer(polyline: polyline)
                renderer.strokeColor = UIColor(Color.folly)
                renderer.lineWidth = 4
                return renderer
            }
            return MKOverlayRenderer(overlay: overlay)
        }

        func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
            guard let annotation = annotation as? MKPointAnnotation else { return nil }

            let identifier = "CustomAnnotation"
            var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)

            if annotationView == nil {
                annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            } else {
                annotationView?.annotation = annotation
            }

            if annotation.title == "Start" {
                // Create a UIImage with SF Symbol for the starting point
                annotationView?.image = UIImage(systemName: "mappin.and.ellipse.circle.fill")?.withRenderingMode(.alwaysTemplate)
            } else if annotation.title == "Current" {
                // Create a UIImage with SF Symbol for the current location
                annotationView?.image = UIImage(systemName: "mappin.and.ellipse.circle.fill")?.withRenderingMode(.alwaysTemplate)
            }

            return annotationView
        }
    }
}
