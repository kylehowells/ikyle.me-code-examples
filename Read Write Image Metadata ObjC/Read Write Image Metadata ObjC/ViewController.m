//
//  ViewController.m
//  Read Write Image Metadata ObjC
//
//  Created by Kyle Howells on 13/07/2020.
//  Copyright © 2020 Kyle Howells. All rights reserved.
//

#import "ViewController.h"
@import MobileCoreServices;

@interface ViewController () <UIDocumentPickerDelegate>

@end

@implementation ViewController{
	UIImageView *imageView;
	UITextView *textView;
	UIButton *loadButton;
	UIButton *saveButton;
	
	NSURL *imageURL;
}

- (void)viewDidLoad {
	[super viewDidLoad];
	imageURL = nil;
	
	self.view.backgroundColor = [UIColor whiteColor];
	
	// Image View
	imageView = [[UIImageView alloc] init];
	imageView.backgroundColor = [UIColor blackColor];
	[self.view addSubview:imageView];
	
	// Text View
	textView = [[UITextView alloc] init];
	textView.backgroundColor = [UIColor systemGray6Color];
	textView.contentInset = UIEdgeInsetsMake(8, 8, 8, 8);
	textView.alwaysBounceVertical = YES;
	textView.keyboardDismissMode = UIScrollViewKeyboardDismissModeInteractive;
	textView.font = [UIFont monospacedSystemFontOfSize:13 weight:UIFontWeightRegular];
	[self.view addSubview:textView];
	
	loadButton = [UIButton buttonWithType:UIButtonTypeSystem];
	[loadButton setTitle:@"Load File" forState:UIControlStateNormal];
	[loadButton addTarget:self action:@selector(loadPressed) forControlEvents:UIControlEventTouchUpInside];
	[self.view addSubview:loadButton];
	
	saveButton = [UIButton buttonWithType:UIButtonTypeSystem];
	[saveButton setTitle:@"Save File" forState:UIControlStateNormal];
	[saveButton addTarget:self action:@selector(savePressed) forControlEvents:UIControlEventTouchUpInside];
	[self.view addSubview:saveButton];
}

- (void)viewDidLayoutSubviews{
	[super viewDidLayoutSubviews];
	const CGSize size = self.view.bounds.size;
	const UIEdgeInsets safeArea = self.view.safeAreaInsets;
	
	[loadButton sizeToFit];
	loadButton.center = CGPointMake((size.width / 3), (size.height - safeArea.bottom) - (loadButton.frame.size.height * 0.5));
	
	[saveButton sizeToFit];
	saveButton.center = CGPointMake( (size.width / 3) * 2, (size.height - safeArea.bottom) - (loadButton.frame.size.height * 0.5));
	
	CGFloat buttonsTop = MIN(saveButton.frame.origin.y, loadButton.frame.origin.y);
	
	textView.frame = ({
		CGRect frame = CGRectZero;
		frame.origin.x = safeArea.left;
		frame.size.width = size.width - (safeArea.left + safeArea.right);
		frame.origin.y = safeArea.top;
		frame.size.height = (size.height - (safeArea.top + safeArea.bottom)) * 0.5;
		frame;
	});
	
	imageView.frame = ({
		CGRect frame = CGRectZero;
		frame.origin.x = safeArea.left;
		frame.size.width = size.width - (safeArea.left + safeArea.right);
		frame.origin.y = CGRectGetMaxY(textView.frame);
		frame.size.height = buttonsTop - frame.origin.y;
		frame;
	});
}

#pragma mark - Button Actions

-(void)loadPressed{
	UIDocumentPickerViewController *pickerVC = [[UIDocumentPickerViewController alloc] initWithDocumentTypes:@[ (NSString*)kUTTypeImage ] inMode:UIDocumentPickerModeImport];
	pickerVC.shouldShowFileExtensions = YES;
	pickerVC.delegate = self;
	[self presentViewController:pickerVC animated:YES completion:nil];
}

