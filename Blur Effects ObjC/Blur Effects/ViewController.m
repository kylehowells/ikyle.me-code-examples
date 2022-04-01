//
//  ViewController.m
//  Blur Effects
//
//  Created by Kyle Howells on 01/04/2022.
//

#import "ViewController.h"
@import PhotosUI;

@interface ViewController () <PHPickerViewControllerDelegate>
@property (nonatomic, strong) UIImageView *imageView;

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIButton *chooseImageButton;
@property (nonatomic, strong) UIButton *effectButton;

@property (nonatomic, strong) UIVisualEffectView *topVisualEffectView;
@property (nonatomic, strong) UIVisualEffectView *bottomVisualEffectView;

@property (nonatomic, strong) NSArray <NSArray *> *blurStyleOptions;
@end


@implementation ViewController

- (void)viewDidLoad {
	[super viewDidLoad];
	
	self.view.backgroundColor = [UIColor redColor];
	
	// Background
	self.imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Grass"]];
	self.imageView.contentMode = UIViewContentModeScaleAspectFill;
	[self.view addSubview:self.imageView];
	
	
	
	// - Title Label
	self.titleLabel = [[UILabel alloc] init];
	self.titleLabel.font = [UIFont systemFontOfSize:14 weight:UIFontWeightMedium];
	self.titleLabel.adjustsFontSizeToFitWidth = YES;
	self.titleLabel.allowsDefaultTighteningForTruncation = YES;
	self.titleLabel.text = @"Blur Style";
	self.titleLabel.textColor = [UIColor blackColor];
	[self.titleLabel sizeToFit];
	[self.view addSubview:self.titleLabel];
	
	
	// - Choose Image
	
	UIButtonConfiguration *chooseConfig = [UIButtonConfiguration filledButtonConfiguration];
	chooseConfig.image = [UIImage systemImageNamed:@"photo"];
	
	self.chooseImageButton = [UIButton buttonWithType:UIButtonTypeCustom];
	self.chooseImageButton.configuration = chooseConfig;
	[self.chooseImageButton sizeToFit];
	[self.chooseImageButton addTarget:self action:@selector(chooseImagePressed:) forControlEvents:UIControlEventTouchUpInside];
	[self.view addSubview:self.chooseImageButton];
	
	
	// - Effect View
	
	UIButtonConfiguration *blurButtonConfig = [UIButtonConfiguration filledButtonConfiguration];
	blurButtonConfig.image = [UIImage systemImageNamed:@"sparkles"];
	
	self.effectButton = [UIButton buttonWithType:UIButtonTypeCustom];
	self.effectButton.configuration = blurButtonConfig;
	[self.effectButton sizeToFit];
	[self.effectButton addTarget:self action:@selector(chooseBlurEffect) forControlEvents:UIControlEventTouchUpInside];
	[self.view addSubview:self.effectButton];
	
	
	// - Visual Effects
	
	self.topVisualEffectView = [[UIVisualEffectView alloc] initWithEffect:nil];
	self.topVisualEffectView.overrideUserInterfaceStyle = UIUserInterfaceStyleLight;
	[self.view insertSubview:self.topVisualEffectView aboveSubview:self.imageView];
	
	//	UIView *contentView = [self contentViewContent];
	//	[self.visualEffectView.contentView addSubview:contentView];
	
	self.topVisualEffectView.effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleRegular];
	
	// - Bottom
	
	self.bottomVisualEffectView = [[UIVisualEffectView alloc] initWithEffect:nil];
	self.bottomVisualEffectView.overrideUserInterfaceStyle = UIUserInterfaceStyleDark;
	[self.view insertSubview:self.bottomVisualEffectView aboveSubview:self.imageView];
	
	self.bottomVisualEffectView.effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleRegular];
	
	
	// - Options
	
	self.blurStyleOptions = @[
		// Traditional blur styles
		@[ @( UIBlurEffectStyleExtraLight ), @"ExtraLight" ],
		@[ @( UIBlurEffectStyleLight ), @"Light" ],
		@[ @( UIBlurEffectStyleDark ), @"Dark" ],
		//@[@( UIBlurEffectStyleExtraDark ), @""],
		
		// Styles which automatically show one of the traditional blur styles, depending on the user interface style.
		
		@[ @( UIBlurEffectStyleRegular ), @"Regular" ],
		@[ @( UIBlurEffectStyleProminent ), @"Prominent" ],
		
		// Blur styles available in iOS 13
		@[ @( UIBlurEffectStyleSystemUltraThinMaterial ), @"SystemUltraThinMaterial" ],
		@[ @( UIBlurEffectStyleSystemThinMaterial ), @"SystemThinMaterial" ],
		@[ @( UIBlurEffectStyleSystemMaterial ), @"SystemMaterial" ],
		@[ @( UIBlurEffectStyleSystemThickMaterial ), @"SystemThickMaterial" ],
		@[ @( UIBlurEffectStyleSystemChromeMaterial ), @"SystemChromeMaterial" ],
		
		// And always-light and always-dark versions
		@[ @( UIBlurEffectStyleSystemUltraThinMaterialLight ), @"SystemUltraThinMaterialLight" ],
		@[ @( UIBlurEffectStyleSystemThinMaterialLight ), @"SystemThinMaterialLight" ],
		@[ @( UIBlurEffectStyleSystemMaterialLight ), @"SystemMaterialLight" ],
		@[ @( UIBlurEffectStyleSystemThickMaterialLight ), @"SystemThickMaterialLight" ],
		@[ @( UIBlurEffectStyleSystemChromeMaterialLight ), @"SystemChromeMaterialLight" ],
		
		@[ @( UIBlurEffectStyleSystemUltraThinMaterialDark ), @"SystemUltraThinMaterialDark" ],
		@[ @( UIBlurEffectStyleSystemThinMaterialDark ), @"SystemThinMaterialDark" ],
		@[ @( UIBlurEffectStyleSystemMaterialDark ), @"SystemMaterialDark" ],
		@[ @( UIBlurEffectStyleSystemThickMaterialDark ), @"SystemThickMaterialDark" ],
		@[ @( UIBlurEffectStyleSystemChromeMaterialDark ), @"SystemChromeMaterialDark" ],
	];
}

