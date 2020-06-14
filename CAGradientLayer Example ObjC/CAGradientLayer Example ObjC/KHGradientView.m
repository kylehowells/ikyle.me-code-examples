//
//  KHGradientView.m
//
//  Created by Kyle Howells on 09/06/2020.
//  Copyright © 2020 Kyle Howells. All rights reserved.
//

#import "KHGradientView.h"

@implementation KHGradientView
@dynamic layer;

+(Class)layerClass{
    return [CAGradientLayer class];
}

//-(CAGradientLayer*)gradientLayer{
//	return (CAGradientLayer*)[self layer];
//}
@end
