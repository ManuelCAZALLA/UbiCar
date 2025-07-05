import SwiftUI

struct ParkingInfoCard: View {
    let parking: ParkingLocation
    let onDelete: () -> Void
    let onNavigate: () -> Void
    let note: String?
    
    var body: some View {
        ZStack(alignment: .topTrailing) {
            VStack(spacing: 18) {
                HStack(alignment: .top, spacing: 14) {
                    ZStack {
                        Circle()
                            .fill(Color.appPrimary.opacity(0.15))
                            .frame(width: 48, height: 48)
                        Image(systemName: "car.fill")
                            .foregroundColor(.appPrimary)
                            .font(.title2)
                    }
                    VStack(alignment: .leading, spacing: 4) {
                        Text("last_parking".localized)
                            .font(.headline)
                            .foregroundColor(.appPrimary)
                        if let name = parking.placeName {
                            Text(name)
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        } else {
                            Text("coordinates_format".localized(with: parking.latitude, parking.longitude))
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                        Text("\("date".localized): \(parking.date.formatted(date: .abbreviated, time: .shortened))")
                            .font(.caption)
                            .foregroundColor(.gray)
                        if let note = note, !note.isEmpty {
                            Divider()
                            Text("Nota: \(note)")
                                .font(.body)
                                .foregroundColor(.primary)
                                .padding(.top, 4)
                        }
                    }
                    Spacer()
                }
                
                HStack(spacing: 20) {
                    Button(action: onDelete) {
                        Label("delete".localized, systemImage: "trash")
                            .foregroundColor(.error)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.error.opacity(0.12))
                            .cornerRadius(10)
                    }
                    
                    Button(action: onNavigate) {
                        Label("back_to_car".localized, systemImage: "location.fill")
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.appPrimary)
                            .cornerRadius(10)
                            .shadow(radius: 2)
                    }
                }
            }
            .padding()
            .background(Color.white)
            .cornerRadius(22)
            .shadow(color: Color.appPrimary.opacity(0.10), radius: 12, x: 0, y: 6)
            
            // Botón de compartir en la esquina superior derecha
            ShareLink(item: shareText) {
                Image(systemName: "square.and.arrow.up")
                    .font(.title2)
                    .foregroundColor(.appPrimary)
                    .padding(12)
            }
            .padding([.top, .trailing], 8)
        }
    }
    
    private var shareText: String {
        let lat = parking.latitude
        let lon = parking.longitude
        let appleMaps = "https://maps.apple.com/?ll=\(lat),\(lon)"
        let googleMaps = "https://www.google.com/maps?q=\(lat),\(lon)"
        return String(format: NSLocalizedString("share_parking_text", comment: ""), appleMaps, googleMaps)
    }
} 
