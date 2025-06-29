import SwiftUI
import CoreLocation

struct ContentView: View {
    @StateObject private var viewModel = ParkingViewModel()
    @StateObject private var locationManager = LocationManager.shared
    @State private var showingAlert = false
    @State private var placeName: String?
    @State private var navigateToMap = false

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 30) {
                    VStack(spacing: 8) {
                        Image("UbiCar")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 120, height: 120)
                            .shadow(radius: 10)
                        
                        Text("find_car_easily".localized)
                            .font(.largeTitle.weight(.semibold))
                            .foregroundColor(.blue)
                    }
                    .padding(.top, 20)
                    
                    Group {
                        if let userLocation = locationManager.userLocation {
                            VStack(spacing: 4) {
                                Label("current_location".localized, systemImage: "location.fill")
                                    .font(.headline)
                                    .foregroundColor(.secondary)
                                
                                if let placeName = placeName {
                                    Text(placeName)
                                        .font(.title3)
                                        .foregroundColor(.primary)
                                } else {
                                    ProgressView("getting_place_name".localized)
                                        .progressViewStyle(CircularProgressViewStyle(tint: .blue))
                                }
                            }
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color(.systemGray6))
                            .cornerRadius(15)
                            .shadow(color: Color.black.opacity(0.1), radius: 8, x: 0, y: 4)
                            .padding(.horizontal)
                        } else {
                            LocationStatusView(status: locationManager.authorizationStatus)
                                .padding(.horizontal)
                        }
                    }
                    
                    ParkingButton(enabled: locationManager.userLocation != nil) {
                        if let location = locationManager.userLocation {
                            viewModel.saveParkingLocation(coordinate: location, placeName: placeName)
                            showingAlert = true
                        }
                    }
                    .padding(.horizontal)
                    .alert("location_saved".localized, isPresented: $showingAlert) {
                        Button("ok".localized, role: .cancel) {}
                    }
                    
                    if let last = viewModel.lastParking {
                        ParkingInfoCard(parking: last, onDelete: {
                            viewModel.clearParkingLocation()
                        }, onNavigate: {
                            speakDistance(to: last)
                            navigateToMap = true
                        })
                        .padding(.horizontal)
                        
                        NavigationLink(
                            destination: MapView(parkingLocation: last),
                            isActive: $navigateToMap
                        ) {
                            EmptyView()
                        }
                        .hidden()
                    }
                }
                .padding(.bottom, 40)
            }
            .navigationTitle("app_name".localized)
        }
        .onAppear {
            updatePlaceName()
        }
        .onChange(of: locationManager.userLocation) { _ in
            updatePlaceName()
        }
    }
}

#Preview {
    ContentView()
    
}
