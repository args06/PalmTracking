//
//  HandTrackingView.swift
//  PalmTracking
//
//  Created by Anjar Harimurti on 01/08/24.
//

import SwiftUI

struct HandTrackingView: View {
    @StateObject private var viewModel = HandTrackingViewModel()
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                CameraPreview(cameraManager: viewModel.cameraManager)
                    .edgesIgnoringSafeArea(.all)
                
                ForEach(viewModel.handPoints, id: \.self) { handPoint in
                    Circle()
                        .fill(Color.red)
                        .frame(width: 10, height: 10)
                        .position(handPoint)
                }
            }
        }
        .onDisappear {
            viewModel.stopCamera()
        }
    }
}

extension CGPoint: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(x)
        hasher.combine(y)
    }

    public static func == (lhs: CGPoint, rhs: CGPoint) -> Bool {
        return lhs.x == rhs.x && lhs.y == rhs.y
    }
}

#Preview {
    HandTrackingView()
}
