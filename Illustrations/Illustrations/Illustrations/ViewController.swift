//
//  ViewController.swift
//  Illustrations
//
//  Created by Kyle Howells on 22/04/2022.
//

import UIKit
import AVFoundation


class ViewController: UIViewController {
	
	var demoViewController: DemoViewController? = nil
	
	let snapshotButton:UIButton = {
		let b = UIButton(type: .custom)
		b.tintColor = UIColor.systemBlue
		
		var config = UIButton.Configuration.filled()
		config.image = UIImage(systemName: "camera.viewfinder")
		b.configuration = config
		
		b.sizeToFit()
		
		return b
	}()
	
	let recorderButton:UIButton = {
		let b = UIButton(type: .custom)
		b.tintColor = UIColor.systemBlue
		
		var config = UIButton.Configuration.filled()
		config.image = UIImage(systemName: "record.circle")
		b.configuration = config
		
		b.sizeToFit()
		
		return b
	}()
	
	
	
	// MARK: - View Setup
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		self.view.backgroundColor = UIColor.red
		
		self.snapshotButton.addTarget(self, action: #selector(self.savePressed), for: .primaryActionTriggered)
		self.view.addSubview(self.snapshotButton)
		
		self.recorderButton.addTarget(self, action: #selector(self.startRecordingPressed), for: .primaryActionTriggered)
		self.view.addSubview(self.recorderButton)
		
		
		// - Setup Demo
		
		let demoVC = AnchorPointDemoViewController()
		
		// - Add to screen
		demoVC.willMove(toParent: self)
		self.view.addSubview(demoVC.view)
		self.addChild(demoVC)
		demoVC.didMove(toParent: self)
		
		self.demoViewController = demoVC
	}
	
	
	// MARK: - Layout
	
	override func viewDidLayoutSubviews() {
		super.viewDidLayoutSubviews()
		
		let safeArea = self.view.safeAreaInsets
		let bounds = self.view.bounds.inset(by: safeArea)
		
		let padding:CGFloat = 5
		
		let buttonSize = self.snapshotButton.intrinsicContentSize
		self.snapshotButton.center = CGPoint(
			x: bounds.minX + padding + (buttonSize.width * 0.5) + 8,
			y: bounds.minY + padding + (buttonSize.height * 0.5)
		)
		
		let recordButtonSize = self.recorderButton.intrinsicContentSize
		self.recorderButton.center = CGPoint(
			x: self.snapshotButton.frame.maxX + padding + (recordButtonSize.width * 0.5),
			y: self.snapshotButton.center.y
		)
		
		
		let internalFrame = bounds.inset(by: UIEdgeInsets(
			top: padding + buttonSize.height + 4,
			left: 10,
			bottom: 10,
			right: 10
		))
		
		if let demoViewController = self.demoViewController {
			let displaySize = type(of: demoViewController).displaySize
			
			demoViewController.view.bounds = CGRect(origin: .zero, size: displaySize)
			demoViewController.view.center = CGPoint(x: internalFrame.midX, y: internalFrame.midY)
			
			// Scale down
			let targetRect = AVMakeRect(aspectRatio: displaySize, insideRect: internalFrame)
			
			let scaleX = targetRect.width / displaySize.width
			let scaleY = targetRect.height / displaySize.height
			
			let scale = min(scaleX, scaleY)
			
			demoViewController.view.transform = CGAffineTransform(scaleX: scale, y: scale)
		}
	}
	
	
	// MARK: - Save Snapshot
	
	@objc func savePressed()
	{
		guard let demoViewController = self.demoViewController else {
			return
		}
		
		// - Image from view
		
		let displaySize = type(of: demoViewController).displaySize
		
		let renderer = UIGraphicsImageRenderer(size: displaySize)
		let image = renderer.image(actions: { _ in
			demoViewController.view.drawHierarchy(in: demoViewController.view.bounds, afterScreenUpdates: false)
		})

		
		// - Create File Path
		
		let date = Date()
		let formatter = DateFormatter()
		formatter.dateFormat = "y-MM-dd-HH-mm-ss.S"
		let currentTime = formatter.string(from: date)
		
		let demoName = String(describing: type(of: demoViewController))
		
		let filename = "\(demoName) - \(currentTime).png"
		
		let pathString = NSString(string: "~/Desktop/\(filename)").expandingTildeInPath
		
		let fileURL = URL(fileURLWithPath: String(pathString))
		print("fileURL: \(fileURL)")
		
		
		// - Save Image To Desktop
		
		guard let imageData = image.pngData() else { return }
		
		do {
			try imageData.write(to: fileURL)
		}
		catch {
			print(error)
		}
	}
	
	
	// MARK: - Record Video
	
	var recorder:MP4Recorder? = nil
	
	var isRecording: Bool = false
	
	@objc func startRecordingPressed()
	{
		if self.isRecording {
			self.recorder?.stopRecording(completion: {
				print("Finished recording")
			})
		}
		else {
			
			guard let demoViewController = self.demoViewController else { return }
			
			
			self.isRecording = true
			
			
			// - Create File Path
			
			let date = Date()
			let formatter = DateFormatter()
			formatter.dateFormat = "y-MM-dd-HH-mm-ss.S"
			let currentTime = formatter.string(from: date)
			
			let demoName = String(describing: type(of: demoViewController))
			
			let filename = "\(demoName) - \(currentTime).mp4"
			
			let pathString = NSString(string: "~/Desktop/\(filename)").expandingTildeInPath
//
			let fileURL = URL(fileURLWithPath: String(pathString))
			print("fileURL: \(fileURL)")
			
			
			
			let displaySize = type(of: demoViewController).displaySize
			
			let scale = UIScreen.main.scale
			let videoSize = CGSize(width: displaySize.width * scale, height: displaySize.height * scale)
			
			self.recorder = MP4Recorder(videoSize: videoSize, outputURL: fileURL, renderFrame: {
				
				let renderer = UIGraphicsImageRenderer(size: displaySize)
				let image = renderer.image(actions: { _ in
					demoViewController.view.drawHierarchy(in: demoViewController.view.bounds, afterScreenUpdates: false)
				})
				return image
				
			})
		}
	}
	
}

/*
extension CGRect {
	var betterDescription:String {
		return "(x: \(self.origin.x), y: \(self.origin.y), w: \(self.width), h: \(self.height))"
	}
}*/
