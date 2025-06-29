import SwiftUI

struct LaunchView: View {
    @StateObject private var viewModel = LaunchViewModel()
    
    var body: some View {
        Group {
            if viewModel.isAuthorized {
                ContentView()
            } else {
                VStack(spacing: 32) {
                    Image("UbiCar")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 180, height: 180)
                    Text("welcome_to_ubicar".localized)
                        .font(.largeTitle)
                        .bold()
                    Button("allow_location".localized) {
                        viewModel.requestAuthorization()
                    }
                    .font(.title2)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(12)
                }
            }
        }
        .animation(.easeInOut, value: viewModel.isAuthorized)
    }
}

#Preview {
  LaunchView()
}
