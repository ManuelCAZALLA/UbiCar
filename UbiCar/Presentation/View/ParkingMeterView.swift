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
        ZStack {
            Color.background.ignoresSafeArea()
            VStack(spacing: 32) {
                Text("🅿️ Parquímetro")
                    .font(.largeTitle.bold())
                    .foregroundColor(.appPrimary)
                    .padding(.top)

                if viewModel.hasActiveTimer {
                    VStack(spacing: 24) {
                        Text("Tiempo restante")
                            .font(.headline)
                            .foregroundColor(.appPrimary)
                        ZStack {
                            Circle()
                                .stroke(Color.appPrimary.opacity(0.2), lineWidth: 8)
                                .frame(width: 120, height: 120)
                            Text(viewModel.timeString(from: viewModel.remainingTime))
                                .font(.system(size: 44, weight: .bold, design: .monospaced))
                                .foregroundColor(.accentColor)
                        }
                        Button(role: .destructive) {
                            viewModel.cancel()
                        } label: {
                            Label("Cancelar parquímetro", systemImage: "xmark.circle")
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(Color.error.opacity(0.15))
                                .foregroundColor(.error)
                                .cornerRadius(12)
                        }
                    }
                    .padding()
                    .background(Color.white)
                    .cornerRadius(20)
                    .shadow(color: Color.appPrimary.opacity(0.08), radius: 8, x: 0, y: 4)
                    .padding(.horizontal)
                    Spacer()
                } else {
                    VStack(spacing: 28) {
                        VStack(spacing: 12) {
                            Text("Duración del parquímetro")
                                .font(.headline)
                                .foregroundColor(.appPrimary)
                            Picker("Minutos", selection: $selectedMinutes) {
                                ForEach(minuteOptions, id: \ .self) { minute in
                                    Text("\(minute) min").tag(minute)
                                }
                            }
                            .pickerStyle(WheelPickerStyle())
                            .frame(height: 100)
                            .background(RoundedRectangle(cornerRadius: 12).fill(Color.white.opacity(0.95)))
                            .shadow(radius: 2)
                        }
                        .padding()
                        .background(Color.white)
                        .cornerRadius(16)
                        .shadow(color: Color.appPrimary.opacity(0.06), radius: 6, x: 0, y: 2)
                        VStack(spacing: 12) {
                            Text("Aviso antes de finalizar")
                                .font(.headline)
                                .foregroundColor(.appPrimary)
                            Picker("Avisar antes", selection: $preEndAlertMinutes) {
                                ForEach(preEndOptions, id: \ .self) { min in
                                    Text("\(min) min").tag(min)
                                }
                            }
                            .pickerStyle(SegmentedPickerStyle())
                            .frame(width: 220)
                        }
                        .padding()
                        .background(Color.white)
                        .cornerRadius(16)
                        .shadow(color: Color.appPrimary.opacity(0.06), radius: 6, x: 0, y: 2)
                        Button {
                            viewModel.start(minutes: selectedMinutes, preEndAlert: preEndAlertMinutes)
                        } label: {
                            Text("Iniciar")
                                .bold()
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.accentColor)
                                .foregroundColor(.white)
                                .cornerRadius(14)
                                .shadow(radius: 4)
                        }
                        .padding(.top, 8)
                    }
                    .padding(.horizontal)
                }
                Spacer()
            }
            .padding(.top, 8)
            .onAppear {
                viewModel.requestNotificationPermission()
            }
        }
    }
}

#Preview {
    ParkingMeterView()
}
