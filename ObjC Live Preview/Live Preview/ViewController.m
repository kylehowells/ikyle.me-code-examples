//
//  ViewController.m
//  Live Preview
//
//  Created by Kyle Howells on 01/07/2020.
//  Copyright © 2020 Kyle Howells. All rights reserved.
//

#import "ViewController.h"
#import "KHGradientView.h"

@interface ViewController ()

@end


@implementation ViewController{
	KHGradientView *backgroundView;
	UILabel *label;
}

- (void)viewDidLoad {
	[super viewDidLoad];
	self.view.backgroundColor = [UIColor blackColor];
	
	backgroundView = [[KHGradientView alloc] init];
	backgroundView.layer.colors =
	@[
		(id)[UIColor colorWithRed: 48.0/255.0 green: 35.0/255.0 blue: 174.0/255.0 alpha: 1.0].CGColor,
		(id)[UIColor colorWithRed: 200.0/255.0 green: 109.0/255.0 blue: 215.0/255.0 alpha: 1.0].CGColor
	];
	[self.view addSubview:backgroundView];
	
	label = [[UILabel alloc] init];
	label.font = [UIFont systemFontOfSize:20 weight:UIFontWeightBold];
	label.text = @" Hello World ";
	label.textAlignment = NSTextAlignmentCenter;
	label.textColor = [UIColor blackColor];
	label.backgroundColor = [UIColor whiteColor];
	label.layer.cornerRadius = 8;
	label.layer.masksToBounds = YES;
	[self.view addSubview:label];
}


- (void)viewDidLayoutSubviews{
	[super viewDidLayoutSubviews];
	const CGSize size = self.view.bounds.size;
	
	backgroundView.frame = self.view.bounds;
	
	[label sizeToFit];
	label.frame = CGRectInset(label.frame, -10, -10);
	label.center = CGPointMake(size.width * 0.5, size.height * 0.5);
}

@end
