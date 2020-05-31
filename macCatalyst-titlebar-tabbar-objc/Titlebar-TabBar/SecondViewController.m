//
//  SecondViewController.m
//  Titlebar-TabBar
//
//  Created by Kyle Howells on 31/05/2020.
//  Copyright © 2020 Kyle Howells. All rights reserved.
//

#import "SecondViewController.h"

@interface SecondViewController ()

@end

@implementation SecondViewController

- (void)viewDidLoad {
	[super viewDidLoad];
	// Do any additional setup after loading the view.
	
	self.title = @"Second";
	
	self.view.backgroundColor = [UIColor whiteColor];
	
	UILabel *label = [[UILabel alloc] init];
	label.textColor = [UIColor lightGrayColor];
	label.text = @"Second View";
	[label sizeToFit];
	[self.view addSubview:label];
	label.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleRightMargin;
	label.center = self.view.center;
}


@end
