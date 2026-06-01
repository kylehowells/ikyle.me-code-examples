//
//  OuterShadowView.swift
//  Kyle
//

import UIKit

// MARK: - OuterShadowView

/// A view that draws an outer shadow around a clipped content container.
open class OuterShadowView: UIView {
	
	/// The view that owns the actual shadow rendering.
	public let shadowView: UIView = {
		let view = UIView()
		view.backgroundColor = UIColor(white: 0, alpha: 1)
		// view.backgroundColor = UIColor.orange
		
		view.layer.shadowRadius = 10
		view.layer.shadowOpacity = 0.5
		view.layer.shadowColor = UIColor.black.cgColor
		view.layer.shadowOffset = CGSize(width: 0, height: 1)
		
		return view
	}()
	
	/// A mask view used to cut the shadow so it appears outside the content bounds.
	public let shadowClipView: UIView = {
		let view = UIView()
		// view.backgroundColor = UIColor.blue
		
		view.layer.borderColor = UIColor.black.cgColor
		view.layer.borderWidth = 24
		
		view.layer.cornerCurve = .circular
		
		return view
	}()
	
	/// The clipped content container displayed above the shadow.
	public let containerView: UIView = {
		let view = UIView()
		// view.backgroundColor = UIColor.orange.withAlphaComponent(0.25)
		view.clipsToBounds = true
		return view
	}()
	
	/// Displays the mask view as a normal subview instead of using it as `shadowView.mask`.
	open var displaysShadowClipView: Bool = false {
		didSet {
			self.updateShadowClipViewDisplayMode()
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
		// self.backgroundColor = UIColor.green
		
		self.addSubview(self.shadowView)
		self.addSubview(self.containerView)
		
		self.cornerCurve = .continuous
		self.updateShadowClipViewDisplayMode()
	}
	
	open func updateShadowClipViewDisplayMode() {
		if self.displaysShadowClipView {
			self.shadowView.mask = nil
			
			if self.shadowClipView.superview !== self {
				self.addSubview(self.shadowClipView)
			}
			self.bringSubviewToFront(self.shadowClipView)
		}
		else {
			self.shadowClipView.removeFromSuperview()
			self.shadowView.mask = nil
			self.shadowView.mask = self.shadowClipView
			self.bringSubviewToFront(self.containerView)
		}
	}
	
	// MARK: - Shadow Properties
	
	/// The blur radius used for the outer shadow.
	open var shadowRadius: CGFloat = 24 {
		didSet {
			let shadowRadius = self.shadowRadius
			let padding: CGFloat = (shadowRadius + 8) * 1.5
			
			self.shadowClipView.layer.borderWidth = padding
			self.shadowView.layer.shadowRadius = shadowRadius
			
			self.shadowClipView.layer.cornerRadius = self.cornerRadius + self.shadowClipView.layer.borderWidth
			
			self.setNeedsLayout()
		}
	}
	
	/// The corner radius shared by the shadow and clipped content.
	open var cornerRadius: CGFloat = 0 {
		didSet {
			let cornerRadius: CGFloat = self.cornerRadius
			
			self.layer.cornerRadius = cornerRadius
			self.containerView.layer.cornerRadius = cornerRadius
			
			self.shadowView.layer.cornerRadius = cornerRadius
			
			self.shadowClipView.layer.cornerRadius = cornerRadius + self.shadowClipView.layer.borderWidth
			
			self.setNeedsLayout()
		}
	}
	
	/// The corner curve applied to the shadow and clipped content.
	open var cornerCurve: CALayerCornerCurve = .circular {
		didSet {
			let cornerCurve = self.cornerCurve
			
			self.layer.cornerCurve = cornerCurve
			self.containerView.layer.cornerCurve = cornerCurve
			
			self.shadowView.layer.cornerCurve = cornerCurve
			self.shadowClipView.layer.cornerCurve = cornerCurve
			
			self.setNeedsLayout()
		}
	}
	
	// MARK: - Layout
	
	open override func layoutSubviews() {
		super.layoutSubviews()
		
		self.shadowView.frame = self.bounds
		
		let padding: CGFloat = -self.shadowClipView.layer.borderWidth
		
		self.shadowClipView.frame = self.bounds.inset(by: UIEdgeInsets(
			top: padding,
			left: padding,
			bottom: padding,
			right: padding
		))
		
		self.containerView.frame = self.bounds
	}
	
}

// MARK: - Swift Preview

#if DEBUG

// Not meant to be touched. Updates itself because of the binding
import SwiftUI

struct OuterShadowView_Preview: PreviewProvider {
	static var previews: some View {
		return ZStack(content: {
			TransparentBackgroundWrapper()
			
			HStack(content: {
				Spacer()
				
				VStack(content: {
					Spacer()
					
					Wrapper(noOp: .constant("no-op"))
						.frame(width: 320, height: 200)
					
					Spacer()
				})
				
				Spacer()
			})
		})
		.edgesIgnoringSafeArea(.all)
		.previewDisplayName("OuterShadowView")
	}
	
}

/// Could probably use a generic, for easier reuse
fileprivate struct Wrapper: UIViewRepresentable {
	
	@Binding var noOp: String // no-op -> binding just to trigger updateUIView
	
	func makeUIView(context: Context) -> UIView {
		let v = OuterShadowView()
		
		v.shadowRadius = 30
		v.cornerRadius = 20
		
		return v
	}
	
	func updateUIView(_ uiView: UIView, context: Context) {
		uiView.setNeedsLayout()
		uiView.layoutIfNeeded()
	}
	
	/*@available(iOS 16.0, *)
	func sizeThatFits(_ proposal: ProposedViewSize, uiView: UIView, context: Context) -> CGSize? {
		let size: CGSize = uiView.sizeThatFits(CGSize(
			width: proposal.width ?? 320,
			height: proposal.height ?? CGFloat.greatestFiniteMagnitude
		))
		
		return size
	}*/
	
}

fileprivate struct TransparentBackgroundWrapper: UIViewRepresentable {
	
	func makeUIView(context: Context) -> TransparentBackgroundView {
		let view = TransparentBackgroundView()
		view.squareSize = 8
		return view
	}
	
	func updateUIView(_ uiView: TransparentBackgroundView, context: Context) {
		uiView.setNeedsDisplay()
	}
	
}

#endif
