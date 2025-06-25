import SwiftUI

struct CompassButton: View {
    let action: () -> Void
    var body: some View {
        Button(action: action) {
            Text("Brújula / Flecha")
                .padding(.top, 8)
        }
    }
} 