//
//  RWImageLoad.h
//  RWFileTransferDemo
//
//  Created by RyanWong on 2018/2/26.
//  Copyright © 2018年 RyanWong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <Photos/Photos.h>

@interface RWImageLoad : NSObject

+(instancetype)shareLoad;

- (void)getAlbumContentImage:(BOOL)contentImage contentVideo:(BOOL)contentVideo  completion:(void (^)(NSMutableArray  *albums))completion;

- (PHImageRequestID)getPhotoWithAsset:(id)asset photoWidth:(CGFloat)photoWidth completion:(void (^)(UIImage *photo,NSDictionary *info,BOOL isDegraded))completion progressHandler:(void (^)(double progress, NSError *error, BOOL *stop, NSDictionary *info))progressHandler networkAccessAllowed:(BOOL)networkAccessAllowed;

- (PHImageRequestID)getPhotoDataWithAsset:(id)asset completion:(void (^)(NSData *imageData, NSString *dataUTI, NSDictionary * info))completion;

- (PHImageRequestID)getVideoInfoWithAsset:(id)asset completion:(void (^)(long long size, UIImage *image))completion;

- (PHImageRequestID)getVideoDataWithAsset:(id)asset completion:(void (^)(NSData *data))completion;

@end
