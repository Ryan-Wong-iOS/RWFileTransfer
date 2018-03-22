//
//  RWStringConfig.h
//  RWFileTransferDemo
//
//  Created by RyanWong on 2018/3/17.
//  Copyright © 2018年 RyanWong. All rights reserved.
//

#ifndef RWStringConfig_h
#define RWStringConfig_h

#import <Foundation/Foundation.h>

static NSString *const kFileTypePicture = @"picutre";

static NSString *const kFileTypeVideo = @"video";

typedef NS_ENUM(NSUInteger, RWTransferDataType) {
    RWTransferDataTypeSendTaskInfo,             //发送方：发送任务基本信息
    RWTransferDataTypeReceiveTaskInfo,          //接收方：反馈任务信息已接收
    RWTransferDataTypeReceiveProgress,          //接收方：反馈给发送方实际接收进度
    RWTransferDataTypeFinish,                   //接收方：完成接收
    RWTransferDataTypeError                     //发送方、接收方：发生错误
};

#endif /* RWStringConfig_h */
