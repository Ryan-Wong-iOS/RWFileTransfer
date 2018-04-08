//
//  RWUserCenter.m
//  RWFileTransferDemo
//
//  Created by RyanWong on 2018/1/17.
//  Copyright © 2018年 RyanWong. All rights reserved.
//

#import "RWUserCenter.h"

static RWUserCenter *_instance = nil;
@implementation RWUserCenter

+ (instancetype)center {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[RWUserCenter alloc] init];
    });
    return _instance;
}

- (void)remove {
    self.name = nil;
    self.identifier = nil;
    self.myPeerID = nil;
    self.session = nil;
}

@end
