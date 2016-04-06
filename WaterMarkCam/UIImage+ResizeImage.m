//
//  UIImage+ResizeImage.m
//  WaterMarkCam
//
//  Created by Bane on 2013/06/04.
//  Copyright (c) 2013年 Bane. All rights reserved.
//

#import "UIImage+ResizeImage.h"

@implementation UIImage (UIImage_ResizeImage)

- (UIImage *)resizeImageWithSize:(CGSize)size {
    CGFloat widthRatio  = size.width  / self.size.width;
    CGFloat heightRatio = size.height / self.size.height;
    
    CGFloat ratio = (widthRatio < heightRatio) ? widthRatio : heightRatio;
    
    if (ratio >= 1.0) {
        return self;
    }
    
    CGRect rect = CGRectMake(0, 0,
                             self.size.width  * ratio,
                             self.size.height * ratio);
    
    UIGraphicsBeginImageContext(rect.size);
    [self drawInRect:rect];
    
    UIImage* shrinkedImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return shrinkedImage;
    
}


@end
