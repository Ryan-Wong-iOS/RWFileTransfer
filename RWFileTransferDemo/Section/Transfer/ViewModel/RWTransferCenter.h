//
//  RWTransferCenter.h
//  RWFileTransferDemo
//
//  Created by RyanWong on 2018/3/3.
//  Copyright © 2018年 RyanWong. All rights reserved.
//

#import <Foundation/Foundation.h>

@class RWPhotoModel;
@interface RWTransferCenter : NSObject

@property (strong, nonatomic)NSMutableArray *readyTaskDatas;

@property (strong, nonatomic)NSMutableArray *allTaskDatas;

+ (instancetype)center;

- (void)setupReadyTaskDatas:(NSArray <RWPhotoModel *>*)datas;

@end
