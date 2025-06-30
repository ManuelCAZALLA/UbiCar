import SwiftUI
import CoreLocation


struct ContentView: View {
    
    @StateObject private var viewModel = ParkingViewModel()
    @StateObject private var locationManager = LocationManager.shared
    @State private var showingAlert = false
    @State private var showMap = false
    @State private var lastGeocodeDate: Date?
    @State private var parkingNote: String = ""
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 30) {
                    headerSection
                    locationSection
                    noteInputSection
                    parkingButtonSection
                    lastParkingSection
                }
                .padding(.bottom, 40)
            }
           
        }
        .onAppear { viewModel.updatePlaceName() }
        .onChange(of: locationManager.userLocation) {
            viewModel.updatePlaceName()
        }
    }

    private var headerSection: some View {
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
    }

    private var locationSection: some View {
        Group {
            if locationManager.userLocation != nil {
                VStack(spacing: 4) {
                    Label("current_location".localized, systemImage: "location.fill")
                        .font(.headline)
                        .foregroundColor(.secondary)
                    if let placeName = viewModel.placeName {
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
    }

    private var noteInputSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Nota para el aparcamiento (opcional):")
                .font(.subheadline)
            TextField("Escribe una nota...", text: $parkingNote)
                .textFieldStyle(RoundedBorderTextFieldStyle())
        }
        .padding(.horizontal)
    }

    private var parkingButtonSection: some View {
        ParkingButton(enabled: locationManager.userLocation != nil) {
            if let _ = locationManager.userLocation {
                viewModel.saveParkingLocation(note: parkingNote.isEmpty ? nil : parkingNote)
                parkingNote = ""
                showingAlert = true
            }
        }
        .padding(.horizontal)
        .alert("location_saved".localized, isPresented: $showingAlert) {
            Button("ok".localized, role: .cancel) {}
        }
    }

    private var lastParkingSection: some View {
        Group {
            if let last = viewModel.lastParking {
                ParkingInfoCard(parking: last, onDelete: {
                    viewModel.clearParkingLocation()
                }, onNavigate: {
                    showMap = true
                    viewModel.speakDistance(to: last)
                }, note: last.note)
                .padding(.horizontal)
                .sheet(isPresented: $showMap) {
                    MapView(parkingLocation: last)
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
