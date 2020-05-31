//
//  FirstViewController.m
//  Titlebar-TabBar
//
//  Created by Kyle Howells on 31/05/2020.
//  Copyright © 2020 Kyle Howells. All rights reserved.
//

#import "FirstViewController.h"

@interface FirstViewController ()

@end

@implementation FirstViewController

- (void)viewDidLoad {
	[super viewDidLoad];
	// Do any additional setup after loading the view.
	
	self.title = @"First";
	
	self.view.backgroundColor = [UIColor whiteColor];
	
	UILabel *label = [[UILabel alloc] init];
	label.textColor = [UIColor lightGrayColor];
	label.text = @"First View";
	[label sizeToFit];
	[self.view addSubview:label];
	label.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleRightMargin;
	label.center = self.view.center;
}


@end
