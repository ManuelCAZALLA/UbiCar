import SwiftUI
import CoreLocation

struct LaunchView: View {
    @StateObject private var locationManager = LocationManager.shared
    @State private var isAuthorized = false

    var body: some View {
        Group {
            if isAuthorized {
                ContentView()
            } else {
                VStack(spacing: 32) {
                    Image("UbiCar") 
                        .resizable()
                        .scaledToFit()
                        .frame(width: 180, height: 180)
                    Text("Bienvenido a UbiCar")
                        .font(.largeTitle)
                        .bold()
                    Button("Permitir ubicación") {
                        locationManager.requestAuthorization()
                    }
                    .font(.title2)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(12)
                }
                .onAppear {
                    checkAuthorization()
                }
                .onReceive(locationManager.$authorizationStatus) { _ in
                    checkAuthorization()
                }
            }
        }
        .animation(.easeInOut, value: isAuthorized)
    }

    private func checkAuthorization() {
        let status = locationManager.authorizationStatus
        if status == .authorizedWhenInUse || status == .authorizedAlways {
            isAuthorized = true
        }
    }
} 
