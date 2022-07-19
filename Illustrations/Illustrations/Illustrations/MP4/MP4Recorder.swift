//
//  MP4Recorder.swift
//  Code Examples
//
//  Created by Kyle Howells on 03/07/2022.
//


import UIKit
import AVFoundation
import CoreGraphics


// MARK: - MP4Recorder

/// Screen records and write the result to an MP4
class MP4Recorder: NSObject {
	
	private let videoExporter: MP4Exporter
	
	private lazy var displayLink: CADisplayLink = { [unowned self] in
		let displayLink = CADisplayLink(target: self, selector: #selector(self.update))
		displayLink.preferredFrameRateRange = CAFrameRateRange(minimum: 60, maximum: 60)
		return displayLink
	}()
	
	let renderFrame: ()->UIImage
	
	
	/// <#Description#>
	/// - Parameters:
	///   - videoSize: <#videoSize description#>
	///   - outputURL: <#outputURL description#>
	///   - renderFrame: <#renderFrame description#>
	init?(videoSize: CGSize, outputURL: URL, renderFrame: @escaping ()->UIImage) {
		guard let exporter = MP4Exporter(videoSize: videoSize, outputURL: outputURL) else { return nil }
		
		self.videoExporter = exporter
		
		self.renderFrame = renderFrame
		
		super.init()
		
		self.displayLink.add(to: .current, forMode: .common)
		
		guard self.videoExporter.addImage(image: renderFrame(), withPresentationTime: CMTime.zero) else { return nil }
	}
	
	
	// MARK: - Render Frame
	
	private var firstFrameTime:CFTimeInterval? = nil
	
	@objc private func update()
	{
		let timestamp = self.displayLink.timestamp
		
		if let firstFrameTime: CFTimeInterval = self.firstFrameTime {
			let image:UIImage = self.renderFrame()
			
			let timeDiff: CFTimeInterval = (timestamp - firstFrameTime)
			
			let presentationTime = CMTime(seconds: Double(timeDiff), preferredTimescale: 10000)
			
			if self.videoExporter.addImage(image: image, withPresentationTime: presentationTime) == false {
				print("ERROR: Failed to append frame")
			}
		}
		
		if self.firstFrameTime == nil && timestamp > 0 {
			self.firstFrameTime = timestamp
		}
	}
	
	
	// MARK: - Stop Video
	
	/// <#Description#>
	/// - Parameter completion: <#completion description#>
	func stopRecording(completion: @escaping ()->()) {
		self.displayLink.invalidate()
		
		self.videoExporter.stopRecording(completion: {
			print("Finished Screen Recording")
		})
	}
	
}
