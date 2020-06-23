//
//  ViewController.swift
//  Photo Picker Swift
//
//  Created by Kyle Howells on 23/06/2020.
//

import UIKit
import PhotosUI

class ViewController: UIViewController, PHPickerViewControllerDelegate {

	// MARK: - PHPickerViewController
	
	@objc func pickPhotos()
	{
		var config = PHPickerConfiguration()
		config.selectionLimit = 3
		config.filter = PHPickerFilter.images
		
		let pickerViewController = PHPickerViewController(configuration: config)
		pickerViewController.delegate = self
		self.present(pickerViewController, animated: true, completion: nil)
	}
	
	// MARK: PHPickerViewControllerDelegate
	
	func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
		picker.dismiss(animated: true, completion: nil)
		print(picker)
		print(results)
		
		for result in results {
			print(result.assetIdentifier)
			print(result.itemProvider)
			
			result.itemProvider.loadObject(ofClass: UIImage.self, completionHandler: { (object, error) in
				print(object)
				print(error)
				if let image = object as? UIImage {
					DispatchQueue.main.async {
						let imv = self.newImageView(image: image)
						self.imageViews.append(imv)
						self.scrollView.addSubview(imv)
						self.view.setNeedsLayout()
					}
				}
			})
		}
	}
	
	
	
	// MARK: - View Setup
	
	lazy var scrollView:UIScrollView = {
		let s = UIScrollView()
		s.backgroundColor = UIColor(white: 0.98, alpha: 1)
		return s
	}()
	
	lazy var button:UIButton = {
		let b = UIButton(type: .system)
		b.setTitle("Select Photos", for: .normal)
		b.addTarget(self, action: #selector(pickPhotos), for: .touchUpInside)
		b.sizeToFit()
		return b
	}()
	
	var imageViews = [UIImageView]()
	
	func newImageView(image:UIImage?) -> UIImageView {
		let imv = UIImageView()
		imv.backgroundColor = .black
		imv.image = image
		return imv
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		self.view.backgroundColor = UIColor.white
		
		self.view.addSubview(self.scrollView)
		self.view.addSubview(self.button)
	}
	
	override func viewDidLayoutSubviews() {
		super.viewDidLayoutSubviews()
		let size = self.view.bounds.size
		let safeArea = self.view.safeAreaInsets
		let padding:CGFloat = 10
		
		button.frame = {
			var f = CGRect.zero
			f.size.width = min(size.width - (padding * 2), 250)
			f.size.height = 40
			f.origin.x = (size.width - f.width) * 0.5
			f.origin.y = size.height - (safeArea.bottom + padding + f.size.height)
			return f
		}()
		
		scrollView.frame = {
			var f = CGRect.zero
			f.origin.y = safeArea.top + padding
			f.size.width = size.width - (padding * 2)
			f.size.height = (button.frame.minY - 20) - f.origin.y
			f.origin.x = (size.width - f.width) * 0.5
			return f
		}()
		
		var y:CGFloat = 10
		for imageView in imageViews {
			imageView.frame = {
				var f = CGRect.zero
				f.origin.y = y
				f.size.width = min(scrollView.bounds.width - (padding * 2), 300)
				f.size.height = min(f.width * 0.75, 250)
				f.origin.x = (scrollView.bounds.width - f.size.width) * 0.5
				y += f.size.height + padding
				return f
			}()
		}
		scrollView.contentSize = CGSize(width: 0, height: y)
	}
}
