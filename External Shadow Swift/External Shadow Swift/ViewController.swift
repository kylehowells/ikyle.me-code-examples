//
//  ViewController.swift
//  External Shadow Swift
//
//  Created by Kyle Howells on 16/06/2020.
//  Copyright © 2020 Kyle Howells. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

	override func viewDidLoad() {
		super.viewDidLoad()
		
		view.backgroundColor = UIColor(patternImage: UIImage(named: "Checkerboard")!)
		
		
		//
		// Create Shadow View
		//
		let shadowView = UIView(frame: CGRect(x: 0, y: 0, width: 200, height: 200))
		shadowView.backgroundColor = UIColor(red: 0, green: 1, blue: 0, alpha: 0.5)
		shadowView.center = view.center
		shadowView.autoresizingMask = [.flexibleTopMargin, .flexibleRightMargin, .flexibleBottomMargin, .flexibleLeftMargin]
		view.addSubview(shadowView)
		shadowView.layer.cornerRadius = 10
		

		//
		// Add a shadow to the view
		//
		shadowView.layer.shadowColor = UIColor.black.cgColor
		shadowView.layer.shadowOffset = CGSize(width:0, height:1)
		shadowView.layer.shadowRadius = 20
		shadowView.layer.shadowOpacity = 1
		// Set the shadow path
		shadowView.layer.shadowPath = UIBezierPath(roundedRect: shadowView.bounds, cornerRadius: shadowView.layer.cornerRadius).cgPath
		
		
		//
		// Setup a mask to match the view
		//
		let maskLayer = CAShapeLayer()
		maskLayer.frame = shadowView.bounds
		maskLayer.path = UIBezierPath(roundedRect: shadowView.bounds, cornerRadius: shadowView.layer.cornerRadius).cgPath
		
		//
		// Make the mask area bigger than the view, so the shadow itself does not get clipped by the mask
		//
		let shadowBorder:CGFloat = (shadowView.layer.shadowRadius * 2) + 5;
		maskLayer.frame = maskLayer.frame.insetBy(dx:  -shadowBorder, dy:  -shadowBorder)  // Make bigger
		maskLayer.frame = maskLayer.frame.offsetBy(dx: shadowBorder/2, dy: shadowBorder/2) // Move top and left
		
		// Allow for cut outs in the shape
		maskLayer.fillRule = .evenOdd
		
		
		//
		// Create new path
		//
		let pathMasking = CGMutablePath()
		// Add the outer view frame
		pathMasking.addPath(UIBezierPath(rect: maskLayer.frame).cgPath)
		// Translate into the shape back to the smaller original view's frame start point
		var catShiftBorder = CGAffineTransform(translationX: shadowBorder/2, y: shadowBorder/2)
		// Now add the original path for the cut out the shape of the original view
		pathMasking.addPath(maskLayer.path!.copy(using: &catShiftBorder)!)
		// Set this big rect with a small cutout rect as the mask
		maskLayer.path = pathMasking;
		

		//
		// Set as a mask on the view with the shadow
		//
		shadowView.layer.mask = maskLayer;
		
		
		//
		// Content view to use
		//
		let contentView = UIView(frame: shadowView.frame)
		contentView.backgroundColor = UIColor(red: 0, green: 1, blue: 0, alpha: 0.5)
		contentView.center = shadowView.center
		contentView.autoresizingMask = [.flexibleTopMargin, .flexibleRightMargin, .flexibleBottomMargin, .flexibleLeftMargin]
		view.addSubview(contentView)
		contentView.layer.cornerRadius = shadowView.layer.cornerRadius
	}

}

