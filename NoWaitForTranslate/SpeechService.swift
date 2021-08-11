//
//  SpeakService.swift
//  NoWaitForTranslate
//
//  Created by Ivan Ermolaev on 11/08/2021.
//

import AVFoundation

protocol SpeechService {
    func say(_ text: String)
}

class NativeSpeechService: SpeechService {
    private let synthesizer = AVSpeechSynthesizer()
    
    func say(_ text: String) {
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category.playAndRecord, mode: .default, options: .defaultToSpeaker)
            try AVAudioSession.sharedInstance().setActive(true, options: .notifyOthersOnDeactivation)
        } catch {
            print("audioSession properties weren't set because of an error.")
        }

        
        let utterance = AVSpeechUtterance(string: text)
        utterance.voice = AVSpeechSynthesisVoice(language: "en-GB") // setting
        utterance.rate = 0.4 // setting
        
        synthesizer.speak(utterance)
        
        do {
            disableAVSession()
        }
    }
    
    private func disableAVSession() {
        do {
            try AVAudioSession.sharedInstance().setActive(false, options: .notifyOthersOnDeactivation)
        } catch {
            print("audioSession properties weren't disable.")
        }
    }

}
