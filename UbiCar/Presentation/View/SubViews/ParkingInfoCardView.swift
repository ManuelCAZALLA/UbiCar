//
//  ParkingInfoCardView.swift
//  UbiCar
//
//  Created by Manuel Cazalla Colmenero on 29/6/25.
//

import SwiftUI

struct ParkingInfoCard: View {
    let parking: ParkingLocation
    let onDelete: () -> Void
    let onNavigate: () -> Void
    
    var body: some View {
        VStack(spacing: 14) {
            HStack {
                Image(systemName: "car.fill")
                    .foregroundColor(.blue)
                    .font(.title2)
                VStack(alignment: .leading, spacing: 4) {
                    Text("last_parking".localized)
                        .font(.headline)
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
                }
                Spacer()
            }
            
            HStack(spacing: 20) {
                Button(action: onDelete) {
                    Label("delete".localized, systemImage: "trash")
                        .foregroundColor(.red)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.red.opacity(0.1))
                        .cornerRadius(10)
                }
                
                Button(action: onNavigate) {
                    Label("back_to_car".localized, systemImage: "location.fill")
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(10)
                }
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(20)
        .shadow(color: Color.black.opacity(0.1), radius: 10, x: 0, y: 5)
    }
}

