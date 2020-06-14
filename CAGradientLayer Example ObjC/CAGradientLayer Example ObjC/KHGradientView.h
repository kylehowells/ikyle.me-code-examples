//
//  KHGradientView.h
//
//  Created by Kyle Howells on 09/06/2020.
//  Copyright © 2020 Kyle Howells. All rights reserved.
//

#import <UIKit/UIKit.h>
@import QuartzCore;

@interface KHGradientView : UIView
@property(nonatomic, readonly, strong) CAGradientLayer *layer;
//-(CAGradientLayer*)gradientLayer;
@end
