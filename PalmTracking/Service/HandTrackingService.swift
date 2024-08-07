//
//  HandTrackingService.swift
//  PalmTracking
//
//  Created by Anjar Harimurti on 01/08/24.
//

import Foundation
import Vision

class HandTrackingService {
    private let handPoseRequest = VNDetectHumanHandPoseRequest()
    private let bodyPoseRequest = VNDetectHumanBodyPoseRequest()

    func performHandTracking(on pixelBuffer: CVPixelBuffer, completion: @escaping ([VNRecognizedPoint]) -> Void) {
        let handler = VNImageRequestHandler(cvPixelBuffer: pixelBuffer, options: [:])
        
        do {
            try handler.perform([handPoseRequest])
            
            guard let observations = handPoseRequest.results, !observations.isEmpty else {
                completion([])
                return
            }
            
            var handPoints: [VNRecognizedPoint] = []
            
            for observation in observations {
                let allPoints = try observation.recognizedPoints(.all)
                handPoints.append(contentsOf: allPoints.values)
            }
            
            completion(handPoints)
        } catch {
            print("Hand tracking error: \(error)")
            completion([])
        }
        
        do {
            try handler.perform([bodyPoseRequest])
            
            guard let observations = bodyPoseRequest.results, !observations.isEmpty else {
                completion([])
                return
            }
            
            var handPoints: [VNRecognizedPoint] = []
            
            for observation in observations {
                let allPoints = try observation.recognizedPoints(.torso)
                handPoints.append(contentsOf: allPoints.values)
            }
            
            completion(handPoints)
        } catch {
            print("Hand tracking error: \(error)")
            completion([])
        }
    }
}