-(BOOL)prefersStatusBarHidden {
	return YES;
}


// MARK: - Layout

- (void)viewDidLayoutSubviews{
	[super viewDidLayoutSubviews];
	
	const CGSize size = self.view.bounds.size;
	
	self.imageView.frame = self.view.bounds;
	
	UIEdgeInsets safeArea = self.view.safeAreaInsets;
	CGSize buttonSize = self.chooseImageButton.bounds.size;
	
	self.chooseImageButton.center = ({
		CGPoint point = CGPointZero;
		point.x = safeArea.left + 10 + (buttonSize.width * 0.5);
		point.y = safeArea.top + 10 + (buttonSize.height * 0.5);
		point;
	});;
	
	self.effectButton.center = ({
		CGPoint point = CGPointZero;
		point.x = size.width - (safeArea.right + 10 + (buttonSize.width * 0.5));
		point.y = safeArea.top + 10 + (buttonSize.height * 0.5);
		point;
	});
	
	CGFloat maxTitleWidth = self.effectButton.frame.origin.x - CGRectGetMaxX(self.chooseImageButton.frame);
	[self.titleLabel sizeToFit];
	self.titleLabel.frame = ({
		CGRect frame = self.titleLabel.bounds;
		frame.size.width = MIN(maxTitleWidth, frame.size.width);
		frame;
	});
	self.titleLabel.center = CGPointMake(size.width * 0.5, safeArea.top + 20 + (self.titleLabel.bounds.size.height * 0.5));
	
	
	CGFloat buttonBottomY = CGRectGetMaxY(self.effectButton.frame);
	CGFloat availableHeight = (size.height - buttonBottomY) * 0.45;
	
	CGFloat effectWidth = MIN(size.width * 0.9, availableHeight);
	
	self.topVisualEffectView.frame = ({
		CGRect frame = CGRectZero;
		frame.size.width = effectWidth;
		frame.size.height = effectWidth;
		
		frame.origin.x = (size.width - effectWidth) * 0.5;
		frame.origin.y = buttonBottomY + 10;
		frame;
	});
	
	self.bottomVisualEffectView.frame = ({
		CGRect frame = CGRectZero;
		frame.size.width = effectWidth;
		frame.size.height = effectWidth;
		
		frame.origin.x = (size.width - effectWidth) * 0.5;
		frame.origin.y = (size.height - (effectWidth + 20));
		frame;
	});
}


// MARK: - Button Actions

-(void)chooseImagePressed:(id)sender {
	PHPickerConfiguration *config = [[PHPickerConfiguration alloc] init];
	config.selectionLimit = 1;
	config.filter = [PHPickerFilter imagesFilter];
	
	PHPickerViewController *pickerViewController = [[PHPickerViewController alloc] initWithConfiguration:config];
	pickerViewController.delegate = self;
	[self presentViewController:pickerViewController animated:YES completion:nil];
}

