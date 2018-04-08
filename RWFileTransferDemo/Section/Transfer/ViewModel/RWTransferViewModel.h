//
//  RWTransferViewModel.h
//  RWFileTransferDemo
//
//  Created by RyanWong on 2018/3/2.
//  Copyright © 2018年 RyanWong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RWPhotoModel.h"
#import <Photos/PHAsset.h>

typedef NS_ENUM(NSUInteger, RWTransferStatus) {
    RWTransferStatusReady = 0,      //任务初始状态
    RWTransferStatusPrepare,        //任务准备状态 个别任务在发送前需要时间进行特别处理
    RWTransferStatusTransfer,       //任务传输状态
    RWTransferStatusFinish,         //任务完成状态
    
    RWTransferStatusCancel = 99,    //任务取消状态
    RWTransferStatusError = 999,    //任务错误状态
};

typedef NS_ENUM(NSUInteger, RWTransferSource) {
    RWTransferSourceNone,
    RWTransferSourceMine,
    RWTransferSourceOther,
};

@interface RWTransferViewModel : NSObject

@property (copy, nonatomic, readonly)NSString *name;

@property (copy, nonatomic, readonly)PHAsset *asset;

@property (copy, nonatomic)NSString *sandboxPath;

@property (assign, nonatomic)long long size;

@property (assign, nonatomic)long long transferSize;

@property (assign, nonatomic, readonly)float progressValue;

@property (assign, nonatomic)RWTransferStatus status;

@property (copy, nonatomic, readonly)NSString *statusText;

@property (assign, nonatomic)RWTransferSource source;

@property (copy, nonatomic)NSString *timestampText;

@property (copy, nonatomic, readonly)NSString *fileType;

@property (copy, nonatomic, readonly)NSString *pathExtension;

@property (strong, nonatomic)UIImage *cover;

- (instancetype) initWithModel:(RWPhotoModel *)model;

- (NSData *)getTaskData;

- (void)loadImageDataWithPhotoWidth:(CGFloat)photoWidth success:(void(^)(id))success failure:(void (^)(NSError *))failure;

- (void)loadSandBoxImageWithIsCoverSize:(BOOL)isCoverSize completion:(void(^)(UIImage *coverImage))completion;

@end
