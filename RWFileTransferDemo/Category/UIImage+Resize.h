//
//  UIImage+Resize.h
//  RWFileTransferDemo
//
//  Created by RyanWong on 2018/4/5.
//  Copyright © 2018年 RyanWong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UIImage(Resize)

+ (UIImage*)imageWithImageSimple:(UIImage*)image scaledToSize:(CGSize)newSize;

@end
