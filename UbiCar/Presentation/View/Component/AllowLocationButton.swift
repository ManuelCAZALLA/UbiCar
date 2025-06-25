import SwiftUI

struct AllowLocationButton: View {
    let action: () -> Void
    var body: some View {
        Button(action: action) {
            Text("Permitir ubicación")
                .font(.title2)
                .padding()
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(12)
        }
    }
} 