//
//  MapViewModel.swift
//  UbiCar
//
//  Created by Manuel Cazalla Colmenero on 29/6/25.
//

import Foundation
import MapKit
import AVFoundation
import CoreLocation

class MapViewModel: NSObject, ObservableObject {
    @Published var route: MKRoute?
    @Published var userLocation: CLLocationCoordinate2D?
    let parkingLocation: CLLocationCoordinate2D
    
    private let speechSynthesizer = AVSpeechSynthesizer()
    private let locationManager = CLLocationManager()
    private var lastSpokenStepIndex: Int? = nil
    
    init(parkingLocation: CLLocationCoordinate2D) {
        self.parkingLocation = parkingLocation
        super.init()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    func calculateRoute() {
        let request = MKDirections.Request()
        request.source = MKMapItem.forCurrentLocation()
        request.destination = MKMapItem(placemark: MKPlacemark(coordinate: parkingLocation))
        request.transportType = .walking
        
        let directions = MKDirections(request: request)
        directions.calculate { [weak self] response, error in
            if let route = response?.routes.first {
                DispatchQueue.main.async {
                    self?.route = route
                    self?.speakDistance(route.distance)
                }
            } else if let error = error {
                print("Error calculando ruta: \(error.localizedDescription)")
            }
        }
    }
    
    func distanceToCar() -> Int? {
        guard let userCoord = userLocation else { return nil }
        let userLoc = CLLocation(latitude: userCoord.latitude, longitude: userCoord.longitude)
        let carLoc = CLLocation(latitude: parkingLocation.latitude, longitude: parkingLocation.longitude)
        let distance = userLoc.distance(from: carLoc)
        return Int(distance)
    }
    
    private func speakDistance(_ distance: CLLocationDistance) {
        let meters = Int(distance)
        let utterance = AVSpeechUtterance(string: "Tu coche está a \(meters) metros.")
        utterance.voice = AVSpeechSynthesisVoice(language: "es-ES")
        speechSynthesizer.speak(utterance)
    }
    
    func announceClosestStepIfNeeded() {
        guard let route = route, let userCoord = userLocation else { return }
        let userLoc = CLLocation(latitude: userCoord.latitude, longitude: userCoord.longitude)
        var closestIndex: Int?
        var minDistance: CLLocationDistance = .greatestFiniteMagnitude
        for (i, step) in route.steps.enumerated() {
            let stepLoc = CLLocation(latitude: step.polyline.coordinate.latitude, longitude: step.polyline.coordinate.longitude)
            let distance = userLoc.distance(from: stepLoc)
            if distance < minDistance {
                minDistance = distance
                closestIndex = i
            }
        }
        // Solo anunciar si es un paso nuevo y la instrucción no está vacía
        if let idx = closestIndex, idx != lastSpokenStepIndex {
            let step = route.steps[idx]
            if !step.instructions.isEmpty {
                let utterance = AVSpeechUtterance(string: step.instructions)
                utterance.voice = AVSpeechSynthesisVoice(language: "es-ES")
                speechSynthesizer.speak(utterance)
                lastSpokenStepIndex = idx
            }
        }
    }
}

extension MapViewModel: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        DispatchQueue.main.async {
            self.userLocation = locations.last?.coordinate
            self.announceClosestStepIfNeeded()
        }
    }
}
