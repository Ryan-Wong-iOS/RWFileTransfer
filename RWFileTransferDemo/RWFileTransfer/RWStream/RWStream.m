//
//  RWStream.m
//  RWFileTransferDemo
//
//  Created by RyanWong on 2018/3/3.
//  Copyright © 2018年 RyanWong. All rights reserved.
//

#import "RWStream.h"

@interface RWStream()<NSStreamDelegate>

@end

@implementation RWStream

- (instancetype) initWithInputStream:(NSInputStream *)inputStream {
    self = [super init];
    if (self) {
        self.stream = inputStream;
    }
    return self;
}

- (instancetype) initWithOutputStream:(NSOutputStream *)outputStream {
    self = [super init];
    if (self) {
        self.stream = outputStream;
    }
    return self;
}

- (void)open {
    self.stream.delegate = self;
    [self.stream scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
    [self.stream open];
}

- (void)stream:(NSStream *)aStream handleEvent:(NSStreamEvent)eventCode {
    switch (eventCode) {
        case NSStreamEventHasBytesAvailable:
            if (_delegate && [_delegate respondsToSelector:@selector(rwStream:handleEvent:)]) {
                [_delegate rwStream:self handleEvent:RWStreamEventHasData];
            }
            break;
            
        case NSStreamEventHasSpaceAvailable:
            if (_delegate && [_delegate respondsToSelector:@selector(rwStream:handleEvent:)]) {
                [_delegate rwStream:self handleEvent:RWStreamEventHasSpace];
            }
            break;
            
        case NSStreamEventErrorOccurred:
            if (_delegate && [_delegate respondsToSelector:@selector(rwStream:handleEvent:)]) {
                [_delegate rwStream:self handleEvent:RWStreamEventError];
            }
            break;
            
        case NSStreamEventEndEncountered:
            if (_delegate && [_delegate respondsToSelector:@selector(rwStream:handleEvent:)]) {
                [_delegate rwStream:self handleEvent:RWStreamEventEnd];
            }
            break;
            
        default:
            break;
    }
}

- (UInt32)readData:(uint8_t *)data maxLength:(UInt32)maxLength {
    return (UInt32)[(NSInputStream *)self.stream read:data maxLength:maxLength];
}

- (UInt32)writeData:(const uint8_t *)data maxLength:(UInt32)maxLength {
    return (UInt32)[(NSOutputStream *)self.stream write:data maxLength:maxLength];
}

- (void)close {
    [self.stream close];
    self.stream.delegate = nil;
    [self.stream removeFromRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
}

- (void)dealloc {
    RWStatus(@"Stream 销毁");
    if (self.stream) {
        [self close];
    }
    if (self.delegate) {
        self.delegate = nil;
    }
}

@end
