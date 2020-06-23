//
//  ViewController.m
//  Photo Picker ObjC
//
//  Created by Kyle Howells on 23/06/2020.
//

#import "ViewController.h"
#import <Photos/Photos.h>
#import <PhotosUI/PhotosUI.h>
@import MobileCoreServices;

@interface ViewController () <PHPickerViewControllerDelegate>

@end

@implementation ViewController{
	UIScrollView *scrollView;
	NSMutableArray <UIImageView*>* imageViews;
	UIButton *selectButton;
}

- (void)viewDidLoad {
	[super viewDidLoad];
	
	self.view.backgroundColor = [UIColor whiteColor];
	
	imageViews = [NSMutableArray array];
	
	// Create ScrollView
	scrollView = [[UIScrollView alloc] init];
	scrollView.backgroundColor = [UIColor colorWithWhite:0.98 alpha:1];
	[self.view addSubview:scrollView];
	
	// Select Photos Button
	selectButton = [UIButton buttonWithType:UIButtonTypeSystem];
	[selectButton setTitle:@"Select Photos" forState:UIControlStateNormal];
	[selectButton addTarget:self action:@selector(selectPressed:) forControlEvents:UIControlEventTouchUpInside];
	[selectButton sizeToFit];
	[self.view addSubview:selectButton];
}

-(void)viewDidLayoutSubviews{
	[super viewDidLayoutSubviews];
	const CGSize size = self.view.bounds.size;
	const UIEdgeInsets safeArea = self.view.safeAreaInsets;
	
	selectButton.frame = ({
		CGRect frame = CGRectZero;
		frame.size.width = MIN(size.width - 20, 250);
		frame.size.height = 40;
		frame.origin.y = size.height - (frame.size.height + 20 + safeArea.bottom);
		frame.origin.x = (size.width - frame.size.width) * 0.5;
		frame;
	});
	
	scrollView.frame = ({
		CGRect frame = CGRectZero;
		frame.origin.y = safeArea.top + 10;
		frame.size.height = (selectButton.frame.origin.y - 20) - frame.origin.y;
		frame.size.width = size.width - 40;
		frame.origin.x = (size.width - frame.size.width) * 0.5;
		frame;
	});
	
	CGFloat y = 10;
	for (NSInteger i = 0; i < imageViews.count; i++) {
		UIImageView *imageView = imageViews[i];
		imageView.frame = ({
			CGRect frame = CGRectZero;
			frame.origin.y = y;
			frame.size.width = MIN(scrollView.bounds.size.width - 20, 300);
			frame.origin.x = (scrollView.bounds.size.width - frame.size.width) * 0.5;
			frame.size.height = MIN(frame.size.width * 0.75, 250);
			y += frame.size.height + 10;
			frame;
		});
	}
	scrollView.contentSize = CGSizeMake(0, y);
}

#pragma mark Helpers

-(UIImageView*)newImageViewForImage:(UIImage*)image{
	UIImageView *imageView = [[UIImageView alloc] init];
	imageView.contentMode = UIViewContentModeScaleAspectFit;
	imageView.backgroundColor = [UIColor blackColor];
	imageView.image = image;
	return imageView;
}

-(void)clearImageViews{
	for (UIImageView *imageView in imageViews) {
		[imageView removeFromSuperview];
	}
	[imageViews removeAllObjects];
}

#pragma mark - PHPicker

-(void)selectPressed:(id)sender{
	PHPickerConfiguration *config = [[PHPickerConfiguration alloc] init];
	config.selectionLimit = 3;
	config.filter = [PHPickerFilter imagesFilter];
	
	PHPickerViewController *pickerViewController = [[PHPickerViewController alloc] initWithConfiguration:config];
	pickerViewController.delegate = self;
	[self presentViewController:pickerViewController animated:YES completion:nil];
}

-(void)picker:(PHPickerViewController *)picker didFinishPicking:(NSArray<PHPickerResult *> *)results{
	NSLog(@"-picker:%@ didFinishPicking:%@", picker, results);
	
	[self clearImageViews];
	[picker dismissViewControllerAnimated:YES completion:nil];
	
	for (PHPickerResult *result in results) {
		NSLog(@"result: %@", result);
		
		NSLog(@"%@", result.assetIdentifier);
		NSLog(@"%@", result.itemProvider);
		
		// Get UIImage
		[result.itemProvider loadObjectOfClass:[UIImage class] completionHandler:^(__kindof id<NSItemProviderReading>  _Nullable object, NSError * _Nullable error) {
			NSLog(@"object: %@, error: %@", object, error);

			if ([object isKindOfClass:[UIImage class]]) {
				dispatch_async(dispatch_get_main_queue(), ^{
					UIImageView *imageView = [self newImageViewForImage:(UIImage*)object];
					[self->imageViews addObject:imageView];
					[self->scrollView addSubview:imageView];
					[self.view setNeedsLayout];
				});
			}
		}];
		
		// Get file
//		[result.itemProvider loadItemForTypeIdentifier:(NSString *)kUTTypeImage options:nil completionHandler:^(id item, NSError *error) {
//			NSLog(@"%@", item);
//			NSLog(@"%@", [item class]);
//
//			if ([item isKindOfClass:[NSURL class]]) {
//				NSError *error = nil;
//				NSData *data = [NSData dataWithContentsOfURL:item options:0 error:&error];
//				NSLog(@"%@", data);
//				NSLog(@"%@", error);
//			}
//		}];
	}
}

@end
