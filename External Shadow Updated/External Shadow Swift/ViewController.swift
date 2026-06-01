//
//  ViewController.swift
//  External Shadow Swift
//
//  Created by Kyle Howells on 16/06/2020.
//  Copyright © 2020 Kyle Howells. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
	
	let centerView: OuterShadowView = OuterShadowView(frame: CGRect(x: 0, y: 0, width: 120, height: 120))
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		self.view.backgroundColor = UIColor(patternImage: UIImage(named: "Checkerboard")!)
		
		self.view.addSubview(self.centerView)
		
		self.centerView.cornerRadius = 18
		self.centerView.cornerCurve = .continuous
		self.centerView.shadowRadius = 20
		
		self.centerView.displaysShadowClipView = false
		
		//self.centerView.containerView.backgroundColor = UIColor.blue
		
		//self.centerView.shadowView.alpha = 1
		//self.centerView.shadowView.layer.shadowColor = UIColor.black.cgColor
		//self.centerView.shadowView.layer.shadowOpacity = 1
		
		//self.centerView.shadowClipView.alpha = 0
		//self.centerView.shadowClipView.backgroundColor = UIColor.red
		//self.centerView.shadowClipView.layer.borderColor = UIColor.purple.cgColor
		//self.centerView.shadowClipView.layer.borderWidth = 80
		//self.centerView.cornerRadius = 8
		
		//self.centerView.containerView.backgroundColor = UIColor.green
		self.centerView.containerView.layer.borderColor = UIColor.green.cgColor
		self.centerView.containerView.layer.borderWidth = 1
		
		//self.centerView.shadowView.backgroundColor = UIColor.clear
	}
	
	override func viewDidLayoutSubviews() {
		super.viewDidLayoutSubviews()
		
		self.centerView.center = CGPoint(
			x: self.view.bounds.midX,
			y: self.view.bounds.midY
		)
	}
	
}


// MARK: - Swift Preview

#if DEBUG

// Not meant to be touched. Updates itself because of the binding
import SwiftUI

struct ViewController_Preview: PreviewProvider {
	static var previews: some View {
		return Wrapper(noOp: .constant("no-op"))
			.edgesIgnoringSafeArea(.all)
			.previewDisplayName("ViewController")
	}
}

// Could probably use a generic, for easier reuse
fileprivate struct Wrapper: UIViewControllerRepresentable {
	
	@Binding var noOp: String // no-op -> binding just to trigger updateUIView
	
	func makeUIViewController(context: Context) -> UIViewController {
		return ViewController()
	}
	
	func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
		uiViewController.view.setNeedsLayout()
		uiViewController.view.layoutIfNeeded()
	}
	
}

#endif
