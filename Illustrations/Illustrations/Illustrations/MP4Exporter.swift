//
//  MP4Exporter.swift
//  Code Examples
//
//  Created by Kyle Howells on 03/07/2022.
//

import Foundation
import UIKit
import AVFoundation
import CoreGraphics


// MARK: - MP4Exporter

class MP4Exporter: NSObject {
	
	let videoSize:CGSize
	
	let assetWriter: AVAssetWriter
	let videoWriterInput: AVAssetWriterInput
	let pixelBufferAdaptor: AVAssetWriterInputPixelBufferAdaptor
	
	
	init?(videoSize: CGSize, outputURL: URL) {
		self.videoSize = videoSize
		
		guard let _assetWriter = try? AVAssetWriter(outputURL: outputURL, fileType: AVFileType.mp4) else {
			return nil
		}
		
		self.assetWriter = _assetWriter
		
		
		let avOutputSettings: [String: Any] = [
			AVVideoCodecKey: AVVideoCodecType.h264, // hevc
			AVVideoWidthKey: NSNumber(value: Float(videoSize.width)),
			AVVideoHeightKey: NSNumber(value: Float(videoSize.height))
		]
		
		self.videoWriterInput = AVAssetWriterInput(mediaType: AVMediaType.video, outputSettings: avOutputSettings)
		self.videoWriterInput.expectsMediaDataInRealTime = true
		self.assetWriter.add(self.videoWriterInput)
		
		let sourcePixelBufferAttributesDictionary = [
			kCVPixelBufferPixelFormatTypeKey as String: NSNumber(value: kCVPixelFormatType_32ARGB),
			kCVPixelBufferWidthKey as String: NSNumber(value: Float(videoSize.width)),
			kCVPixelBufferHeightKey as String: NSNumber(value: Float(videoSize.height))
		]
		
		self.pixelBufferAdaptor = AVAssetWriterInputPixelBufferAdaptor(
			assetWriterInput: self.videoWriterInput,
			sourcePixelBufferAttributes: sourcePixelBufferAttributesDictionary
		)
		
		super.init()
		
		
		self.assetWriter.startWriting()
		self.assetWriter.startSession(atSourceTime: CMTime.zero)
	}
	
	
	// MARK: - Insert Image
	
	/// Appends an image, returning true if successful
	func addImage(image: UIImage, withPresentationTime presentationTime: CMTime, waitIfNeeded: Bool = false) -> Bool {
		guard let pixelBufferPool = self.pixelBufferAdaptor.pixelBufferPool else {
			print("ERROR: pixelBufferPool is nil ")
			return false
		}
		
		guard let pixelBuffer = self.pixelBufferFromImage(
			image: image,
			pixelBufferPool: pixelBufferPool,
			size: self.videoSize
		)
		else {
			print("ERROR: Failed to generate pixelBuffer")
			return false
		}
		
		print("isReadyForMoreMediaData: \(self.videoWriterInput.isReadyForMoreMediaData)")
		
		if waitIfNeeded {
			// Wait until the previous frame has successfully written to continue
			while self.videoWriterInput.isReadyForMoreMediaData == false { }
		}
		
		return self.pixelBufferAdaptor.append(pixelBuffer, withPresentationTime: presentationTime)
	}
	
	
	
	// MARK: - Stop Video
	
	func stopRecording(completion: @escaping ()->()) {
		// Stop
		self.videoWriterInput.markAsFinished()
		
		self.assetWriter.finishWriting(completionHandler: {
			completion()
			print("Finished writing video file")
		})
	}
	
	
	
	
	// MARK: - Internal Helper
	
	/// - Converts a UIImage to a CVPixelBuffer, returning nil on failure
	/// - Parameters:
	///   - image: <#image description#>
	///   - pixelBufferPool: <#pixelBufferPool description#>
	///   - size: <#size description#>
	/// - Returns: <#description#>
	private func pixelBufferFromImage(image: UIImage, pixelBufferPool: CVPixelBufferPool, size: CGSize) -> CVPixelBuffer?
	{
		guard let cgImage = image.cgImage else { return nil }
		
		var pixelBufferOut: CVPixelBuffer?
		let status = CVPixelBufferPoolCreatePixelBuffer(kCFAllocatorDefault, pixelBufferPool, &pixelBufferOut)
		
		guard status == kCVReturnSuccess else {
			print("ERROR: CVPixelBufferPoolCreatePixelBuffer() failed")
			return nil
		}
		
		guard let pixelBuffer = pixelBufferOut else {
			print("ERROR: pixelBufferOut not populated as expected")
			return nil
		}
		
		CVPixelBufferLockBaseAddress(pixelBuffer, CVPixelBufferLockFlags(rawValue: CVOptionFlags(0)))
		
		let data = CVPixelBufferGetBaseAddress(pixelBuffer)
		let rgbColorSpace = CGColorSpaceCreateDeviceRGB()
		
		guard let context = CGContext(
			data: data,
			width: Int(size.width), height: Int(size.height),
			bitsPerComponent: 8,
			bytesPerRow: CVPixelBufferGetBytesPerRow(pixelBuffer),
			space: rgbColorSpace,
			bitmapInfo: CGImageAlphaInfo.premultipliedFirst.rawValue
		)
		else {
			print("ERROR: unable to create pixel CGContext")
			return nil
		}
		
		context.clear(CGRect(x: 0, y: 0, width: size.width, height: size.height))
		
		let horizontalRatio = size.width / CGFloat(cgImage.width)
		let verticalRatio = size.height / CGFloat(cgImage.height)
		let aspectRatio = max(horizontalRatio, verticalRatio) // ScaleAspectFill
		//let aspectRatio = min(horizontalRatio, verticalRatio) // ScaleAspectFit
		let newSize = CGSize(
			width: CGFloat(cgImage.width) * aspectRatio,
			height: CGFloat(cgImage.height) * aspectRatio
		)
		
		let x = (newSize.width < size.width) ? (size.width - newSize.width) / 2 : -(newSize.width-size.width) / 2
		let y = (newSize.height < size.height) ? (size.height - newSize.height) / 2 : -(newSize.height-size.height) / 2
		
		context.draw(cgImage, in: CGRect(x:x, y:y, width:newSize.width, height:newSize.height))
		CVPixelBufferUnlockBaseAddress(pixelBuffer, CVPixelBufferLockFlags(rawValue: CVOptionFlags(0)))
		
		return pixelBuffer
	}
	
}
