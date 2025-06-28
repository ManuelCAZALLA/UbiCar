import Foundation
import CoreLocation

struct ParkingLocation: Codable, Identifiable {
    let id: UUID
    let latitude: Double
    let longitude: Double
    let date: Date
    let placeName: String?

    init(latitude: Double, longitude: Double, date: Date, placeName: String?, id: UUID = UUID()) {
        self.latitude = latitude
        self.longitude = longitude
        self.date = date
        self.placeName = placeName
        self.id = id
    }
} 