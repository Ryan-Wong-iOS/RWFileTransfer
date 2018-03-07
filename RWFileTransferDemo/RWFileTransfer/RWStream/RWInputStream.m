//
//  RWInputStream.m
//  RWFileTransferDemo
//
//  Created by RyanWong on 2018/3/3.
//  Copyright © 2018年 RyanWong. All rights reserved.
//

#import "RWInputStream.h"
#import "RWStream.h"

UInt32 const kRWStreamReadMaxLength = 512;

@interface RWInputStream()<RWStreamDelegate>

@property (strong, nonatomic)RWStream *stream;

@property (strong, nonatomic)NSThread *streamThread;

@end

@implementation RWInputStream

- (instancetype)initWithInputStream:(NSInputStream *)inputStream {
    self = [super init];
    if (self) {
        self.stream = [[RWStream alloc] initWithInputStream:inputStream];
        self.stream.delegate = self;
    }
    return self;
}

- (void)start {
    if (![[NSThread currentThread] isMainThread]) {
        return [self performSelectorOnMainThread:@selector(start) withObject:nil waitUntilDone:YES];
    }
    
    self.streamThread = [[NSThread alloc] initWithTarget:self selector:@selector(run) object:nil];
    [self.streamThread start];
}

- (void)run {
    @autoreleasepool {
        [self.stream open];
        
        while ([[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]]);
    }
}

#pragma mark - RWStreamDelegate
- (void)rwStream:(RWStream *)stream handleEvent:(RWStreamEvent)event {
    switch (event) {
        case RWStreamEventHasSpace: {
            uint8_t bytes[kRWStreamReadMaxLength];
            UInt32 length = [stream readData:bytes maxLength:kRWStreamReadMaxLength];
            NSLog(@"Transfering %d", (unsigned int)length);
            break;
        }
            
        case RWStreamEventEnd:
            NSLog(@"Transfer End");
            break;
            
        case RWStreamEventError:
            NSLog(@"Transfer Error");
            break;
            
        default:
            break;
    }
}

@end
