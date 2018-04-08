//
//  UIImage+Resize.m
//  RWFileTransferDemo
//
//  Created by RyanWong on 2018/4/5.
//  Copyright © 2018年 RyanWong. All rights reserved.
//

#import "UIImage+Resize.h"

@implementation UIImage(Resize)

+ (UIImage*)imageWithImageSimple:(UIImage*)image scaledToSize:(CGSize)newSize
{
    CGSize oldSize = image.size;
    CGFloat radio = oldSize.width / oldSize.height;
    CGSize finalSize;
    if (radio < 1.0) {
        finalSize = CGSizeMake(newSize.width, newSize.width / radio);
    } else {
        finalSize = CGSizeMake(newSize.height * radio, newSize.height);
    }
    
    UIGraphicsBeginImageContext(finalSize);
    [image drawInRect:CGRectMake(0,0,finalSize.width,finalSize.height)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

@end
