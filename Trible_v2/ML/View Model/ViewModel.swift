//
//  ViewModel.swift
//  Nano Challenge 1
//
//  Created by Michael Chrisandy on 28/04/24.
//

import SwiftUI


class ViewModel: ObservableObject {
    
    @Published var actionLabel : String = "Menangis"
    @Published var confidenceLabel: String = "No Confidence :("
    var actionFrameCounts = [String: Int]()
    
    var isCreated = false
    var videoProcessingChain = VideoProcessingChain()
    var videoCapture = VideoCapture()
    
    func createNew() {
        if isCreated == false {
            isCreated = true
            videoProcessingChain.delegate = self
            videoCapture.delegate = self
            videoCapture.updateDeviceOrientation()
        }
        
    }
}

extension ViewModel: VideoProcessingChainDelegate {
    func videoProcessingChain(_ chain: VideoProcessingChain, didDetect poses: [Pose]?, in frame: CGImage) {
        
    }
    
    func videoProcessingChain(_ chain: VideoProcessingChain, didPredict actionPrediction: ActionPrediction, for frameCount: Int) {
        if actionPrediction.isModelLabel {
            // Update the total number of frames for this action.
            addFrameCount(frameCount, to: actionPrediction.label)
        }
        
        updateUILabelsWithPrediction(actionPrediction)
    }
}

extension ViewModel: VideoCaptureDelegate {
    func videoCapture(_ videoCapture: VideoCapture, didCreate framePublisher: FramePublisher) {
        updateUILabelsWithPrediction(.startingPrediction)
        
        videoProcessingChain.upstreamFramePublisher = framePublisher
    }
    
    
}

extension ViewModel {
    /// Add the incremental duration to an action's total time.
    /// - Parameters:
    ///   - actionLabel: The name of the action.
    ///   - duration: The incremental duration of the action.
    private func addFrameCount(_ frameCount: Int, to actionLabel: String) {
        // Add the new duration to the current total, if it exists.
        let totalFrames = (actionFrameCounts[actionLabel] ?? 0) + frameCount
        
        // Assign the new total frame count for this action.
        actionFrameCounts[actionLabel] = totalFrames
    }
    
    /// Updates the user interface's labels with the prediction and its
    /// confidence.
    /// - Parameters:
    ///   - label: The prediction label.
    ///   - confidence: The prediction's confidence value.
    private func updateUILabelsWithPrediction(_ prediction: ActionPrediction) {
        actionLabel = prediction.label
        //        // Update the UI's prediction label on the main thread.
        //        DispatchQueue.main.async { self.actionLabel.text = prediction.label }
        //
        //        // Update the UI's confidence label on the main thread.
        let confidenceString = prediction.confidenceString ?? "Observing..."
        confidenceLabel = confidenceString
    }
    
    /// Draws poses as wireframes on top of a frame, and updates the user
    /// interface with the final image.
    /// - Parameters:
    ///   - poses: An array of human body poses.
    ///   - frame: An image.
    /// - Tag: drawPoses
    private func drawPoses(_ poses: [Pose]?, onto frame: CGImage) {
        // Create a default render format at a scale of 1:1.
        let renderFormat = UIGraphicsImageRendererFormat()
        renderFormat.scale = 1.0
        
        // Create a renderer with the same size as the frame.
        let frameSize = CGSize(width: frame.width, height: frame.height)
        let poseRenderer = UIGraphicsImageRenderer(size: frameSize,
                                                   format: renderFormat)
        
        // Draw the frame first and then draw pose wireframes on top of it.
        let frameWithPosesRendering = poseRenderer.image { rendererContext in
            // The`UIGraphicsImageRenderer` instance flips the Y-Axis presuming
            // we're drawing with UIKit's coordinate system and orientation.
            let cgContext = rendererContext.cgContext
            
            // Get the inverse of the current transform matrix (CTM).
            let inverse = cgContext.ctm.inverted()
            
            // Restore the Y-Axis by multiplying the CTM by its inverse to reset
            // the context's transform matrix to the identity.
            cgContext.concatenate(inverse)
            
            // Draw the camera image first as the background.
            let imageRectangle = CGRect(origin: .zero, size: frameSize)
            cgContext.draw(frame, in: imageRectangle)
            
            // Create a transform that converts the poses' normalized point
            // coordinates `[0.0, 1.0]` to properly fit the frame's size.
            let pointTransform = CGAffineTransform(scaleX: frameSize.width,
                                                   y: frameSize.height)
            
            guard let poses = poses else { return }
            
            // Draw all the poses Vision found in the frame.
            for pose in poses {
                // Draw each pose as a wireframe at the scale of the image.
                pose.drawWireframeToContext(cgContext, applying: pointTransform)
            }
        }
        
        // Update the UI's full-screen image view on the main thread.
        //        DispatchQueue.main.async { self.imageView.image = frameWithPosesRendering }
    }
}
