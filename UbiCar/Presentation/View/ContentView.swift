import SwiftUI
import CoreLocation

struct ContentView: View {
    @StateObject private var viewModel = ParkingViewModel()
    @StateObject private var locationManager = LocationManager.shared
    @State private var showingAlert = false
    @State private var showMap = false
    @State private var showCompass = false
    @State private var placeName: String?
    
    var body: some View {
        VStack(spacing: 32) {
            Image("UbiCar")
                .resizable()
                .scaledToFit()
                .frame(width: 180, height: 180)
            
            let status = locationManager.authorizationStatus
            let userLocation = locationManager.userLocation
            
            if let location = userLocation {
                VStack {
                    Text("Tu ubicación actual:")
                        .font(.headline)
                    if let placeName = placeName {
                        Text(placeName)
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    } else {
                        Text("Obteniendo nombre del lugar…")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                }
            } else if status == .authorizedWhenInUse || status == .authorizedAlways {
                Text("Obteniendo ubicación…")
                    .foregroundColor(.gray)
            } else if status == .notDetermined {
                Text("Esperando permiso de localización…")
                    .foregroundColor(.gray)
            } else {
                Text("Ubicación no disponible")
                    .foregroundColor(.red)
            }
            
            ParkingButton(enabled: userLocation != nil) {
                if let location = userLocation {
                    viewModel.saveParkingLocation(coordinate: location, placeName: placeName)
                    showingAlert = true
                }
            }
            .alert("Ubicación guardada", isPresented: $showingAlert) {
                Button("OK", role: .cancel) { }
            }
            
            if let last = viewModel.lastParking {
                VStack {
                    Text("Último aparcamiento:")
                        .font(.headline)
                    if let name = last.placeName {
                        Text(name)
                            .font(.subheadline)
                    } else {
                        Text("Lat: \(last.latitude), Lon: \(last.longitude)")
                            .font(.subheadline)
                    }
                    Text("Fecha: \(last.date.formatted(date: .abbreviated, time: .shortened))")
                        .font(.caption)
                        .foregroundColor(.gray)
                }
                DeleteButton {
                    viewModel.clearParkingLocation()
                }
                MapGuideButton {
                    showMap = true
                    if let userLocation = userLocation {
                        let distance = CLLocation(latitude: userLocation.latitude, longitude: userLocation.longitude)
                            .distance(from: CLLocation(latitude: last.latitude, longitude: last.longitude))
                        let texto = "Tu coche está a \(Int(distance)) metros."
                        VoiceGuideService.shared.speak(texto)
                    }
                }
                .sheet(isPresented: $showMap) {
                    MapView(parkingLocation: last)
                }
                CompassButton {
                    showCompass = true
                }
                .sheet(isPresented: $showCompass) {
                    CompassView(target: CLLocationCoordinate2D(latitude: last.latitude, longitude: last.longitude))
                }
            }
        }
        .padding()
        
        .onAppear {
            if let location = locationManager.userLocation {
                LocationManager.shared.getPlaceName(for: location) { name in
                    DispatchQueue.main.async {
                        placeName = name
                    }
                }
            }
        }
    }
}
