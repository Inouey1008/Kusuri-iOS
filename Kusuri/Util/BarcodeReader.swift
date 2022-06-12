//
//  BarcodeReader.swift
//  Kusuri
//
//  Created by Yusuke Inoue on 2022/04/30.
//

import AVFoundation
import Vision
import RxSwift
import RxCocoa

class BarcodeReader: NSObject {
    let session: AVCaptureSession!
    let previewLayer: AVCaptureVideoPreviewLayer!
    
    var barcodeObservable: Driver<VNBarcodeObservation> {
        return relay.asDriver(onErrorDriveWith: .empty())
    }
    
    private let relay = PublishRelay<VNBarcodeObservation>()

    private func detect(barcode: VNBarcodeObservation) {
        relay.accept(barcode)
    }
    
    var sessionRunning: Driver<Bool> {
        return runnningRelay.asDriver(onErrorDriveWith: .empty())
    }
    private let runnningRelay = PublishRelay<Bool>()

    var observer: NSKeyValueObservation?
    
    init(previewLayer: AVCaptureVideoPreviewLayer) {
        self.session = AVCaptureSession()
        self.previewLayer = previewLayer
        super.init()
        
        observer = session.observe(\.isRunning, options: .new, changeHandler: { [weak self] _, change in
            guard let self = self, let newValue = change.newValue else {
                return
            }
            self.runnningRelay.accept(newValue)
        })
    }
    
    func setupCamera() {
        guard let device = AVCaptureDevice.default(AVCaptureDevice.DeviceType.builtInWideAngleCamera, for: .video, position: .back),
              let input = try? AVCaptureDeviceInput(device: device) else {
            return
        }
        let output = AVCaptureVideoDataOutput()
        output.videoSettings = [kCVPixelBufferPixelFormatTypeKey as String: Int(kCVPixelFormatType_32BGRA)]
        output.alwaysDiscardsLateVideoFrames = true
        output.setSampleBufferDelegate(self, queue: .global())
        startSession(input: input, output: output)
    }
    
    func startSession(input:  AVCaptureDeviceInput, output: AVCaptureVideoDataOutput) {
        if previewLayer.session == nil {
            previewLayer.session = self.session
            session.sessionPreset = .photo
        }
        if session.canAddInput(input) && session.canAddOutput(output) {
            session.addInput(input)
            session.addOutput(output)
        }
        if session.isRunning == false {
            session.startRunning()
        }
        session.startRunning()
    }
    
    func restartSession() {
        session.startRunning()
    }
    
    func quitSession() {
        session.stopRunning()
        for output in session.outputs {
            session.removeOutput(output as AVCaptureOutput)
        }
        for input in session.inputs {
            session.removeInput(input as AVCaptureInput)
        }
    }
}

extension BarcodeReader: AVCaptureVideoDataOutputSampleBufferDelegate {
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        guard let pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else {
            return
        }
        
        let barcodesRequest = VNDetectBarcodesRequest { [weak self] request, error in
            guard let self = self, let barcode = request.results?.first as? VNBarcodeObservation, error == nil else {
                return
            }
            self.detect(barcode: barcode)
        }
        barcodesRequest.revision = VNDetectBarcodesRequestRevision2
        
        do {
            let handler = VNSequenceRequestHandler()
            try handler.perform([barcodesRequest], on: pixelBuffer)
        } catch {
            print("Vision error: \(error.localizedDescription)")
        }
    }
}
