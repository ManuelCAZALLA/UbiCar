import SwiftUI
import MapKit

struct MapView: View {
    let parkingLocation: ParkingLocation
    @State private var cameraPosition: MapCameraPosition
    @State private var route: MKRoute?

    init(parkingLocation: ParkingLocation) {
        self.parkingLocation = parkingLocation
        _cameraPosition = State(initialValue: .region(
            MKCoordinateRegion(
                center: CLLocationCoordinate2D(latitude: parkingLocation.latitude, longitude: parkingLocation.longitude),
                span: MKCoordinateSpan(latitudeDelta: 0.005, longitudeDelta: 0.005)
            )
        ))
    }

    var body: some View {
        Map(position: $cameraPosition) {
            // Anotación personalizada
            Annotation("Coche", coordinate: CLLocationCoordinate2D(latitude: parkingLocation.latitude, longitude: parkingLocation.longitude)) {
                Image(systemName: "car.fill")
                    .font(.title)
                    .foregroundColor(.red)
                    .background(Circle().fill(Color.white).frame(width: 36, height: 36))
            }
        }
        .mapControls {
            MapUserLocationButton()
            MapCompass()
        }
        .edgesIgnoringSafeArea(.all)
        .onAppear {
            calculateRoute()
        }
        .overlay(
            VStack {
                if let route = route {
                    Text("Distancia: \(String(format: "%.0f", route.distance)) m")
                        .padding(8)
                        .background(Color.white.opacity(0.8))
                        .cornerRadius(8)
                        .padding()
                }
                Spacer()
            }
        )
    }

    private func calculateRoute() {
        let request = MKDirections.Request()
        request.source = MKMapItem.forCurrentLocation()
        request.destination = MKMapItem(placemark: MKPlacemark(coordinate: CLLocationCoordinate2D(latitude: parkingLocation.latitude, longitude: parkingLocation.longitude)))
        request.transportType = .walking

        let directions = MKDirections(request: request)
        directions.calculate { response, error in
            if let route = response?.routes.first {
                self.route = route
            }
        }
    }
} 