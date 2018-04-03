//
//  RWTransferListViewModel.m
//  RWFileTransferDemo
//
//  Created by RyanWong on 2018/3/17.
//  Copyright © 2018年 RyanWong. All rights reserved.
//

#import "RWTransferListViewModel.h"
#import "RWDataTransfer.h"
#import "RWFileManager.h"
#import "RWFileHandle.h"

#import "RWInputStream.h"
#import "RWOutputStream.h"

#import "RWUserCenter.h"
#import "RWSession.h"
#import "RWTransferCenter.h"
#import "RWTransferViewModel.h"

@interface RWTransferListViewModel()

@property (strong, nonatomic)RWTransferCenter *center;
@property (strong, nonatomic)RWSession *session;

@property (assign, nonatomic)id target;

@property (copy, nonatomic)fromReceiveBeginBlock beginBlock;
@property (copy, nonatomic)fromReceiveProgressBlock progressBlock;
@property (copy, nonatomic)fromReceiveFinishBlock finishBlock;
@property (copy, nonatomic)fromReceiveErrorBlock errorBlock;

@end

@implementation RWTransferListViewModel

- (MCPeerID *)getFirstPeer {
    NSArray *peers = [self.session connectedPeers];
    if (peers.count) {
        return peers[0];
    }
    return nil;
}

- (NSInteger)getTaskIndexWithStreamName:(NSString *)streamName {
    NSInteger index = [self.center getTaskIndexWithTimestampText:streamName];
    return index;
}

#pragma mark - Send

- (void)sendPeerTaskInfo {
    RWLog(@"任务准备：%@", self.center.readyTaskDatas);
    if (self.center.readyTaskDatas.count <= 0) {
        return;
    }
    RWTransferViewModel *viewModel = [self.center currentReadyTask];
    if (viewModel.status != RWTransferStatusReady) {
        RWLog(@"目标任务不在准备状态：%@", viewModel);
        return;
    }
    MCPeerID *peer = [self getFirstPeer];
    if (peer) {
        NSData *data = [viewModel getTaskData];
        [self.session sendData:data toPeers:@[peer]];
    }
    
    viewModel.status = RWTransferStatusPrepare;
}

- (void)createSendStreamWithTarget:(id)target task:(RWTransferViewModel *)taskModel {
    if (self.center.readyTaskDatas.count <= 0) {
        return;
    }
    if (taskModel.status != RWTransferStatusPrepare) {
        RWLog(@"目标任务不在准备状态：%@", taskModel);
        return;
    }
    RWLog(@"准备发送 %@", taskModel.timestampText);
    NSArray *peers = [self.session connectedPeers];
    
    if (peers.count) {
        RWOutputStream *outputStream = [[RWOutputStream alloc] initWithOutputStream:[self.session outputStreamForPeer:peers[0] With:taskModel.timestampText]];
        outputStream.streamName = taskModel.timestampText;
        outputStream.delegate = target;
        [outputStream streamWithAsset:taskModel.asset];
        [outputStream start];
        
        taskModel.status = RWTransferStatusTransfer;
    }
}

- (void)nextReadyTask {
    [self.center nextReadyTask];
}

- (void)sendTaskCurrentProgressUpdate:(NSDictionary *)dict {
    
    NSString *timestampText = dict[@"timestamp"];
    long long progress = [dict[@"progress"] longLongValue];
    RWTransferViewModel *taskViewModel = [self.center getTaskWithTimestampText:timestampText];
    taskViewModel.transferSize = progress;
    
    if (_progressBlock) {
        _progressBlock(dict);
    }
}

- (void)sendTaskFinishUpdate:(NSDictionary *)dict {
    
    NSString *timestampText = dict[@"timestamp"];
    RWTransferViewModel *taskViewModel = [self.center getTaskWithTimestampText:timestampText];
    taskViewModel.status = RWTransferStatusFinish;
    
    if (_finishBlock) {
        _finishBlock(dict);
    }
}

- (void)sendTaskErrorUpdate:(NSDictionary *)dict {
    
    NSString *timestampText = dict[@"timestamp"];
    RWTransferViewModel *taskViewModel = [self.center getTaskWithTimestampText:timestampText];
    taskViewModel.status = RWTransferStatusError;
    
    if (_errorBlock) {
        _errorBlock(dict);
    }
}

#pragma mark - From Receiver

- (void)sendTaskBegin:(fromReceiveBeginBlock)beginBlock {
    _beginBlock = beginBlock;
}

- (void)sendTaskProgress:(fromReceiveProgressBlock)progressBlock {
    _progressBlock = progressBlock;
}

- (void)sendTaskFinish:(fromReceiveFinishBlock)finishBlock {
    _finishBlock = finishBlock;
}

- (void)sendTaskError:(fromReceiveErrorBlock)errorBlock {
    _errorBlock = errorBlock;
}

#pragma mark - Receive

