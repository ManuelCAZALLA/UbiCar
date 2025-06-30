//
//  RootView.swift
//  UbiCar
//
//  Created by Manuel Cazalla Colmenero on 30/6/25.
//

import SwiftUI

struct RootView: View {
    @StateObject private var launchVM = LaunchViewModel()
    
    var body: some View {
        Group {
            if launchVM.isAuthorized {
                MainTabView()
            } else {
                LaunchView(viewModel: launchVM)
            }
        }
        .animation(.easeInOut, value: launchVM.isAuthorized)
    }
}


#Preview {
    RootView()
}
