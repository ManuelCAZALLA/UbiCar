import Foundation
import CoreLocation
import Combine
import AVFoundation

final class ParkingViewModel: NSObject, ObservableObject {
    @Published var lastParking: ParkingLocation?
    @Published var userLocation: CLLocationCoordinate2D?
    @Published var authorizationStatus: CLAuthorizationStatus = .notDetermined
    @Published var placeName: String?
    @Published var showingAlert = false
    
    private let parkingKey = "lastParkingLocation"
    private let locationManager = CLLocationManager()
    private let speechSynthesizer = AVSpeechSynthesizer()
    
    override init() {
        super.init()
        locationManager.delegate = self
        authorizationStatus = locationManager.authorizationStatus
        loadParkingLocation()
        
        if authorizationStatus == .authorizedWhenInUse || authorizationStatus == .authorizedAlways {
            locationManager.startUpdatingLocation()
        }
    }
    
    func requestLocation() {
        locationManager.requestWhenInUseAuthorization()
    }
    
    func saveParkingLocation() {
        guard let coordinate = userLocation else { return }
        let parking = ParkingLocation(
            latitude: coordinate.latitude,
            longitude: coordinate.longitude,
            date: Date(),
            placeName: placeName
        )
        if let data = try? JSONEncoder().encode(parking) {
            UserDefaults.standard.set(data, forKey: parkingKey)
            lastParking = parking
            showingAlert = true
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
    
    // MARK: - Nueva función para actualizar el nombre del lugar
    func updatePlaceName() {
        guard let location = userLocation else { return }
        let loc = CLLocation(latitude: location.latitude, longitude: location.longitude)
        CLGeocoder().reverseGeocodeLocation(loc) { [weak self] placemarks, error in
            if let placemark = placemarks?.first {
                let name = placemark.name ?? placemark.locality ?? placemark.country
                DispatchQueue.main.async {
                    self?.placeName = name
                }
            } else {
                DispatchQueue.main.async {
                    self?.placeName = nil
                }
            }
        }
    }
    
    // MARK: - Nueva función para hablar la distancia al coche
    func speakDistance(to parking: ParkingLocation) {
        guard let userLoc = userLocation else { return }
        let userLocation = CLLocation(latitude: userLoc.latitude, longitude: userLoc.longitude)
        let carLocation = CLLocation(latitude: parking.latitude, longitude: parking.longitude)
        let distance = userLocation.distance(from: carLocation)
        let texto = "Tu coche está a \(Int(distance)) metros."
        let utterance = AVSpeechUtterance(string: texto)
        utterance.voice = AVSpeechSynthesisVoice(language: "es-ES")
        speechSynthesizer.speak(utterance)
    }
}

extension ParkingViewModel: CLLocationManagerDelegate {
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        authorizationStatus = manager.authorizationStatus
        if authorizationStatus == .authorizedWhenInUse || authorizationStatus == .authorizedAlways {
            locationManager.startUpdatingLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let newLocation = locations.last else { return }
        userLocation = newLocation.coordinate
        updatePlaceName()  // Llamamos aquí para mantener placeName actualizado
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        userLocation = nil
        placeName = nil
    }
}
