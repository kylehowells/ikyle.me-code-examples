//
//  TransparentBackgroundView.swift
//  Kyle
//

import UIKit

// MARK: - TransparentBackgroundView

/// A checkerboard view used to show translucent content against a transparency-style background.
open class TransparentBackgroundView: UIView {
	
	/// The size of each checkerboard square.
	open var squareSize: CGFloat = 4 {
		didSet {
			self.setNeedsDisplay()
		}
	}
	
	/// The lighter checkerboard color.
	open var lightColor: UIColor = UIColor(white: 1, alpha: 1) {
		didSet {
			self.setNeedsDisplay()
		}
	}
	
	/// The darker checkerboard color.
	open var darkColor: UIColor = UIColor(white: 0.9, alpha: 1) {
		didSet {
			self.setNeedsDisplay()
		}
	}
	
	// MARK: - Setup
	
	public override init(frame: CGRect) {
		super.init(frame: frame)
		self.commonInit()
	}
	
	public required init?(coder: NSCoder) {
		super.init(coder: coder)
		self.commonInit()
	}
	
	open func commonInit() {
		self.backgroundColor = self.lightColor
		self.isOpaque = true
		self.contentMode = .redraw
	}
	
	// MARK: - Drawing
	
	open override func draw(_ rect: CGRect) {
		super.draw(rect)
		
		guard self.squareSize > 0 else {
			return
		}
		
		guard let context: CGContext = UIGraphicsGetCurrentContext() else {
			return
		}
		
		context.setFillColor(self.lightColor.cgColor)
		context.fill(rect)
		
		context.setFillColor(self.darkColor.cgColor)
		
		let squareSize: CGFloat = self.squareSize
		let startX: CGFloat = floor(rect.minX / squareSize) * squareSize
		let startY: CGFloat = floor(rect.minY / squareSize) * squareSize
		
		var y: CGFloat = startY
		
		while y < rect.maxY {
			var x: CGFloat = startX
			
			while x < rect.maxX {
				let column: Int = Int(floor(x / squareSize))
				let row: Int = Int(floor(y / squareSize))
				
				if (column + row).isMultiple(of: 2) == false {
					context.fill(CGRect(
						x: x,
						y: y,
						width: squareSize,
						height: squareSize
					))
				}
				
				x += squareSize
			}
			
			y += squareSize
		}
	}
	
}

// MARK: - Swift Preview

#if DEBUG

import SwiftUI

struct TransparentBackgroundView_Preview: PreviewProvider {
	static var previews: some View {
		Wrapper()
			.frame(width: 320, height: 200)
			.previewDisplayName("TransparentBackgroundView")
	}
}

fileprivate struct Wrapper: UIViewRepresentable {
	
	func makeUIView(context: Context) -> TransparentBackgroundView {
		let view = TransparentBackgroundView()
		//view.squareSize = 20
		return view
	}
	
	func updateUIView(_ uiView: TransparentBackgroundView, context: Context) {
		uiView.setNeedsDisplay()
	}
}

#endif
