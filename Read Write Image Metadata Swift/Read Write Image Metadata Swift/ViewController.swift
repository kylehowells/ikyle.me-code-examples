//
//  ViewController.swift
//  Read Write Image Metadata Swift
//
//  Created by Kyle Howells on 10/07/2020.
//  Copyright © 2020 Kyle Howells. All rights reserved.
//

import UIKit
import MobileCoreServices

class ViewController: UIViewController {
	
	lazy var imageView:UIImageView = {
		let imv = UIImageView()
		imv.backgroundColor = UIColor.black
		return imv
	}()
	lazy var textView:UITextView = {
		let txv = UITextView()
		txv.backgroundColor = .systemGray6
		txv.contentInset = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
		txv.alwaysBounceVertical = true
		txv.keyboardDismissMode = .interactive
		txv.font = UIFont.monospacedSystemFont(ofSize: 13, weight: .regular)
		return txv
	}()
	
	lazy var loadButton:UIButton = {
		let b = UIButton(type: .system)
		b.setTitle("Load File", for: .normal)
		return b
	}()
	lazy var saveButton:UIButton = {
		let b = UIButton(type: .system)
		b.setTitle("Save File", for: .normal)
		return b
	}()
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		self.view.backgroundColor = .white
		
		self.view.addSubview(imageView)
		self.view.addSubview(textView)
		self.view.addSubview(loadButton)
		self.view.addSubview(saveButton)
		
		loadButton.addTarget(self, action: #selector(loadPressed), for: .touchUpInside)
		saveButton.addTarget(self, action: #selector(savePressed), for: .touchUpInside)
	}
	
	
	@objc func loadPressed(_ sender: Any) {
		let picker = UIDocumentPickerViewController(documentTypes: [ kUTTypeImage as String ], in: UIDocumentPickerMode.import)
		picker.shouldShowFileExtensions = true
		picker.delegate = self
		present(picker, animated: true, completion: nil)
	}
	
	@objc func savePressed(_ sender: Any) {
		print("Save")
		let text = textView.text ?? ""
		let dict = stringToDictionary(text: text)
		guard dict != nil, let url = imageURL else { return }
		
		saveMetadata(dict!, toFile: url)
		
		let picker = UIDocumentPickerViewController(url: url, in: .exportToService)
		picker.shouldShowFileExtensions = true
		picker.delegate = self
		present(picker, animated: true, completion: nil)
	}
	
	
	var imageURL:URL?
	
	func loadImageAt(url: URL) {
		self.imageURL = url
		
		imageView.image = UIImage(contentsOfFile: url.path)
		
		let metadata = readMetadata(fromURL: url)
		let text = dictionaryToString(dict: metadata)
		textView.text = text
	}
	
	// MARK: - Image Metadata
	
	func readMetadata(fromURL url:URL) -> NSDictionary? {
		if let source = CGImageSourceCreateWithURL(url as CFURL, nil),
			let metadata:NSDictionary = CGImageSourceCopyPropertiesAtIndex(source, 0, nil) {
			return metadata
		}
		return nil
	}
	
	func saveMetadata(_ data:NSDictionary, toFile url:URL) {
		// Add metadata to imageData
		guard let source = CGImageSourceCreateWithURL(url as CFURL, nil),
			let uniformTypeIdentifier = CGImageSourceGetType(source) else { return }
		
		guard let destination = CGImageDestinationCreateWithURL(url as CFURL, uniformTypeIdentifier, 1, nil) else { return }
		CGImageDestinationAddImageFromSource(destination, source, 0, data)
		guard CGImageDestinationFinalize(destination) else { return }
	}
	
	
	// MARK: Layout
	
	override func viewDidLayoutSubviews() {
		super.viewDidLayoutSubviews()
		let size = self.view.bounds.size
		let safeArea = self.view.safeAreaInsets
		
		loadButton.sizeToFit()
		loadButton.center = CGPoint(x: (size.width / 3), y: (size.height - safeArea.bottom) - (loadButton.frame.height * 0.5))
		
		saveButton.sizeToFit()
		saveButton.center = CGPoint(x: (size.width / 3) * 2, y: (size.height - safeArea.bottom) - (loadButton.frame.height * 0.5))
		
		let buttonsTop = min(saveButton.frame.minY, loadButton.frame.minY)
		
		textView.frame = {
			var frame = CGRect.zero
			frame.origin.x = safeArea.left
			frame.size.width = size.width - (safeArea.left + safeArea.right)
			frame.origin.y = safeArea.top
			frame.size.height = (size.height - (safeArea.top + safeArea.bottom)) * 0.5
			return frame
		}()
		
		imageView.frame = {
			var frame = CGRect.zero
			frame.origin.x = safeArea.left
			frame.size.width = size.width - (safeArea.left + safeArea.right)
			frame.origin.y = textView.frame.maxY
			frame.size.height = buttonsTop - frame.origin.y
			return frame
		}()
	}
}


// MARK: - UIDocumentPickerDelegate

extension ViewController: UIDocumentPickerDelegate {
	func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
		print("documentPicker( \(controller), didPickDocumentsAt \(urls)")
		if controller.documentPickerMode == .exportToService { return; }
		let item = urls.first!
		
		let filename = item.lastPathComponent
		let cacheFilepath = getCacheFilePath(filename: filename)
		
		try? FileManager.default.removeItem(at: cacheFilepath)
		try? FileManager.default.moveItem(at: item, to: cacheFilepath)
		
		self.loadImageAt(url: cacheFilepath)
	}
}





// MARK: - Helpers

extension ViewController {
		
	// MARK: - NSDictionary Conversation
	
	func dictionaryToString(dict: NSDictionary?) -> String? {
		let dict = dict, data = try? PropertyListSerialization.data(fromPropertyList: dict as Any, format: PropertyListSerialization.PropertyListFormat.xml, options: 0)
		if let data = data {
			return String(data: data, encoding: String.Encoding.utf8)
		}
		return nil
//		data = [NSPropertyListSerialization dataWithPropertyList:plistData format:NSPropertyListXMLFormat_v1_0 options:nil error:&err];
	}
	
	func stringToDictionary(text: String) -> NSDictionary? {
		let data = text.data(using: .utf8)
		if let data = data {
			let plist = try? PropertyListSerialization.propertyList(from: data, options: [], format: nil)
			return plist as? NSDictionary
		}
		return nil
	}
	
	
	// MARK: -
	
	func getCacheDirectory() -> URL {
		let path = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true).first!
		return URL(fileURLWithPath: path)
	}
	
	func getCacheFilePath(filename:String) -> URL {
		let directory = getCacheDirectory()
		return directory.appendingPathComponent("image." + ((filename as NSString).pathExtension as String))
	}
	
}
