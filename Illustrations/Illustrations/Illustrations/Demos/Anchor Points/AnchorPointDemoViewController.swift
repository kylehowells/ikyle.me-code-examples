//
//  AnchorPointDemoViewController.swift
//  Illustrations
//
//  Created by Kyle Howells on 22/04/2022.
//

import UIKit

class AnchorPointDemoViewController: DemoViewController {

	override class var displaySize: CGSize {
		return CGSize(width: 600, height: 400)
	}
	
    override func viewDidLoad() {
        super.viewDidLoad()

		self.view.backgroundColor = UIColor.white;
		
		//self.createInitialViewExample()
		//self.createMultipleAnchorPointsExample()
		//self.createRotationExample()
		self.createOutsideExample()
	}
	
	func clearScreen() {
		self.view.subviews.forEach({ $0.removeFromSuperview() })
	}
	
	func createInitialViewExample()
	{
		{
			let padding:CGFloat = 10
			
			let exampleView = KHVisualiseView(frame: CGRect(x: padding, y: padding, width: Self.displaySize.width - (padding * 2), height: Self.displaySize.height - (padding * 2)))
			exampleView.titleLabel.text = "superview"
			exampleView.primaryColor = UIColor(white: 0.8, alpha: 1)
			self.view.addSubview(exampleView)
		}();
		
		{
			let exampleView = KHVisualiseView(frame: CGRect(x: 40, y: 45, width: 220, height: 100))
			
			let bounds = exampleView.bounds
			let boundString = "(x: \( Int(bounds.origin.x) ), y: \( Int(bounds.origin.y) ), w: \( Int(bounds.width) ), h: \( Int(bounds.height) ))"
			
			let center = exampleView.center
			let centerString = "(x: \( Int(center.x) ), y: \( Int(center.y) ))"
			
			let frame = exampleView.frame
			let frameString = "(x: \( Int(frame.origin.x) ), y: \( Int(frame.origin.y)), w: \(Int(frame.width)), h: \(Int(frame.height)))"
			
			exampleView.titleLabel.numberOfLines = 0
			exampleView.titleLabel.font = UIFont.systemFont(ofSize: 10, weight: .medium)
			exampleView.titleLabel.text = " bounds \(boundString)\n center \(centerString)\n transform (scale 1.0)\n\n frame: \(frameString)"
			self.view.addSubview(exampleView)
		}();
		
		{
			let exampleView = KHVisualiseView(frame: CGRect(x: 280, y: 220, width: 220, height: 100))
			
			let bounds = exampleView.bounds
			let boundString = "(x: \( Int(bounds.origin.x) ), y: \( Int(bounds.origin.y) ), w: \( Int(bounds.width) ), h: \( Int(bounds.height) ))"
			
			let center = exampleView.center
			let centerString = "(x: \( Int(center.x) ), y: \( Int(center.y) ))"
			
			let frame = exampleView.frame
			let frameString = "(x: \( Int(frame.origin.x) ), y: \( Int(frame.origin.y)), w: \(Int(frame.width)), h: \(Int(frame.height)))"
			
			exampleView.titleLabel.numberOfLines = 0
			exampleView.titleLabel.font = UIFont.systemFont(ofSize: 10, weight: .medium)
			exampleView.titleLabel.text = " bounds \(boundString)\n center \(centerString)\n transform (scale 1.5)\n\n frame: \(frameString)"
			
			//exampleView.anchorPointView.alpha = 1
			//exampleView.rotationImageView.alpha = 1
			self.view.addSubview(exampleView)
			
			exampleView.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
		}();
	}
	
	func createMultipleAnchorPointsExample() {
		{
			let padding:CGFloat = 10
			
			let exampleView = KHVisualiseView(frame: CGRect(x: padding, y: padding, width: Self.displaySize.width - (padding * 2), height: Self.displaySize.height - (padding * 2)))
			exampleView.titleLabel.text = "superview"
			exampleView.primaryColor = UIColor(white: 0.8, alpha: 1)
			self.view.addSubview(exampleView)
		}();
		
		
		let rotation:CGFloat = 0
		
		{
			let exampleView = KHVisualiseView(frame: CGRect(x: 25, y: 45, width: 250, height: 150))
			exampleView.titleLabel.text = " anchorPoint (x: 0.5, y: 0.5)"
			exampleView.anchorPointView.alpha = 1
			//exampleView.rotationImageView.alpha = 1
			self.view.addSubview(exampleView)
			
			exampleView.transform = CGAffineTransform(rotationAngle: rotation)
		}();
		
		{
			let exampleView = KHVisualiseView(frame: CGRect(x: 200, y: 40, width: 250, height: 150))
			exampleView.layer.anchorPoint = CGPoint(x: 0, y: 0)
			exampleView.titleLabel.text = " anchorPoint (x: 0.0, y: 0.0)"
			exampleView.anchorPointView.alpha = 1
			//exampleView.rotationImageView.alpha = 1
			self.view.addSubview(exampleView)
			
			exampleView.transform = CGAffineTransform(rotationAngle: rotation)
		}();
		
		{
			let exampleView = KHVisualiseView(frame: CGRect(x: -80, y: 210, width: 250, height: 150))
			exampleView.layer.anchorPoint = CGPoint(x: 0, y: 0.5)
			exampleView.titleLabel.text = " anchorPoint (x: 0.0, y: 0.5)"
			exampleView.anchorPointView.alpha = 1
			//exampleView.rotationImageView.alpha = 1
			self.view.addSubview(exampleView)
			
			exampleView.transform = CGAffineTransform(rotationAngle: rotation)
		}();
	}
	
