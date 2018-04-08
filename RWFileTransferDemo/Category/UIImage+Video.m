//
//  UIImage+Video.m
//  RWFileTransferDemo
//
//  Created by RyanWong on 2018/4/5.
//  Copyright © 2018年 RyanWong. All rights reserved.
//

#import "UIImage+Video.h"

@implementation UIImage (Video)

+ (UIImage *)getThumbnailImageWithFilePath:(NSString *)filePath {
    return [self getThumbnailImage:filePath];
}

+ (UIImage *)getThumbnailImageWithURLAsset:(AVURLAsset *)asset {
    return [self getThumbnailImage:asset];
}

+ (UIImage *)getThumbnailImage:(id)object
{
    AVURLAsset *asset;
    if ([object isKindOfClass:[NSString class]]) {
        asset = [[AVURLAsset alloc] initWithURL:[NSURL fileURLWithPath:object] options:nil];
    } else if ([object isKindOfClass:[AVURLAsset class]]) {
        asset = (AVURLAsset *)object;
    }
    AVAssetImageGenerator *gen = [[AVAssetImageGenerator alloc] initWithAsset:asset];
    gen.appliesPreferredTrackTransform = YES;
    CMTime time = CMTimeMakeWithSeconds(0.0, 600);
    NSError *error = nil;
    CMTime actualTime;
    CGImageRef image = [gen copyCGImageAtTime:time actualTime:&actualTime error:&error];
    UIImage *thumb = [[UIImage alloc] initWithCGImage:image];
    CGImageRelease(image);
    return thumb;
}

@end
