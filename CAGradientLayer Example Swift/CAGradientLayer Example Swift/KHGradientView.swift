//
//  KHGradientView.swift
//
//  Created by Kyle Howells on 15/06/2020.
//  Copyright © 2020 Kyle Howells. All rights reserved.
//

import UIKit

class KHGradientView: UIView {
	
	override open class var layerClass: AnyClass {
	   return CAGradientLayer.classForCoder()
	}
	
	var gradientLayer : CAGradientLayer {
		return self.layer as! CAGradientLayer
	}
	
}
