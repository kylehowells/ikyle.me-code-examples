//
//  SecondViewController.swift
//  Titlebar-TabBar
//
//  Created by Kyle Howells on 31/05/2020.
//  Copyright © 2020 Kyle Howells. All rights reserved.
//

import UIKit

class SecondViewController: UIViewController {

	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view.
		self.title = "Second"
		
		self.view.backgroundColor = .white
		
		let label = UILabel()
		label.text = "Second View"
		label.textColor = UIColor.lightGray
		label.sizeToFit()
		self.view.addSubview(label)
		label.autoresizingMask = [.flexibleTopMargin, .flexibleRightMargin, .flexibleBottomMargin, .flexibleLeftMargin]
		label.center = self.view.center
	}
}
