import UIKit
import AVFoundation
import CoreGraphics


// MARK: - MP4Recorder

class MP4Recorder: NSObject {
	
	let videoSize:CGSize
	
	let assetWriter: AVAssetWriter
	let videoWriterInput: AVAssetWriterInput
	let pixelBufferAdaptor: AVAssetWriterInputPixelBufferAdaptor
	
	var displayLink: CADisplayLink!
	
	let renderFrame: ()->UIImage
	
	
	init?(videoSize:CGSize, outputURL:URL, renderFrame: @escaping ()->UIImage) {
		self.videoSize = videoSize
		
		self.renderFrame = renderFrame
		
		guard let _assetWriter = try? AVAssetWriter(outputURL: outputURL, fileType: AVFileType.mp4) else {
			return nil
		}
		
		self.assetWriter = _assetWriter
		
		
		let avOutputSettings: [String: Any] = [
			AVVideoCodecKey: AVVideoCodecType.h264,
			AVVideoWidthKey: NSNumber(value: Float(videoSize.width)),
			AVVideoHeightKey: NSNumber(value: Float(videoSize.height))
		]
		
		self.videoWriterInput = AVAssetWriterInput(mediaType: AVMediaType.video, outputSettings: avOutputSettings)
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
		
		self.displayLink = CADisplayLink(target: self, selector: #selector(self.update))
		self.displayLink.preferredFrameRateRange = CAFrameRateRange(minimum: 60, maximum: 60)
		self.displayLink.add(to: .current, forMode: .common)
		
		guard self.addImage(image: renderFrame(), withPresentationTime: CMTime.zero) else { return nil }
	}
	
	
	/// Appends an image, returning true if successful
	private func addImage(image: UIImage, withPresentationTime presentationTime: CMTime) -> Bool {
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
		
		return self.pixelBufferAdaptor.append(pixelBuffer, withPresentationTime: presentationTime)
	}
	
	
	// - Converts a UIImage to a CVPixelBuffer, returning nil on failure
	/// - Parameters:
	///   - image: <#image description#>
	///   - pixelBufferPool: <#pixelBufferPool description#>
	///   - size: <#size description#>
	/// - Returns: <#description#>
	func pixelBufferFromImage(image: UIImage, pixelBufferPool: CVPixelBufferPool, size: CGSize) -> CVPixelBuffer?
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
	
	
	
	
	// MARK: - Render Frame
	
	var firstFrameTime:CFTimeInterval? = nil
	
	@objc private func update()
	{
		let timestamp = self.displayLink.timestamp
		
		if let firstFrameTime: CFTimeInterval = self.firstFrameTime {
			let image:UIImage = renderFrame()
			
			let timeDiff: CFTimeInterval = timestamp - firstFrameTime
			//print("timeDiff: \(timeDiff)")
			
			let presentationTime = CMTime(seconds: Double(timeDiff), preferredTimescale: 10000)
			
			if self.addImage(image: image, withPresentationTime: presentationTime) {
				print("ERROR: Failed to append frame")
			}
		}
		
		
		if self.firstFrameTime == nil && timestamp > 0 {
			self.firstFrameTime = timestamp
		}
	}
	
	
	
	// MARK: - Stop Video
	
	func stopRecording(completion: @escaping ()->()) {
		// Stop
		self.displayLink.invalidate()
		
		self.videoWriterInput.markAsFinished()
		
		self.assetWriter.finishWriting(completionHandler: {
			completion()
			print("Finished writing video file")
		})
	}
	
}