	func createRotationExample()
	{
		{
			let padding:CGFloat = 10
			
			let exampleView = KHVisualiseView(frame: CGRect(x: padding, y: padding, width: Self.displaySize.width - (padding * 2), height: Self.displaySize.height - (padding * 2)))
			exampleView.titleLabel.text = "superview"
			exampleView.primaryColor = UIColor(white: 0.8, alpha: 1)
			self.view.addSubview(exampleView)
		}();
		
		
		let rotation:CGFloat = 0.125
		
		{
			let exampleView = KHVisualiseView(frame: CGRect(x: 25, y: 45, width: 250, height: 150))
			exampleView.titleLabel.text = " anchorPoint (x: 0.5, y: 0.5)"
			exampleView.anchorPointView.alpha = 1
			exampleView.rotationImageView.alpha = 1
			self.view.addSubview(exampleView)
			
			exampleView.transform = CGAffineTransform(rotationAngle: rotation)
		}();
		
		{
			let exampleView = KHVisualiseView(frame: CGRect(x: 200, y: 40, width: 250, height: 150))
			exampleView.layer.anchorPoint = CGPoint(x: 0, y: 0)
			exampleView.titleLabel.text = " anchorPoint (x: 0.0, y: 0.0)"
			exampleView.anchorPointView.alpha = 1
			exampleView.rotationImageView.alpha = 1
			self.view.addSubview(exampleView)
			
			exampleView.transform = CGAffineTransform(rotationAngle: rotation)
		}();
		
		{
			let exampleView = KHVisualiseView(frame: CGRect(x: -80, y: 210, width: 250, height: 150))
			exampleView.layer.anchorPoint = CGPoint(x: 0, y: 0.5)
			exampleView.titleLabel.text = " anchorPoint (x: 0.0, y: 0.5)"
			exampleView.anchorPointView.alpha = 1
			exampleView.rotationImageView.alpha = 1
			self.view.addSubview(exampleView)
			
			exampleView.transform = CGAffineTransform(rotationAngle: rotation)
		}();
	}
	
	
	func createOutsideExample()
	{
		let padding:CGFloat = 10
		let superviewFrame = CGRect(x: padding, y: padding, width: Self.displaySize.width - (padding * 2), height: Self.displaySize.height - (padding * 2));
		
		{
			let exampleView = KHVisualiseView(frame: superviewFrame)
			exampleView.titleLabel.text = "superview"
			exampleView.primaryColor = UIColor(white: 0.8, alpha: 1)
			self.view.addSubview(exampleView)
		}();
		
		
		let rotationAmount:CGFloat = 0.5;
		
		var rotation:CGFloat = rotationAmount + 0
		
		{
			let exampleView = KHVisualiseView(frame: CGRect(x: 25, y: 45, width: 150, height: 100))
			
			exampleView.layer.anchorPoint = CGPoint(x: -0.85, y: 0.5)
			exampleView.titleLabel.text = " anchorPoint (x: -0.85, y: 0.5)"
			
			exampleView.anchorPointView.alpha = 1
			//exampleView.rotationImageView.alpha = 1
			self.view.addSubview(exampleView)
			
			exampleView.center = CGPoint(x: superviewFrame.midX, y: superviewFrame.midY)
			
			exampleView.transform = CGAffineTransform(rotationAngle: rotation)
		}();
		
		{
			let exampleView = KHVisualiseView(frame: CGRect(x: 25, y: 45, width: 150, height: 100))
			
			exampleView.layer.anchorPoint = CGPoint(x: -0.1, y: 0.5)
			exampleView.titleLabel.text = " anchorPoint (x: -0.1, y: 0.5)"
			
			exampleView.anchorPointView.alpha = 1
			self.view.addSubview(exampleView)
			
			exampleView.center = CGPoint(x: superviewFrame.midX, y: superviewFrame.midY)
			
			exampleView.transform = CGAffineTransform(rotationAngle: -rotationAmount)
		}();
		
		{
			let exampleView = KHVisualiseView(frame: CGRect(x: 25, y: 45, width: 150, height: 100))
			
			exampleView.layer.anchorPoint = CGPoint(x: 1.8, y: 0.5)
			exampleView.titleLabel.text = " anchorPoint (x: 1.8, y: 0.5)"
			
			exampleView.anchorPointView.alpha = 1
			self.view.addSubview(exampleView)
			
			exampleView.center = CGPoint(x: superviewFrame.midX, y: superviewFrame.midY)
			
			exampleView.transform = CGAffineTransform(rotationAngle: -rotationAmount)
		}();
		
		{
			let exampleView = KHVisualiseView(frame: CGRect(x: 25, y: 45, width: 150, height: 100))
			
			exampleView.layer.anchorPoint = CGPoint(x: 1.5, y: 1.65)
			exampleView.titleLabel.text = " anchorPoint (x: 1.5, y: 1.65)"
			
			exampleView.anchorPointView.alpha = 1
			self.view.addSubview(exampleView)
			
			exampleView.center = CGPoint(x: superviewFrame.midX, y: superviewFrame.midY)
			
			//exampleView.transform = CGAffineTransform(rotationAngle: -rotationAmount)
		}();
		
	}
	
}
