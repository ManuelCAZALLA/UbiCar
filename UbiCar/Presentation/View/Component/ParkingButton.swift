import SwiftUI

struct ParkingButton: View {
    let enabled: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text("Aparcado aquí")
                .font(.title2)
                .padding()
                .frame(maxWidth: .infinity)
                .background(enabled ? Color.blue : Color.gray)
                .foregroundColor(.white)
                .cornerRadius(12)
        }
        .disabled(!enabled)
    }
} 