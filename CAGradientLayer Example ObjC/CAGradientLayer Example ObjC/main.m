//
//  main.m
//  CAGradientLayer Example ObjC
//
//  Created by Kyle Howells on 14/06/2020.
//  Copyright © 2020 Kyle Howells. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

int main(int argc, char * argv[]) {
	NSString * appDelegateClassName;
	@autoreleasepool {
	    // Setup code that might create autoreleased objects goes here.
	    appDelegateClassName = NSStringFromClass([AppDelegate class]);
	}
	return UIApplicationMain(argc, argv, nil, appDelegateClassName);
}
