//
//  SoundDetection.swift
//  PocParticles
//

import Foundation
#if canImport(AVFoundation)
import AVFoundation
#endif
#if canImport(SoundAnalysis)
import SoundAnalysis
import CoreML
#endif

class SoundDetection: DetectionSource, @unchecked Sendable {
    let id: String = "sound"
    
    #if canImport(AVFoundation) && canImport(SoundAnalysis)
    var engine: AVAudioEngine?
    var analyzer: SNAudioStreamAnalyzer?
    var inputFormat: AVAudioFormat?
    let queue = DispatchQueue(label: "SoundDetection.queue")
    var request: SNClassifySoundRequest?
    var observer: ResultsObserver?
    var isRunning = false
    let modelProvider: SoundModelProvider
    #endif

    // Universal initializer
    init(modelProvider: SoundModelProvider? = nil) {
        #if canImport(AVFoundation) && canImport(SoundAnalysis)
        guard let modelProvider = modelProvider else {
            fatalError("modelProvider is required on platforms with SoundAnalysis")
        }
        self.modelProvider = modelProvider
        #else
        // fallback para visionOS ou plataformas sem SoundAnalysis
        #endif
    }

    
    func start() async {
        #if canImport(AVFoundation) && canImport(SoundAnalysis)
        guard !isRunning else { return }

        // Solicita permissão de microfone
        let granted = await requestMicrophoneAccess()
        guard granted else {
            print("Microphone access denied")
            return
        }

        isRunning = true
        
        // Configura AVAudioEngine
        let engine = AVAudioEngine()
        self.engine = engine
        let input = engine.inputNode
        let format = input.inputFormat(forBus: 0)
        
        guard format.channelCount > 0 && format.sampleRate > 0 else {
            print("Audio format invalid: channelCount or sampleRate is zero")
            return
        }
        
        self.inputFormat = format
        let analyzer = SNAudioStreamAnalyzer(format: format)
        self.analyzer = analyzer

        let request = try? SNClassifySoundRequest(mlModel: modelProvider.mlModel)
        self.request = request

        let observer = ResultsObserver(sourceID: id)
        self.observer = observer
        if let req = request { try? analyzer.add(req, withObserver: observer) }

        input.removeTap(onBus: 0)
        input.installTap(onBus: 0, bufferSize: 8192, format: format) { [weak self] buffer, time in
            guard let self else { return }
            self.queue.async { self.analyzer?.analyze(buffer, atAudioFramePosition: time.sampleTime) }
        }
        try? engine.start()
        #else
        // fallback demo: envia evento falso periodicamente
        Task.detached { [id] in
            while !Task.isCancelled {
                try? await Task.sleep(nanoseconds: 1_000_000_000)
                await EventBus.shared.post(DetectionEvent(source: id, label: "rain", confidence: 0.85))
            }
        }
        #endif
    }


    func stop() async {
        #if canImport(AVFoundation) && canImport(SoundAnalysis)
        guard isRunning else { return }
        engine?.stop()
        engine?.inputNode.removeTap(onBus: 0)
        analyzer?.removeAllRequests()
        analyzer = nil
        request = nil
        observer = nil
        engine = nil
        isRunning = false
        #endif
    }
    
    func requestMicrophoneAccess() async -> Bool {
        #if os(visionOS)
        await withCheckedContinuation { continuation in
            AVAudioApplication.requestRecordPermission { granted in
                continuation.resume(returning: granted)
            }
        }
        #else
        await withCheckedContinuation { continuation in
            AVAudioSession.sharedInstance().requestRecordPermission { granted in
                continuation.resume(returning: granted)
            }
        }
        #endif
    }
}

#if canImport(SoundAnalysis)
final class ResultsObserver: NSObject, SNResultsObserving {
    let sourceID: String
    
    init(sourceID: String) { self.sourceID = sourceID }
    
    func request(_ request: SNRequest, didProduce result: SNResult) {
        guard let res = result as? SNClassificationResult,
              let classification = res.classifications.first else { return }
        
        let event = DetectionEvent(
            source: sourceID,
            label: classification.identifier,
            confidence: Double(classification.confidence)
        )
        
        Task { await EventBus.shared.post(event) }
    }
    func request(_ request: SNRequest, didFailWithError error: Error) { }
    func requestDidComplete(_ request: SNRequest) { }
}
#endif