-(void)chooseBlurEffect{
	UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Blur Styles" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
	
	UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * action) {
		//action when pressed button
	}];
	[alertController addAction:cancelAction];
	
	
	for (NSArray *style in self.blurStyleOptions) {
		NSString *title = style[1];
		
		BOOL isCurrentOption = [self.titleLabel.text isEqualToString:title];
		
		NSString *optionTitle = [NSString stringWithFormat:@"%@%@", title, isCurrentOption ? @" ✔️" : @""];
		
		UIAlertAction *okAction = [UIAlertAction actionWithTitle:optionTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
			NSNumber *optionStyle = style[0];
			
			self.titleLabel.text = title;
			[self.view setNeedsLayout];
			
			self.topVisualEffectView.effect = [UIBlurEffect effectWithStyle: (UIBlurEffectStyle)[optionStyle integerValue] ];
			self.bottomVisualEffectView.effect = [UIBlurEffect effectWithStyle: (UIBlurEffectStyle)[optionStyle integerValue] ];
		}];
		[alertController addAction:okAction];
	}
	
	[self presentViewController:alertController animated: YES completion: nil];
}


// MARK: - PHPickerViewController

-(void)picker:(PHPickerViewController *)picker didFinishPicking:(NSArray<PHPickerResult *> *)results{
	[picker dismissViewControllerAnimated:YES completion:nil];
	
	for (PHPickerResult *result in results)
	{
		// Get UIImage
		[result.itemProvider loadObjectOfClass:[UIImage class] completionHandler:^(__kindof id<NSItemProviderReading>  _Nullable object, NSError * _Nullable error)
		 {
			if ([object isKindOfClass:[UIImage class]])
			{
				dispatch_async(dispatch_get_main_queue(), ^{
					NSLog(@"Selected image: %@", (UIImage*)object);
					self.imageView.image = (UIImage*)object;
				});
			}
		}];
	}
}

@end

/*
 UIBlurEffectStyleExtraLight,
 UIBlurEffectStyleLight,
 UIBlurEffectStyleDark,
 UIBlurEffectStyleExtraDark API_AVAILABLE(tvos(10.0)) API_UNAVAILABLE(ios) API_UNAVAILABLE(watchos),
 
 /* Styles which automatically show one of the traditional blur styles,
 * depending on the user interface style.
 *
 * Regular displays either Light or Dark.
 * /
UIBlurEffectStyleRegular API_AVAILABLE(ios(10.0)),
/* Prominent displays either ExtraLight, Dark (on iOS), or ExtraDark (on tvOS).
 * /
UIBlurEffectStyleProminent API_AVAILABLE(ios(10.0)),

/*
 * Blur styles available in iOS 13.
 *
 * Styles which automatically adapt to the user interface style:
 * /
UIBlurEffectStyleSystemUltraThinMaterial        API_AVAILABLE(ios(13.0)) API_UNAVAILABLE(tvos, watchos),
UIBlurEffectStyleSystemThinMaterial             API_AVAILABLE(ios(13.0)) API_UNAVAILABLE(tvos, watchos),
UIBlurEffectStyleSystemMaterial                 API_AVAILABLE(ios(13.0)) API_UNAVAILABLE(tvos, watchos),
UIBlurEffectStyleSystemThickMaterial            API_AVAILABLE(ios(13.0)) API_UNAVAILABLE(tvos, watchos),
UIBlurEffectStyleSystemChromeMaterial           API_AVAILABLE(ios(13.0)) API_UNAVAILABLE(tvos, watchos),

/* And always-light and always-dark versions:
 * /
UIBlurEffectStyleSystemUltraThinMaterialLight   API_AVAILABLE(ios(13.0)) API_UNAVAILABLE(tvos, watchos),
UIBlurEffectStyleSystemThinMaterialLight        API_AVAILABLE(ios(13.0)) API_UNAVAILABLE(tvos, watchos),
UIBlurEffectStyleSystemMaterialLight            API_AVAILABLE(ios(13.0)) API_UNAVAILABLE(tvos, watchos),
UIBlurEffectStyleSystemThickMaterialLight       API_AVAILABLE(ios(13.0)) API_UNAVAILABLE(tvos, watchos),
UIBlurEffectStyleSystemChromeMaterialLight      API_AVAILABLE(ios(13.0)) API_UNAVAILABLE(tvos, watchos),

UIBlurEffectStyleSystemUltraThinMaterialDark    API_AVAILABLE(ios(13.0)) API_UNAVAILABLE(tvos, watchos),
UIBlurEffectStyleSystemThinMaterialDark         API_AVAILABLE(ios(13.0)) API_UNAVAILABLE(tvos, watchos),
UIBlurEffectStyleSystemMaterialDark             API_AVAILABLE(ios(13.0)) API_UNAVAILABLE(tvos, watchos),
UIBlurEffectStyleSystemThickMaterialDark        API_AVAILABLE(ios(13.0)) API_UNAVAILABLE(tvos, watchos),
UIBlurEffectStyleSystemChromeMaterialDark       API_AVAILABLE(ios(13.0)) API_UNAVAILABLE(tvos, watchos),
 */
