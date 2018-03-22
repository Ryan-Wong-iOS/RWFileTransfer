//
//  RWPhotoModel.m
//  RWFileTransferDemo
//
//  Created by RyanWong on 2018/3/1.
//  Copyright © 2018年 RyanWong. All rights reserved.
//

#import "RWPhotoModel.h"
#import <Photos/Photos.h>
@implementation RWPhotoModel

- (instancetype)initWithDictionary:(NSDictionary *)dict {
    self = [super init];
    if (self) {
        _name = dict[@"name"];
        _size = [dict[@"size"] longLongValue];
        _fileType = dict[@"fileType"];
        _pathExtension = dict[@"pathExtension"];
    }
    return self;
}

@end
