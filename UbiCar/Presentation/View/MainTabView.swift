//
//  MainTabView.swift
//  UbiCar
//
//  Created by Manuel Cazalla Colmenero on 30/6/25.
//

import SwiftUI

struct MainTabView: View {
    
    var body: some View {
        TabView {
            ContentView()
                .tabItem {
                    Label("Inicio", systemImage: "car.fill")
                }

            ParkingMeterView()
                .tabItem {
                    Label("Parquímetro", systemImage: "timer")
                }

            SettingView()
                .tabItem {
                    Label("Opciones", systemImage: "gearshape.fill")
                }
        }
    }
}

#Preview {
    MainTabView()
}
