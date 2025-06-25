import SwiftUI

struct MapGuideButton: View {
    let action: () -> Void
    var body: some View {
        Button(action: action) {
            Text("Ver mapa y guía por voz")
                .padding(.top, 8)
        }
    }
} 