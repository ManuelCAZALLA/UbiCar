//
//  ContentView.swift
//  UbiCar
//
//  Created by Manuel Cazalla Colmenero on 22/6/25.
//

import SwiftUI
import CoreLocation

struct ContentView: View {
    @StateObject private var viewModel = ParkingViewModel()
    @StateObject private var locationManager = LocationManager.shared
    @State private var showingAlert = false
    @State private var showMap = false
    @State private var showCompass = false
    @State private var placeName: String = ""  // Nombre del lugar
    
    var body: some View {
        VStack(spacing: 32) {
            Text("UbiCar")
                .font(.largeTitle)
                .bold()
            
            let status = CLLocationManager.authorizationStatus()
            let userLocation = locationManager.userLocation

            if let _ = userLocation {
                VStack {
                    Text("Tu ubicación actual:")
                        .font(.headline)
                    if placeName.isEmpty {
                        Text("Obteniendo dirección…")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    } else {
                        Text(placeName)
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
            
            Button(action: {
                if let location = userLocation {
                    viewModel.saveParkingLocation(coordinate: location)
                    showingAlert = true
                }
            }) {
                Text("Aparcado aquí")
                    .font(.title2)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(userLocation != nil ? Color.blue : Color.gray)
                    .foregroundColor(.white)
                    .cornerRadius(12)
            }
            .disabled(userLocation == nil)
            .alert("Ubicación guardada", isPresented: $showingAlert) {
                Button("OK", role: .cancel) { }
            }
            
            if let last = viewModel.lastParking {
                VStack {
                    Text("Último aparcamiento:")
                        .font(.headline)
                    Text("Lat: \(last.latitude), Lon: \(last.longitude)")
                        .font(.subheadline)
                    Text("Fecha: \(last.date.formatted(date: .abbreviated, time: .shortened))")
                        .font(.caption)
                        .foregroundColor(.gray)
                }
                Button("Borrar ubicación") {
                    viewModel.clearParkingLocation()
                }
                .foregroundColor(.red)
                Button("Ver mapa y guía por voz") {
                    showMap = true
                    if let userLocation = userLocation {
                        let distance = CLLocation(latitude: userLocation.latitude, longitude: userLocation.longitude)
                            .distance(from: CLLocation(latitude: last.latitude, longitude: last.longitude))
                        let texto = "Tu coche está a \(Int(distance)) metros."
                        VoiceGuideService.shared.speak(texto)
                    }
                }
                .padding(.top, 8)
                .sheet(isPresented: $showMap) {
                    MapView(parkingLocation: last)
                }
                Button("Brújula / Flecha") {
                    showCompass = true
                }
                .padding(.top, 8)
                .sheet(isPresented: $showCompass) {
                    CompassView(target: CLLocationCoordinate2D(latitude: last.latitude, longitude: last.longitude))
                }
            }
        }
        .padding()
        .onAppear {
            locationManager.requestAuthorization()
            locationManager.start()
            
            if let location = locationManager.userLocation {
                locationManager.getPlaceName(for: location) { name in
                    DispatchQueue.main.async {
                        placeName = name
                    }
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
