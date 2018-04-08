//
//  RWTransferCenter.h
//  RWFileTransferDemo
//
//  Created by RyanWong on 2018/3/3.
//  Copyright © 2018年 RyanWong. All rights reserved.
//

#import <Foundation/Foundation.h>

@class RWPhotoModel,RWTransferViewModel;
@interface RWTransferCenter : NSObject

@property (strong, nonatomic)NSMutableArray <RWTransferViewModel *>*readyTaskDatas;

@property (strong, nonatomic)NSMutableArray <RWTransferViewModel *>*allTaskDatas;

+ (instancetype)center;

- (void)setupReadyTaskDatas:(NSArray <RWPhotoModel *>*)datas;

- (RWTransferViewModel *)currentReadyTask;

- (RWTransferViewModel *)getTaskWithTimestampText:(NSString *)timestampText;

- (NSInteger)getTaskIndexWithTimestampText:(NSString *)timestampText;

- (void)nextReadyTask;

- (void)createReceiveTask:(RWPhotoModel *)model withTimestampText:(NSString *)timestampText;

- (void)removeAllTaskData;

@end
