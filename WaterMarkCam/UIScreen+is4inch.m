//
//  UIScreen+is4inch.m
//  TimeSliceCam
//
//  Created by Bane on 13/01/24.
//  Copyright (c) 2013年 Bane. All rights reserved.
//

#import "UIScreen+is4inch.h"

@implementation UIScreen (is4inch)

+ (BOOL)is4inch
{
    CGSize screenSize = [[self mainScreen] bounds].size;
    return screenSize.width == 320.0 && screenSize.height == 568.0;
}

+ (CGFloat)getScreentWidth {
    CGSize screenSize = [[self mainScreen] bounds].size;
    return screenSize.width;
}

+ (CGFloat)getScreenHeight {
    CGSize screenSize = [[self mainScreen] bounds].size;
    return screenSize.height;
}

@end