-(void)savePressed{
	NSDictionary *meta = [self stringToDictionary:textView.text];
	[self saveMetadata:meta toImageAtURL:imageURL];
	
	UIDocumentPickerViewController *pickerVC = [[UIDocumentPickerViewController alloc] initWithURL:imageURL inMode:UIDocumentPickerModeExportToService];
	pickerVC.shouldShowFileExtensions = YES;
	pickerVC.delegate = self;
	[self presentViewController:pickerVC animated:YES completion:nil];
}



#pragma mark - Load Image

-(void)loadImageURL:(NSURL*)imageURL{
	self->imageURL = imageURL;
	
	imageView.image = [UIImage imageWithContentsOfFile:imageURL.path];
	
	NSDictionary *metadata = [self readMetadataFromURL:imageURL];
	NSString *text = [self dictionaryToString:metadata];
	textView.text = text;
	
	UIImage *image;
	UIImageJPEGRepresentation(<#UIImage * _Nonnull image#>, <#CGFloat compressionQuality#>)
}



#pragma mark - Image Metadata

-(NSDictionary*)readMetadataFromURL:(NSURL*)url{
	CGImageSourceRef source = CGImageSourceCreateWithURL((__bridge CFURLRef)url, NULL);
	CFDictionaryRef imageProperties = CGImageSourceCopyPropertiesAtIndex(source, 0, NULL);
	return (__bridge NSDictionary *)(imageProperties);
}

-(void)saveMetadata:(NSDictionary*)metadata toImageAtURL:(NSURL*)url{
	CGImageSourceRef source = CGImageSourceCreateWithURL((__bridge CFURLRef)url, NULL);
	CFStringRef uniformTypeIdentifier = CGImageSourceGetType(source);
	
	CGImageDestinationRef destination = CGImageDestinationCreateWithURL( (__bridge CFURLRef)url, uniformTypeIdentifier, 1, NULL);
	CGImageDestinationAddImageFromSource(destination, source, 0, (__bridge CFDictionaryRef)metadata);
	CGImageDestinationFinalize(destination);
}



#pragma mark - UIDocumentPickerDelegate

-(void)documentPicker:(UIDocumentPickerViewController *)controller didPickDocumentsAtURLs:(NSArray<NSURL *> *)urls{
	NSLog(@"-documentPicker:%@ didPickDocumentsAtURLs:%@", controller, urls);
	
	if (controller.documentPickerMode == UIDocumentPickerModeExportToService) {
		return;
	}
	
	NSURL *itemURL = [urls firstObject];
	NSString *filename = [itemURL lastPathComponent];
	NSURL *cacheFileURL = [self getCacheFilepath:filename];
	
	[[NSFileManager defaultManager] removeItemAtURL:cacheFileURL error:nil];
	[[NSFileManager defaultManager] moveItemAtURL:itemURL toURL:cacheFileURL error:nil];
	
	[self loadImageURL:cacheFileURL];
}


#pragma mark - Cache Helpers

-(NSURL*)getCacheDirectory{
	return [NSURL fileURLWithPath: [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject] ];
}

-(NSURL*)getCacheFilepath:(NSString*)filename{
	NSString *newFilename = [NSString stringWithFormat:@"image.%@", [filename pathExtension]];
	return [[self getCacheDirectory] URLByAppendingPathComponent:newFilename];
}

#pragma mark - NSDictionary Helpers

-(NSString*)dictionaryToString:(NSDictionary*)dict{
	NSData *data = [NSPropertyListSerialization dataWithPropertyList:dict format:NSPropertyListXMLFormat_v1_0 options:0 error:nil];
	return [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
}

-(NSDictionary*)stringToDictionary:(NSString*)text{
	NSData *data = [text dataUsingEncoding:NSUTF8StringEncoding];
	return [NSPropertyListSerialization propertyListWithData:data options:NSPropertyListImmutable format:nil error:nil];
}

@end
