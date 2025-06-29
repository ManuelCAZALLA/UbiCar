import Foundation
import AVFoundation

class VoiceGuideService {
    static let shared = VoiceGuideService()
    private let synthesizer = AVSpeechSynthesizer()

    private init() {
        configureAudioSession()
    }

    private func configureAudioSession() {
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
            try AVAudioSession.sharedInstance().setActive(true, options: .notifyOthersOnDeactivation)
        } catch {
            print("Error al configurar AVAudioSession: \(error)")
        }
    }

    func speak(_ text: String) {
        if synthesizer.isSpeaking {
            synthesizer.stopSpeaking(at: .immediate)
        }

        let utterance = AVSpeechUtterance(string: text)
        utterance.voice = AVSpeechSynthesisVoice(language: "es-ES")
        utterance.rate = 0.5  // Velocidad moderada
        utterance.volume = 1.0 // Volumen máximo

        synthesizer.speak(utterance)
    }
}
