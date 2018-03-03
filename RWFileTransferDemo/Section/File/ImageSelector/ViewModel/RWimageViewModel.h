//
//  RWimageViewModel.h
//  RWFileTransferDemo
//
//  Created by RyanWong on 2018/3/1.
//  Copyright © 2018年 RyanWong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Photos/PHAsset.h>
#import "RWBaseViewModel.h"

@class RWPhotoModel;
@interface RWimageViewModel : RWBaseViewModel

@property (copy, nonatomic, readonly)NSString *name;

@property (copy, nonatomic, readonly)PHAsset *asset;

@property (assign, nonatomic, readonly)long long size;

@property (assign, nonatomic)BOOL selected;

- (instancetype)initWithModel:(RWPhotoModel *)model;

- (void)loadImageDataWithPhotoWidth:(CGFloat)photoWidth success:(void(^)(id))success failure:(void (^)(NSError *))failure;

@end
