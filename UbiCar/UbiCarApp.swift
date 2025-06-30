//
//  UbiCarApp.swift
//  UbiCar
//
//  Created by Manuel Cazalla Colmenero on 22/6/25.
//

import SwiftUI

@main
struct UbiCarApp: App {
    
    init() {
            UIView.appearance().overrideUserInterfaceStyle = .light
        }
    
    var body: some Scene {
        WindowGroup {
            RootView()
        }
    }
}
