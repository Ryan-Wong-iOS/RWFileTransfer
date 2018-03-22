//
//  RWTransferViewModel.m
//  RWFileTransferDemo
//
//  Created by RyanWong on 2018/3/2.
//  Copyright © 2018年 RyanWong. All rights reserved.
//

#import "RWTransferViewModel.h"
#import "RWDataTransfer.h"
#import "RWImageLoad.h"

static NSString *const RWTransferStatusReadyText = @"初始化";
static NSString *const RWTransferStatusPrepareText = @"准备中";
static NSString *const RWTransferStatusTransferText = @"传输中";
static NSString *const RWTransferStatusFinishText = @"完成";
static NSString *const RWTransferStatusCancelText = @"取消";
static NSString *const RWTransferStatusErrorText = @"错误";

@interface RWTransferViewModel()

@property (copy, nonatomic)RWPhotoModel *model;

@property (copy, nonatomic, readwrite)NSString *name;

@property (copy, nonatomic, readwrite)PHAsset *asset;

@property (assign, nonatomic, readwrite)float progressValue;

@property (copy, nonatomic, readwrite)NSString *statusText;

@property (copy, nonatomic, readwrite)NSString *fileType;

@property (copy, nonatomic, readwrite)NSString *pathExtension;

@end

@implementation RWTransferViewModel

- (instancetype) initWithModel:(RWPhotoModel *)model {
    self = [super init];
    if (self) {
        _model = model;
        _name = model.name;
        _asset = model.asset;
        _size = model.size;
        _progressValue = 0.0;
        _status = RWTransferStatusReady;
        _statusText = RWTransferStatusReadyText;
        _source = RWTransferSourceNone;
        _timestampText = [self getDefaultTimestamp];
        _fileType = model.fileType;
        _pathExtension = model.pathExtension;
    }
    return self;
}

- (NSData *)getTaskData {
    
    NSLock *lock = [[NSLock alloc] init];
    __block NSInteger tag = 0;
    while(true) {
        [lock lock];
        if (tag != 0) {
            break;
        }
        [[RWImageLoad shareLoad] getVideoInfoWithAsset:_asset completion:^(long long size, UIImage *image) {
            _size = size;
            tag = 1;
            [lock unlock];
        }];
    }
    
    NSDictionary *dict = @{
                           @"dataType":@(RWTransferDataTypeSendTaskInfo),
                           @"data":@{
                               @"name":_name,
                               @"size":@(_size),
                               @"timestamp":_timestampText,
                               @"fileType":_fileType,
                               @"pathExtension":_pathExtension
                               }
                           };
    
    NSData *data = [RWDataTransfer dictionaryToData:dict];
    return data;
}

- (void)setStatus:(RWTransferStatus)status {
    switch (status) {
        case RWTransferStatusReady:
            _statusText = RWTransferStatusReadyText;
            break;
            
        case RWTransferStatusPrepare:
            _statusText = RWTransferStatusPrepareText;
            break;
            
        case RWTransferStatusTransfer:
            _statusText = RWTransferStatusTransferText;
            break;
            
        case RWTransferStatusFinish:
            _statusText = RWTransferStatusFinishText;
            break;
            
        case RWTransferStatusCancel:
            _statusText = RWTransferStatusCancelText;
            break;
            
        case RWTransferStatusError:
            _statusText = RWTransferStatusErrorText;
            break;
            
        default:
            break;
    }
}

- (NSString *)getDefaultTimestamp {
    NSTimeInterval timestamp = [[NSDate date] timeIntervalSince1970];
    NSString *timestampText = [NSString stringWithFormat:@"%f", timestamp];
    return timestampText;
}

@end
