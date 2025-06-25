import SwiftUI

struct DeleteButton: View {
    let action: () -> Void
    var body: some View {
        Button(action: action) {
            Text("Borrar ubicación")
                .foregroundColor(.red)
        }
    }
} 