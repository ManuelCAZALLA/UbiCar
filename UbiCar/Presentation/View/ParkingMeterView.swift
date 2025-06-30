//
//  ParkimeterView.swift
//  UbiCar
//
//  Created by Manuel Cazalla Colmenero on 30/6/25.
//

import SwiftUI

struct ParkingMeterView: View {
    @StateObject private var viewModel = ParkingMeterViewModel()
    @State private var selectedMinutes: Int = 15
    @State private var preEndAlertMinutes: Int = 5
    let minuteOptions = [5, 10, 15, 30, 45, 60]
    let preEndOptions = [1, 3, 5, 10, 15]

    var body: some View {
        VStack(spacing: 30) {
            Text("🅿️ Parquímetro")
                .font(.largeTitle.bold())
                .padding(.top)

            if viewModel.hasActiveTimer {
                VStack(spacing: 12) {
                    Text("⏳ Tiempo restante")
                        .font(.headline)

                    Text(viewModel.timeString(from: viewModel.remainingTime))
                        .font(.system(size: 48, weight: .bold, design: .monospaced))
                        .foregroundColor(.blue)

                    Button(role: .destructive) {
                        viewModel.cancel()
                    } label: {
                        Label("Cancelar parquímetro", systemImage: "xmark.circle")
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.red.opacity(0.1))
                            .cornerRadius(10)
                    }
                }
                .padding()
            } else {
                VStack(spacing: 12) {
                    Text("⏱️ Establece el tiempo")
                        .font(.headline)

                    Picker("Minutos", selection: $selectedMinutes) {
                        ForEach(minuteOptions, id: \.self) { minute in
                            Text("\(minute) min").tag(minute)
                        }
                    }
                    .pickerStyle(WheelPickerStyle())
                    .frame(height: 120)

                    HStack {
                        Text("Avisar antes:")
                        Picker("Avisar antes", selection: $preEndAlertMinutes) {
                            ForEach(preEndOptions, id: \.self) { min in
                                Text("\(min) min").tag(min)
                            }
                        }
                        .pickerStyle(SegmentedPickerStyle())
                        .frame(width: 180)
                    }

                    Button {
                        viewModel.start(minutes: selectedMinutes, preEndAlert: preEndAlertMinutes)
                    } label: {
                        Text("Iniciar")
                            .bold()
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                }
                .padding()
            }
            Spacer()
        }
        .padding()
        .onAppear {
            viewModel.requestNotificationPermission()
        }
    }
}

#Preview {
    ParkingMeterView()
}
