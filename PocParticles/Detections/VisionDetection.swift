//
//  VisionDetection.swift
//  PocParticles
//
//  Created by Marcelo deAraújo on 14/08/25.
//


import Foundation
#if canImport(AVFoundation)
@preconcurrency import AVFoundation
#endif
#if canImport(Vision)
import Vision
import CoreML
#endif


class VisionDetection: NSObject, DetectionSource {
    let id: String = "vision"
    #if canImport(AVFoundation) && canImport(Vision)
    let session = AVCaptureSession()
    let output = AVCaptureVideoDataOutput()
    let queue = DispatchQueue(label: "VisionDetection.queue")
    var requests: [VNRequest] = []
    var isRunning = false
    #endif

    override init() { super.init() }

    #if canImport(AVFoundation) && canImport(Vision)
    convenience init(objects modelProvider: VisionModelProvider) {
        self.init()
        let request = VNCoreMLRequest(model: modelProvider.vnModel) { req, _ in
            guard let obs = req.results as? [VNRecognizedObjectObservation] else { return }
            for o in obs {
                let best = o.labels.first
                let label = best?.identifier ?? "object"
                let conf = Double(best?.confidence ?? 0)
                Task { await EventBus.shared.post(.init(source: "vision", label: label, confidence: conf)) }
            }
        }
        request.imageCropAndScaleOption = .scaleFill
        self.requests = [request]
    }
    #endif

    func start() async {
        #if canImport(AVFoundation) && canImport(Vision)
        guard !isRunning else { return }
        isRunning = true
        session.beginConfiguration()
        session.sessionPreset = .high
        guard let device = AVCaptureDevice.default(for: .video), let input = try? AVCaptureDeviceInput(device: device) else { return }
        if session.canAddInput(input) { session.addInput(input) }
        output.alwaysDiscardsLateVideoFrames = true
        output.setSampleBufferDelegate(self, queue: queue)
        if session.canAddOutput(output) { session.addOutput(output) }
        session.commitConfiguration()
        session.startRunning()
        #else
        // Stub: periodic brightness tag
        Task.detached { [id] in
            while !Task.isCancelled {
                try? await Task.sleep(nanoseconds: 2_000_000_000)
                await EventBus.shared.post(DetectionEvent(source: id, label: "bright", confidence: 0.9))
            }
        }
        #endif
    }

    func stop() async {
        #if canImport(AVFoundation) && canImport(Vision)
        guard isRunning else { return }
        session.stopRunning()
        isRunning = false
        #endif
    }
}

#if canImport(AVFoundation) && canImport(Vision)
extension VisionDetection: AVCaptureVideoDataOutputSampleBufferDelegate {
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        var reqs = self.requests
        if reqs.isEmpty {
            // Fallback brightness heuristic → "bright" label
            if let buf = CMSampleBufferGetImageBuffer(sampleBuffer) {
                CVPixelBufferLockBaseAddress(buf, .readOnly)
                let width = CVPixelBufferGetWidth(buf)
                let height = CVPixelBufferGetHeight(buf)
                let base = CVPixelBufferGetBaseAddress(buf)!
                let data = base.assumingMemoryBound(to: UInt8.self)
                // sample a few pixels for quick luminance estimation
                let stride = max(1, (width * height) / 50_000)
                var sum: Double = 0; var count = 0
                for i in stride(from: 0, to: width*height*4, by: stride*4) { // assume BGRA
                    let b = Double(data[i])
                    let g = Double(data[i+1])
                    let r = Double(data[i+2])
                    let y = 0.2126*r + 0.7152*g + 0.0722*b
                    sum += y; count += 1
                }
                CVPixelBufferUnlockBaseAddress(buf, .readOnly)
                let avg = sum / Double(max(count,1)) / 255.0
                if avg > 0.7 {
                    Task { await EventBus.shared.post(.init(source: "vision", label: "bright", confidence: min(1.0, avg))) }
                }
            }
            return
        }
        
        let handler = VNImageRequestHandler(cmSampleBuffer: sampleBuffer, orientation: .up, options: [:])
        do {
            try handler.perform(reqs)
        } catch {
            print("VisionDetection error: \(error)")
        }
    }
}
#endif



