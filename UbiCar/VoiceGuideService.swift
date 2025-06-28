import Foundation
import AVFoundation

class VoiceGuideService {
    static let shared = VoiceGuideService()
    private let synthesizer = AVSpeechSynthesizer()

    func speak(_ text: String) {
        let utterance = AVSpeechUtterance(string: text)
        utterance.voice = AVSpeechSynthesisVoice(language: "es-ES")
        synthesizer.speak(utterance)
    }
} 