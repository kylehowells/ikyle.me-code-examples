//
//  KHVisualiseView.swift
//  Illustrations
//
//  Created by Kyle Howells on 22/04/2022.
//

import UIKit
import CoreGraphics

class KHVisualiseView: UIView {

	override init(frame: CGRect) {
		super.init(frame: frame)
		
		self.backgroundView.layer.borderWidth = 4
		
		self.addSubview(self.backgroundView)
		self.addSubview(self.titleLabel)
		self.addSubview(self.anchorPointView)
		self.addSubview(self.rotationImageView)
		
		// Using defer to make the didSet run
		defer {
			self.primaryColor = UIColor(red: 252.0/255.0, green: 185.0/255.0, blue: 45.0/255.0, alpha: 1)
		}
	}
	
	@available(*, unavailable)
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	var primaryColor:UIColor = UIColor(red: 252.0/255.0, green: 185.0/255.0, blue: 45.0/255.0, alpha: 1) {
		didSet {
			self.backgroundView.backgroundColor = self.primaryColor.withAlphaComponent(0.5)
			self.backgroundView.layer.borderColor = self.primaryColor.cgColor
		}
	}
	
	
	// MARK: - Background
	
	let backgroundView: UIView = {
		let view = UIView()
		return view
	}()
	
	
	// MARK: - Title
	
	let titleLabel: UILabel = {
		let l: UILabel = UILabel()
		l.alpha = 0.5
		l.textColor = UIColor.black
		l.font = UIFont.systemFont(ofSize: 15, weight: .medium)
		l.adjustsFontSizeToFitWidth = true
		l.allowsDefaultTighteningForTruncation = true
		//l.showsExpansionTextWhenTruncated = true
		return l
	}()
	
	enum Position {
		case topLeft
		case topCenter
		case topRight
		
		case middleLeft
		case middleCenter
		case middleRight
		
		case bottomLeft
		case bottomCenter
		case bottomRight
	}
	var titlePosition:Position = .topLeft {
		didSet {
			self.setNeedsLayout()
		}
	}
	
	
	let anchorPointView:UIView = {
		let view = UIView(frame: CGRect(x: 0, y: 0, width: 12, height: 12))
		view.alpha = 0
		view.backgroundColor = UIColor(red: 70.0/255.0, green: 165.0/255.0, blue: 226.0/255.0, alpha: 0.5)
		
		view.layer.borderColor = UIColor(red: 70.0/255.0, green: 165.0/255.0, blue: 226.0/255.0, alpha: 1.0).cgColor
		view.layer.borderWidth = 3
		
		view.layer.cornerRadius = view.bounds.width * 0.5
		return view
	}()
	
	
	let rotationImageView:UIImageView = {
		let imv = UIImageView(image: UIImage(named: "arrow.clockwise.custom"))
		imv.tintColor = UIColor.black
		imv.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
		imv.contentMode = UIView.ContentMode.scaleAspectFit
		imv.layer.anchorPoint = CGPoint(x: 0.52, y: 0.56)
		imv.alpha = 0
		return imv
	}()
	
	
	// MARK: - Layout
	
	override func layoutSubviews() {
		super.layoutSubviews()
		
		let size: CGSize = self.bounds.size
		
		self.backgroundView.frame = self.bounds
		
		let borderWidth = self.backgroundView.layer.borderWidth
		
		self.titleLabel.frame = {
			let labelSize = self.titleLabel.sizeThatFits(size)
			
			var frame = CGRect()
			frame.size = labelSize
			frame.size.width = min(frame.width, size.width - (borderWidth * 2))
			frame.size.height = min(frame.height, size.height - (borderWidth * 2))
			
			switch self.titlePosition {
				case .topLeft:
					frame.origin.x = (borderWidth + 1)
					frame.origin.y = (borderWidth + 1)
					
				case .topCenter:
					frame.origin.x = (size.width - frame.width) * 0.5
					frame.origin.y = (borderWidth + 1)
				
				case .topRight:
					frame.origin.x = (size.width - (frame.width + (borderWidth + 1)))
					frame.origin.y = (borderWidth + 1)
					
				case .middleLeft:
					frame.origin.x = (borderWidth + 1)
					frame.origin.y = (size.height - frame.height) * 0.5
				
				case .middleCenter:
					frame.origin.x = (size.width - frame.width) * 0.5
					frame.origin.y = (size.height - frame.height) * 0.5
					
				case .middleRight:
					frame.origin.x = (size.width - (frame.width + (borderWidth + 1)))
					frame.origin.y = (size.height - frame.height) * 0.5
					
				case .bottomLeft:
					frame.origin.x = (borderWidth + 1)
					frame.origin.y = (size.height - (frame.height + (borderWidth + 1)))
					
				case .bottomCenter:
					frame.origin.x = (size.width - frame.width) * 0.5
					frame.origin.y = (size.height - (frame.height + (borderWidth + 1)))
					
				case .bottomRight:
					frame.origin.x = (size.width - (frame.width + (borderWidth + 1)))
					frame.origin.y = (size.height - (frame.height + (borderWidth + 1)))
			}
			
			return frame
		}()
		
		self.anchorPointView.center = CGPoint(
			x: size.width * self.layer.anchorPoint.x,
			y: size.height * self.layer.anchorPoint.y
		)
		self.rotationImageView.center = self.anchorPointView.center
		
	}
	
}
