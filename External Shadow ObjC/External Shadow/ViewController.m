//
//  ViewController.m
//  External Shadow
//
//  Created by Kyle Howells on 16/06/2020.
//  Copyright © 2020 Kyle Howells. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
@end

@implementation ViewController{
	UIView *shadowView;
}

- (void)viewDidLoad {
	[super viewDidLoad];
	
	self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"Checkerboard"]];
	
	//
	// Create Shadow View
	//
	shadowView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 200, 200)];
	shadowView.backgroundColor = [UIColor colorWithRed:0 green:1 blue:0 alpha:0.5];
	shadowView.center = self.view.center;
	shadowView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleLeftMargin;
	[self.view addSubview:shadowView];
	shadowView.layer.cornerRadius = 10;
	
	//
	// Add a shadow to the view
	//
	shadowView.layer.shadowColor = [UIColor blackColor].CGColor;
	shadowView.layer.shadowOffset = CGSizeMake(0, 1);
	shadowView.layer.shadowRadius = 20;
	shadowView.layer.shadowOpacity = 1;
	// Set the shadow path
	shadowView.layer.shadowPath = [UIBezierPath bezierPathWithRoundedRect:({
		CGRect frame = shadowView.bounds;
		frame.origin.x = 0;
		frame;
	}) cornerRadius:shadowView.layer.cornerRadius].CGPath;
	
	
	//
	// Setup a mask to match the view
	//
	CAShapeLayer *maskLayer = [CAShapeLayer layer];
	maskLayer.frame = shadowView.bounds;
	maskLayer.path = [UIBezierPath bezierPathWithRoundedRect:shadowView.bounds cornerRadius:shadowView.layer.cornerRadius].CGPath;
	
	//
	// Make the mask area bigger than the view, so the shadow itself does not get clipped by the mask
	//
	CGFloat shadowBorder = (shadowView.layer.shadowRadius * 2) + 5;// 50.0;
	maskLayer.frame = CGRectInset( maskLayer.frame, -shadowBorder, -shadowBorder ); // Make bigger
	maskLayer.frame = CGRectOffset( maskLayer.frame, shadowBorder/2.0, shadowBorder/2.0 ); // Move top and left
	
	// Allow for cut outs in the shape
	maskLayer.fillRule = kCAFillRuleEvenOdd;
	
	//
	// Create new path
	//
	CGMutablePathRef pathMasking = CGPathCreateMutable();
	// Add the outer view frame
	CGPathAddPath(pathMasking, NULL, [UIBezierPath bezierPathWithRect:maskLayer.frame].CGPath);
	// Translate into the shape back to the smaller original view's frame start point
	CGAffineTransform catShiftBorder = CGAffineTransformMakeTranslation( shadowBorder/2.0, shadowBorder/2.0);
	// Now add the original path for the cut out the shape of the original view
	CGPathAddPath(pathMasking, NULL, CGPathCreateCopyByTransformingPath(maskLayer.path, &catShiftBorder ) );
	// Set this big rect with a small cutout rect as the mask
	maskLayer.path = pathMasking;
	
	//
	// Set as a mask on the view with the shadow
	//
	shadowView.layer.mask = maskLayer;
	
	
	UIView *contentView = [[UIView alloc] initWithFrame:shadowView.frame];
	contentView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleLeftMargin;
	contentView.backgroundColor = [UIColor colorWithRed:0 green:1 blue:0 alpha:0.5];
	contentView.layer.cornerRadius = 10;
	[self.view addSubview:contentView];
}


@end
