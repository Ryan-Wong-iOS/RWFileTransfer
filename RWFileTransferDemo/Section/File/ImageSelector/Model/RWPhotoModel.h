//
//  RWPhotoModel.h
//  RWFileTransferDemo
//
//  Created by RyanWong on 2018/3/1.
//  Copyright © 2018年 RyanWong. All rights reserved.
//

#import <Foundation/Foundation.h>

@class PHAsset;
@interface RWPhotoModel : NSObject

@property (copy, nonatomic)NSString *name;

@property (copy, nonatomic)PHAsset *asset;

@property (assign, nonatomic)long long size;

@property (copy, nonatomic)NSString *fileType;

@property (copy, nonatomic)NSString *pathExtension;

- (instancetype)initWithDictionary:(NSDictionary *)dict;

@end
