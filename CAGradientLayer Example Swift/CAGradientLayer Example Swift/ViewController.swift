//
//  ViewController.swift
//  CAGradientLayer Example Swift
//
//  Created by Kyle Howells on 15/06/2020.
//  Copyright © 2020 Kyle Howells. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

	//
	// Linear Gradient
	//
	lazy var linGradientView:KHGradientView = {
		let v = KHGradientView()
		v.gradientLayer.type = CAGradientLayerType.axial
		v.gradientLayer.colors =
		[
			UIColor(red: 48.0/255.0, green: 35.0/255.0, blue: 174.0/255.0, alpha: 1.0).cgColor,
			UIColor(red: 200.0/255.0, green: 109.0/255.0, blue: 215.0/255.0, alpha: 1.0).cgColor
		]
		v.gradientLayer.startPoint = CGPoint.zero
		v.gradientLayer.endPoint = CGPoint(x: 1, y: 1)
		return v
	}()
	
	
	//
	// Radial Gradient
	//
	lazy var radGradientView:KHGradientView = {
		let v = KHGradientView()
		v.gradientLayer.type = CAGradientLayerType.radial
		v.gradientLayer.colors =
		[
			UIColor(red: 0.0/255.0, green: 101.0/255.0, blue: 255.0/255.0, alpha: 1.0).cgColor,
			UIColor(red: 0.0/255.0, green: 40.0/255.0, blue: 101.0/255.0, alpha: 1.0).cgColor
		]
		v.gradientLayer.startPoint = CGPoint(x: 0.5, y: 0.5)
		v.gradientLayer.endPoint = CGPoint(x: 0, y: 1)
		return v
	}()
	
	
	//
	// Angluar Gradient
	//
	lazy var angGradientView:KHGradientView = {
		let v = KHGradientView()
		v.gradientLayer.type = CAGradientLayerType.conic
		v.gradientLayer.colors =
		[
			UIColor(red: 245.0/255.0, green: 81.0/255.0, blue: 95.0/255.0, alpha: 1.0).cgColor,
			UIColor(red: 159.0/255.0, green: 4.0/255.0, blue: 27.0/255.0, alpha: 1.0).cgColor
		]
		v.gradientLayer.startPoint = CGPoint(x: 0.5, y: 0.5)
		v.gradientLayer.endPoint = CGPoint(x: 1, y: 0.5)
		return v
	}()
	
	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view.
		
		self.view.addSubview(self.linGradientView)
		self.view.addSubview(self.radGradientView)
		self.view.addSubview(self.angGradientView)
	}

	override var prefersStatusBarHidden: Bool {
		return true
	}

	override func viewDidLayoutSubviews() {
		super.viewDidLayoutSubviews()
		let size = self.view.bounds.size
		
		if size.height > size.width {
			// Vertical layout
			
			let height = size.height / 3
			
			self.linGradientView.frame = {
				var frame = CGRect()
				frame.size.height = height
				frame.size.width = size.width
				return frame
			}()
			
			self.radGradientView.frame = {
				var frame = CGRect()
				frame.origin.y = height
				frame.size.height = height
				frame.size.width = size.width
				return frame
			}()
			
			self.angGradientView.frame = {
				var frame = CGRect()
				frame.origin.y = size.height - height
				frame.size.height = height
				frame.size.width = size.width
				return frame
			}()
			
		}
		else {
			// Horizontal layout
			
			let width = size.width / 3
			
			self.linGradientView.frame = {
				var frame = CGRect()
				frame.size.height = size.height
				frame.size.width = width
				return frame
			}()
			
			self.radGradientView.frame = {
				var frame = CGRect()
				frame.origin.x = width
				frame.size.height = size.height
				frame.size.width = width
				return frame
			}()
			
			self.angGradientView.frame = {
				var frame = CGRect()
				frame.origin.x = size.width - width
				frame.size.height = size.height
				frame.size.width = width
				return frame
			}()
		}

	}
}
