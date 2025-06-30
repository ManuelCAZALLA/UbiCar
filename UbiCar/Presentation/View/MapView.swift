import SwiftUI
import MapKit

struct MapView: View {
    @StateObject private var viewModel: MapViewModel
    @State private var cameraPosition: MapCameraPosition
    
    init(parkingLocation: ParkingLocation) {
        
        let coord = CLLocationCoordinate2D(latitude: parkingLocation.latitude, longitude: parkingLocation.longitude)
        _viewModel = StateObject(wrappedValue: MapViewModel(parkingLocation: coord))
        _cameraPosition = State(initialValue: .region(
            MKCoordinateRegion(center: coord, span: MKCoordinateSpan(latitudeDelta: 0.005, longitudeDelta: 0.005))
        ))
    }
    
    var body: some View {
        Map(position: $cameraPosition) {
            Annotation("Coche", coordinate: viewModel.parkingLocation) {
                Image(systemName: "car.fill")
                    .font(.title)
                    .foregroundColor(.red)
                    .background(Circle().fill(Color.white).frame(width: 36, height: 36))
            }
            
            if let userCoord = viewModel.userLocation {
                Annotation("Tú", coordinate: userCoord) {
                    VStack(spacing: 4) {
                        Image(systemName: "person.fill")
                            .font(.title)
                            .foregroundColor(.blue)
                        if let distance = viewModel.distanceToCar() {
                            Text("\(distance) m")
                                .font(.caption2)
                                .padding(4)
                                .background(Color.white.opacity(0.8))
                                .cornerRadius(6)
                        }
                    }
                }
            }
        }
        .mapControls {
            MapUserLocationButton()
            MapCompass()
        }
        .edgesIgnoringSafeArea(.all)
        .onAppear {
            viewModel.calculateRoute()
        }
        .overlay(
            VStack {
                if let route = viewModel.route {
                    Text("Distancia: \(Int(route.distance)) m")
                        .padding(8)
                        .background(Color.white.opacity(0.8))
                        .cornerRadius(8)
                        .padding()
                }
                Spacer()
            }
        )
    }
}

#Preview {
    let exampleParking = ParkingLocation(
        latitude: 40.4168,  // Madrid
        longitude: -3.7038,
        date: Date(),
        placeName: "Aparcado en la Gran Vía"
    )
    return MapView(parkingLocation: exampleParking)
}
