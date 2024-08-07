//
//  VisionHelper.swift
//  PalmTracking
//
//  Created by Anjar Harimurti on 01/08/24.
//

import Foundation
import Vision

class VisionHelper {
    static func convertPointsToCGPoint(points: [VNRecognizedPoint], frameSize: CGRect) -> [CGPoint] {
        return points.map { point in
            let x = (1 - point.location.y) * frameSize.width
            let y = point.location.x * frameSize.height
            return CGPoint(x: x, y: y)
        }
    }
}
