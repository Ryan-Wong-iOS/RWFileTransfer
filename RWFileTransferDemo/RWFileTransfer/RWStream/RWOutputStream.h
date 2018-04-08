//
//  RWOutputStream.h
//  RWFileTransferDemo
//
//  Created by RyanWong on 2018/3/3.
//  Copyright © 2018年 RyanWong. All rights reserved.
//

#import <Foundation/Foundation.h>

@class RWOutputStream;
@protocol RWOutputStreamDelegate <NSObject>

- (void)outputStream:(RWOutputStream *)outputStream progress:(long long)progress;

- (void)outputStream:(RWOutputStream *)outputStream transferEndWithStreamName:(NSString *)name;

- (void)outputStream:(RWOutputStream *)outputStream transferErrorWithStreamName:(NSString *)name;

@end

@interface RWOutputStream : NSObject

@property (copy, nonatomic)NSString *streamName;

@property (assign, nonatomic)id <RWOutputStreamDelegate> delegate;

- (instancetype)initWithOutputStream:(NSOutputStream *)outputStream;

- (void)streamWithAsset:(id)asset fileType:(NSString *)fileType;

- (void)start;

- (void)stop;

@end
