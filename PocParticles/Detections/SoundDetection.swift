//
//  SoundDetection.swift
//  PocParticles
//
//  Created by Marcelo deAraújo on 14/08/25.
//


import Foundation
#if canImport(AVFoundation)
import AVFoundation
#endif
#if canImport(SoundAnalysis)
import SoundAnalysis
import CoreML
#endif



class SoundDetection: DetectionSource {
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

    init() {
        #if canImport(AVFoundation) && canImport(SoundAnalysis)
        fatalError("Use init(modelProvider:) on platforms with SoundAnalysis")
        #else
        // Non-Apple platforms or when SoundAnalysis is unavailable
        #endif
    }

    #if canImport(AVFoundation) && canImport(SoundAnalysis)
    init(modelProvider: SoundModelProvider) {
        self.modelProvider = modelProvider
    }
    #endif

    func start() async {
        #if canImport(AVFoundation) && canImport(SoundAnalysis)
        guard !isRunning else { return }
        isRunning = true
        
        let engine = AVAudioEngine()
        self.engine = engine
        let input = engine.inputNode
        let format = input.inputFormat(forBus: 0)
        self.inputFormat = format
        
        let analyzer = SNAudioStreamAnalyzer(format: format)
        self.analyzer = analyzer

        // Configure request with your Core ML sound classification model
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
        // Fallback demo: periodically emit a fake "rain" label when the mic would be active.
        Task.detached { [id] in
            while !Task.isCancelled {
                try? await Task.sleep(nanoseconds: 1_000_000_000)
                await EventBus.shared.post(DetectionEvent(source: id, label: "rain", confidence: 0.85))
            }
        }
        #endif
    }

    public func stop() async {
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
}

#if canImport(SoundAnalysis)
final class ResultsObserver: NSObject, SNResultsObserving {
    let sourceID: String
    init(sourceID: String) { self.sourceID = sourceID }
    func request(_ request: SNRequest, didProduce result: SNResult) {
        guard let res = result as? SNClassificationResult else { return }
        // take top classification only (you can map more if you want)
        guard let c = res.classifications.first else { return }
        let ev = DetectionEvent(source: sourceID, label: c.identifier, confidence: Double(c.confidence))
        Task { await EventBus.shared.post(ev) }
    }
    func request(_ request: SNRequest, didFailWithError error: Error) { }
    func requestDidComplete(_ request: SNRequest) { }
}
#endif

