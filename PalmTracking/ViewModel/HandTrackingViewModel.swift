//
//  HandTrackingViewModel.swift
//  PalmTracking
//
//  Created by Anjar Harimurti on 01/08/24.
//

import Foundation
import SwiftUI

class HandTrackingViewModel: ObservableObject {
    @Published var handPoints: [CGPoint] = []
    let cameraManager = CameraManager()
    
    init() {
        cameraManager.onHandPointsDetected = { [weak self] points in
            guard let self = self else { return }
            DispatchQueue.main.async {
                let frameSize = UIScreen.main.bounds
                let cgPoints = VisionHelper.convertPointsToCGPoint(points: points, frameSize: frameSize)
                self.handPoints = cgPoints
            }
        }
        cameraManager.startSession()
    }
    
    func stopCamera() {
        cameraManager.stopSession()
    }
}

