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
                    AllowLocationButton {
                        locationManager.requestAuthorization()
                    }
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
        let status = CLLocationManager.authorizationStatus()
        if status == .authorizedWhenInUse || status == .authorizedAlways {
            isAuthorized = true
        }
    }
} 
