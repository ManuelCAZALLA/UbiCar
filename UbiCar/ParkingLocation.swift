import Foundation
import CoreLocation

struct ParkingLocation: Codable, Identifiable {
    let id: UUID
    let latitude: Double
    let longitude: Double
    let date: Date

    init(latitude: Double, longitude: Double, date: Date, id: UUID = UUID()) {
        self.latitude = latitude
        self.longitude = longitude
        self.date = date
        self.id = id
    }
} 