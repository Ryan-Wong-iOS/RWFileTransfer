//
//  RWStream.h
//  RWFileTransferDemo
//
//  Created by RyanWong on 2018/3/3.
//  Copyright © 2018年 RyanWong. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, RWStreamEvent) {
    RWStreamEventHasData,
    RWStreamEventHasSpace,
    RWStreamEventError,
    RWStreamEventEnd,
};

@class RWStream;
@protocol RWStreamDelegate <NSObject>

- (void)rwStream:(RWStream *)stream handleEvent:(RWStreamEvent)event;

@end

@interface RWStream : NSObject

@property (assign, nonatomic) id<RWStreamDelegate> delegate;

- (instancetype)initWithInputStream:(NSInputStream *)inputStream;
- (instancetype)initWithOutputStream:(NSOutputStream *)outputStream;

- (void)open;
- (void)close;
- (UInt32)readData:(uint8_t *)data maxLength:(UInt32)maxLength;
- (UInt32)writeData:(uint8_t *)data maxLength:(UInt32)maxLength;

@end