- (void)handleReceiveData:(NSData *)data {
    NSDictionary *dict = [RWDataTransfer dataToDictionary:data];
    RWLog(@"收到数据 %@", dict);
    RWTransferDataType dataType = [dict[@"dataType"] integerValue];
    NSDictionary *dataDic = dict[@"data"];
    switch (dataType) {
        case RWTransferDataTypeSendTaskInfo:
        {
            [self receiveTaskInfo:dataDic];
            break;
        }
        case RWTransferDataTypeReceiveTaskInfo:
        {
            [self receiveTaskInfoCallback:dataDic];
            break;
        }
        case RWTransferDataTypeReceiveProgress:
        {
            [self sendTaskCurrentProgressUpdate:dataDic];
            break;
        }
        case RWTransferDataTypeFinish:
        {
            RWStatus(@"接收方接收完成");
            [self sendTaskFinishUpdate:dataDic];
            break;
        }
        case RWTransferDataTypeError:
        {
            RWStatus(@"接收方报错");
            [self sendTaskErrorUpdate:dataDic];
            break;
        }
            
        default:
            break;
    }
}

- (void)createReceiveStreamWithStream:(NSInputStream *)stream streamName:(NSString *)streamName {
    RWInputStream *inputStream = [[RWInputStream alloc] initWithInputStream:stream];
    inputStream.streamName = streamName;
    inputStream.delegate = _target;
    [inputStream start];
    
    //任务进入传输状态
    RWTransferViewModel *taskViewModel = [self.center getTaskWithTimestampText:streamName];
    taskViewModel.status = RWTransferStatusTransfer;
}

#pragma mark - Handle Receive Data
- (void)receiveTaskInfo:(NSDictionary *)data {
    RWStatus(@"接收到发送者发来的任务信息 %@", data);
    RWPhotoModel *model = [[RWPhotoModel alloc] initWithDictionary:data];
    NSString *timestampText = data[@"timestamp"];
    [self.center createReceiveTask:model withTimestampText:timestampText];
    
    NSDictionary *dict = @{
                           @"dataType":@(RWTransferDataTypeReceiveTaskInfo),
                           @"data":@{
                                   @"timestamp":timestampText
                                   }
                           };
    [self sendDataWithDictionary:dict];
    
    RWTransferViewModel *taskViewModel = [self.center getTaskWithTimestampText:timestampText];
    taskViewModel.status = RWTransferStatusPrepare;
}

- (void)receiveTaskInfoCallback:(NSDictionary *)data {
    NSString *timestampText = data[@"timestamp"];
    RWTransferViewModel *taskViewModel = [self.center getTaskWithTimestampText:timestampText];
    if (taskViewModel) {
        [self createSendStreamWithTarget:_target task:taskViewModel];
        !_beginBlock?:_beginBlock(data);
    }
    
    RWStatus(@"发送者收到接收者通知具体哪个任务 %@", timestampText);
}

#pragma mark - Tell Sender Task Status
- (void)receiveTaskProgressWithStreamName:(NSString *)name progress:(long long)progress {
    RWTransferViewModel *taskViewModel = [self.center getTaskWithTimestampText:name];
    taskViewModel.transferSize = progress;
    
    NSDictionary *dict = @{
                           @"dataType":@(RWTransferDataTypeReceiveProgress),
                           @"data":@{
                                   @"timestamp":name,
                                   @"progress":@(progress)
                                   }
                           };
    [self sendDataWithDictionary:dict];
}

- (void)receiveTaskFinishWithStreamName:(NSString *)name {
    RWTransferViewModel *taskViewModel = [self.center getTaskWithTimestampText:name];
    taskViewModel.status = RWTransferStatusFinish;
    
    NSDictionary *dict = @{
                           @"dataType":@(RWTransferDataTypeFinish),
                           @"data":@{
                                   @"timestamp":name,
                                   }
                           };
    [self sendDataWithDictionary:dict];
}

- (void)receiveTaskErrorWithStreamName:(NSString *)name {
    NSDictionary *dict = @{
                           @"dataType":@(RWTransferDataTypeError),
                           @"data":@{
                                   @"timestamp":name,
                                   }
                           };
    [self sendDataWithDictionary:dict];
}

- (void)sendDataWithDictionary:(NSDictionary *)dict {
    MCPeerID *peer = [self getFirstPeer];
    if (peer) {
        NSData *data = [RWDataTransfer dictionaryToData:dict];
        [self.session sendData:data toPeers:@[peer]];
    }
}

#pragma mark - Handler Receive File

- (void)handleTmpFile:(NSString *)filePath name:(NSString *)name {
    RWLog(@"传输完成 得到临时文件路径 ： %@ |||| %@", filePath, name);
    
    __weak typeof(self) weakSelf = self;
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        RWTransferViewModel *taskViewModel = [self.center getTaskWithTimestampText:name];
        NSString *pictureDirectory = [RWFileManager picturesDirectory];
        NSString *fileName = taskViewModel.name;
        NSString *targetPath = [NSString stringWithFormat:@"%@/%@", pictureDirectory, fileName];
        [weakSelf moveItemFrom:filePath to:targetPath];
    });
}

- (void)moveItemFrom:(NSString *)filePath to:(NSString *)targetPath {
    [RWFileHandle copyFileFromPath:filePath toPath:targetPath];
    [RWFileManager deleteFileAtPath:filePath];
}

#pragma mark - Lazy load

-(RWSession *)session {
    return [RWUserCenter center].session;
}

-(RWTransferCenter *)center {
    return [RWTransferCenter center];
}

@end
