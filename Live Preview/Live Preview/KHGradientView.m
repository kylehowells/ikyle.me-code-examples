//
//  KHGradientView.m
//  ObjC Live Preview
//
//  Created by Kyle Howells on 01/07/2020.
//  Copyright © 2020 Kyle Howells. All rights reserved.
//

#import "KHGradientView.h"

@implementation KHGradientView
@dynamic layer;

+(Class)layerClass{
    return [CAGradientLayer class];
}

@end
