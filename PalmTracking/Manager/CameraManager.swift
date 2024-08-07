//
//  CameraManager.swift
//  PalmTracking
//
//  Created by Anjar Harimurti on 01/08/24.
//

import Foundation
import AVFoundation
import Vision

class CameraManager: NSObject, AVCaptureVideoDataOutputSampleBufferDelegate {
    var session = AVCaptureSession()
    var videoOutput = AVCaptureVideoDataOutput()
    var handTrackingService = HandTrackingService()
    var onHandPointsDetected: (([VNRecognizedPoint]) -> Void)?
    
    override init() {
        super.init()
        setupCamera()
    }
    
    func setupCamera() {
        guard let device = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .front) else {
            print("Failed to get camera device")
            return
        }
        guard let input = try? AVCaptureDeviceInput(device: device) else {
            print("Failed to create camera input")
            return
        }
        
        session.beginConfiguration()
        if session.canAddInput(input) {
            session.addInput(input)
        } else {
            print("Failed to add camera input to session")
        }
        
        if session.canAddOutput(videoOutput) {
            session.addOutput(videoOutput)
            videoOutput.setSampleBufferDelegate(self, queue: DispatchQueue(label: "videoQueue"))
        } else {
            print("Failed to add video output to session")
        }
        
        session.commitConfiguration()
    }
    
    func startSession() {
        if !session.isRunning {
            session.startRunning()
            print("Camera session started")
        }
    }
    
    func stopSession() {
        if session.isRunning {
            session.stopRunning()
            print("Camera session stopped")
        }
    }
    
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        guard let pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else { return }
        handTrackingService.performHandTracking(on: pixelBuffer) { [weak self] points in
            self?.onHandPointsDetected?(points)
        }
    }
    
    func getPreviewLayer() -> AVCaptureVideoPreviewLayer {
        let previewLayer = AVCaptureVideoPreviewLayer(session: session)
        previewLayer.videoGravity = .resizeAspectFill
        return previewLayer
    }
}
