import SwiftUI
import CoreLocation

struct CompassView: View {
    let target: CLLocationCoordinate2D
    @StateObject private var compass = CompassService()

    private func angleToTarget() -> Double {
        guard let user = compass.userLocation, let heading = compass.heading else { return 0 }
        let bearing = getBearing(from: user, to: target)
        let angle = bearing - heading.trueHeading
        return Angle(degrees: angle).radians
    }

    var body: some View {
        VStack(spacing: 24) {
            Text("Flecha hacia tu coche")
                .font(.headline)
            ZStack {
                Image(systemName: "location.north.fill")
                    .resizable()
                    .frame(width: 120, height: 120)
                    .foregroundColor(.gray.opacity(0.2))
                Image(systemName: "arrow.up.circle.fill")
                    .resizable()
                    .frame(width: 80, height: 80)
                    .foregroundColor(.blue)
                    .rotationEffect(.radians(angleToTarget()))
            }
            if let heading = compass.heading {
                Text("Rumbo: \(Int(heading.trueHeading))º")
            }
        }
        .padding()
    }

    // Cálculo del rumbo entre dos coordenadas
    private func getBearing(from: CLLocationCoordinate2D, to: CLLocationCoordinate2D) -> Double {
        let fromLat = from.latitude.degreesToRadians
        let fromLon = from.longitude.degreesToRadians
        let toLat = to.latitude.degreesToRadians
        let toLon = to.longitude.degreesToRadians

        let dLon = toLon - fromLon
        let y = sin(dLon) * cos(toLat)
        let x = cos(fromLat) * sin(toLat) - sin(fromLat) * cos(toLat) * cos(dLon)
        let radiansBearing = atan2(y, x)
        var degreesBearing = radiansBearing.radiansToDegrees
        if degreesBearing < 0 { degreesBearing += 360 }
        return degreesBearing
    }
}

private extension Double {
    var degreesToRadians: Double { self * .pi / 180 }
    var radiansToDegrees: Double { self * 180 / .pi }
} 

