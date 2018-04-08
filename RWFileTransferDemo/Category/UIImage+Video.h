//
//  UIImage+Video.h
//  RWFileTransferDemo
//
//  Created by RyanWong on 2018/4/5.
//  Copyright © 2018年 RyanWong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

@interface UIImage (Video)

+ (UIImage *)getThumbnailImageWithFilePath:(NSString *)filePath;

+ (UIImage *)getThumbnailImageWithURLAsset:(AVURLAsset *)asset;

@end
