//
//  RWimageViewModel.m
//  RWFileTransferDemo
//
//  Created by RyanWong on 2018/3/1.
//  Copyright © 2018年 RyanWong. All rights reserved.
//

#import "RWimageViewModel.h"
#import "RWPhotoModel.h"
#import "RWImageLoad.h"
#import <Photos/Photos.h>

@interface RWimageViewModel()

@property (copy, nonatomic, readwrite)NSString *name;

@property (copy, nonatomic, readwrite)PHAsset *asset;

@property (assign, nonatomic, readwrite)long long size;

@property (copy, nonatomic, readwrite)NSString *fileType;

@property (copy, nonatomic, readwrite)NSString *pathExtension;

@end

@implementation RWimageViewModel

- (instancetype)initWithModel:(RWPhotoModel *)model {
    self = [super init];
    if (self) {
        _model = model;
        _name = model.name;
        _asset = model.asset;
        _size = model.size;
        _fileType = model.fileType;
        _pathExtension = model.pathExtension;
    }
    return self;
}

- (void)loadImageDataWithPhotoWidth:(CGFloat)photoWidth success:(void(^)(id))success failure:(void (^)(NSError *))failure {
    
    [[RWImageLoad shareLoad] getPhotoWithAsset:_asset photoWidth:photoWidth completion:^(UIImage *photo, NSDictionary *info, BOOL isDegraded) {
        !success?:success(photo);
    } progressHandler:nil networkAccessAllowed:NO];
}

- (void)loadVideoDataSuccess:(void(^)(long long size, UIImage *image))success failure:(void (^)(NSError *))failure {
    
    [[RWImageLoad shareLoad] getVideoInfoWithAsset:_asset completion:^(long long size, UIImage *image) {
        !success?:success(size, image);
    }];
}

@end
