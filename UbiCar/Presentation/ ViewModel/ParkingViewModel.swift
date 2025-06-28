import Foundation
import CoreLocation
import Combine

class ParkingViewModel: ObservableObject {
    @Published var lastParking: ParkingLocation?
    
    private let parkingKey = "lastParkingLocation"
    
    init() {
        loadParkingLocation()
    }
    
    func saveParkingLocation(coordinate: CLLocationCoordinate2D, placeName: String?) {
        let parking = ParkingLocation(
            latitude: coordinate.latitude,
            longitude: coordinate.longitude,
            date: Date(),
            placeName: placeName
        )
        if let data = try? JSONEncoder().encode(parking) {
            UserDefaults.standard.set(data, forKey: parkingKey)
            lastParking = parking
        }
    }
    
    func loadParkingLocation() {
        if let data = UserDefaults.standard.data(forKey: parkingKey),
           let parking = try? JSONDecoder().decode(ParkingLocation.self, from: data) {
            lastParking = parking
        }
    }
    
    func clearParkingLocation() {
        UserDefaults.standard.removeObject(forKey: parkingKey)
        lastParking = nil
    }
} 