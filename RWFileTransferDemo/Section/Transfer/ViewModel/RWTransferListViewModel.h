//
//  RWTransferListViewModel.h
//  RWFileTransferDemo
//
//  Created by RyanWong on 2018/3/17.
//  Copyright © 2018年 RyanWong. All rights reserved.
//

#import "RWBaseViewModel.h"

typedef void(^fromReceiveBeginBlock)(NSDictionary *dict);
typedef void(^fromReceiveProgressBlock)(NSDictionary *dict);
typedef void(^fromReceiveFinishBlock)(NSDictionary *dict);
typedef void(^fromReceiveErrorBlock)(NSDictionary *dict);
typedef void(^fromReceiveCancelBlock)(NSDictionary *dict);

@interface RWTransferListViewModel : RWBaseViewModel

- (void)setTarget:(id)target;

- (NSInteger)getTaskIndexWithStreamName:(NSString *)streamName;

#pragma mark - Sender

- (void)sendPeerTaskInfo;

- (void)nextReadyTask;

#pragma mark - From Receiver

- (void)sendTaskBegin:(fromReceiveBeginBlock)beginBlock;

- (void)sendTaskProgress:(fromReceiveProgressBlock)progressBlock;

- (void)sendTaskFinish:(fromReceiveFinishBlock)finishBlock;

- (void)sendTaskError:(fromReceiveErrorBlock)errorBlock;

#pragma mark - Receiver

- (void)handleReceiveData:(NSData *)data;

- (void)createReceiveStreamWithStream:(NSInputStream *)stream streamName:(NSString *)streamName;

#pragma mark - Tell Sender Task Status

- (void)receiveTaskProgressWithStreamName:(NSString *)streamName progress:(long long)progress;

- (void)receiveTaskFinishWithStreamName:(NSString *)streamName;

- (void)receiveTaskErrorWithStreamName:(NSString *)streamName;

#pragma mark - Common

- (void)cancelTaskWithStreamName:(NSString *)streamName;

- (void)sendTaskCancel:(fromReceiveCancelBlock)cancelBlock;

#pragma mark - Handler Receive File

- (void)handleTmpFile:(NSString *)filePath name:(NSString *)name completion:(void(^)(NSString *targetName))completion;

@end
