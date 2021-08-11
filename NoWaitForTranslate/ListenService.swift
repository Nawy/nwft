//
//  ListenService.swift
//  NoWaitForTranslate
//
//  Created by Ivan Ermolaev on 09/08/2021.
//

import Foundation
import SwiftUI
import Speech


protocol ListenService {
    
    func listen(completion: @escaping (String?, Bool) -> Void)
    func stop()
}

class NativeListenService: ListenService {
    
    @State public var isRecording = false
    
    private var audioEngine: AVAudioEngine!
    private var inputNode: AVAudioInputNode!
    private var audioSession: AVAudioSession!
    
    private var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    
    func checkPermissions() {
        SFSpeechRecognizer.requestAuthorization {
            (authStatus) in
            DispatchQueue.main.async {
                switch authStatus {
                case .authorized: break
                default:
                    print("Speech recognition is not available")
                }
            }
        }
    }
    
    func listen(completion: @escaping (String?, Bool) -> Void) {
        guard let recognizer = SFSpeechRecognizer(), recognizer.isAvailable else {
            print("Can't create speech recognizer")
            return
        }
        
        recognitionRequest = SFSpeechAudioBufferRecognitionRequest()
        recognitionRequest?.shouldReportPartialResults = true
        
        recognizer.recognitionTask(with: recognitionRequest!) { (result, error) in
            guard error == nil else {
                print("Can't do recognition task, \(error!.localizedDescription)")
                return
            }
            guard let result = result else {
                return
            }
//            if result.isFinal {
//                completion(result.bestTranscription.formattedString)
//            }
            completion(result.bestTranscription.formattedString, result.isFinal)
        }
        
        // setup audio engine
        self.audioEngine = AVAudioEngine()
        self.inputNode = self.audioEngine.inputNode
        let recordingFormat = inputNode.outputFormat(forBus: 0)
        inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { (buffer, _) in
            self.recognitionRequest?.append(buffer)
        }
        
        audioEngine.prepare()
        do {
            audioSession = AVAudioSession.sharedInstance()
            try audioSession.setCategory(.record, mode: .spokenAudio, options: .duckOthers)
            try audioSession.setActive(true, options: .notifyOthersOnDeactivation)
            try audioEngine.start()
            self.isRecording = true
        } catch {
            print(error)
        }
    }
    
    func stop() {
        if let notNilRequest = recognitionRequest {
            notNilRequest.endAudio()
            self.recognitionRequest = nil
        } else {
            return
        }
        
        audioEngine.stop()
        inputNode.removeTap(onBus: 0)
        
        do {
            if let notNilAudioSession = audioSession {
                try notNilAudioSession.setActive(false)
                audioSession = nil
            }
        } catch {
            print("Failed to stop audio recognition")
        }
        self.isRecording = false
    }
}
