//
//  RWOutputStream.m
//  RWFileTransferDemo
//
//  Created by RyanWong on 2018/3/3.
//  Copyright © 2018年 RyanWong. All rights reserved.
//

#import "RWOutputStream.h"
#import "RWStream.h"

#import "RWImageLoad.h"

@interface RWOutputStream()<RWStreamDelegate>

@property (strong, nonatomic)RWStream *stream;

@property (strong, nonatomic)NSOutputStream *outputStream;

@property (strong, nonatomic)NSThread *streamThread;

@property (strong, nonatomic)NSData *imageData;

@property (assign, nonatomic)long long sendSize;

@property (assign, nonatomic)long long totalSize;

@property (assign, nonatomic)BOOL readyForSend;

@end

@implementation RWOutputStream

- (instancetype)initWithOutputStream:(NSOutputStream *)outputStream {
    self = [super init];
    if (self) {
        self.stream = [[RWStream alloc] initWithOutputStream:outputStream];
        self.stream.delegate = self;
        self.readyForSend = NO;
        self.outputStream = outputStream;
    }
    return self;
}

- (void)start {
    if (![[NSThread currentThread] isMainThread]) {
        return [self performSelectorOnMainThread:@selector(start) withObject:nil waitUntilDone:YES];
    }
    
    NSLog(@"Start");
    self.streamThread = [[NSThread alloc] initWithTarget:self selector:@selector(run) object:nil];
    [self.streamThread start];
}

- (void)run {
    @autoreleasepool {
        [self.stream open];
        
        NSLog(@"Loop");
        
        while (self.readyForSend && [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]]);
        
        NSLog(@"Done");
    }
}

- (void)stop
{
    [self performSelector:@selector(stopThread) onThread:self.streamThread withObject:nil waitUntilDone:YES];
}

- (void)stopThread
{
    self.readyForSend = NO;
    [self.stream close];
    NSLog(@"Stop");
}

- (void)streamWithAsset:(id)asset {
    __weak typeof(self)weakSelf = self;
    [[RWImageLoad shareLoad] getPhotoDataWithAsset:asset completion:^(NSData *imageData, NSString *dataUTI, NSDictionary *info) {
        weakSelf.imageData = [NSData dataWithData:imageData];
        weakSelf.totalSize = _imageData.length;
        weakSelf.sendSize = 0;
        weakSelf.readyForSend = YES;
    }];
}

- (void)sendDataChunk {
    
//    while (_sendSize < _totalSize) {
        NSMutableData *data = [NSMutableData dataWithData:_imageData];
        uint8_t *readBytes = (uint8_t *)[data mutableBytes];
        readBytes += _sendSize;
        NSUInteger data_len = [data length];
        unsigned long long len = (data_len - _sendSize >= 1024) ? 1024 : (data_len - _sendSize);
        uint8_t buf[len];
        (void)memcpy(buf, readBytes, len);
        len = [self.stream writeData:(const uint8_t *)buf maxLength:(UInt32)len];
        _sendSize += len;
        NSLog(@"Sending : %u", (unsigned int)len);
        NSLog(@"Sending progress : %u / %u", (unsigned int)_sendSize, (unsigned int)_totalSize);
//    }
    
//    [self stop];
}

#pragma mark - RWStreamDelegate
- (void)rwStream:(RWStream *)stream handleEvent:(RWStreamEvent)event {
    switch (event) {
        case RWStreamEventHasSpace:{
            NSLog(@"Sending");
            
            [self sendDataChunk];
            break;
        }
            
        case RWStreamEventEnd:{
            NSLog(@"Send End");
            [self stop];
            if (_delegate && [_delegate respondsToSelector:@selector(outputStream:transferEndWithStreamName:)]) {
                [_delegate outputStream:self transferEndWithStreamName:_streamName];
            }
            break;
        }
            
        case RWStreamEventError:{
            NSLog(@"Send Error");
            [self stop];
            if (_delegate && [_delegate respondsToSelector:@selector(outputStream:transferErrorWithStreamName:)]) {
                [_delegate outputStream:self transferErrorWithStreamName:_streamName];
            }
            break;
        }
            
        default:
            break;
    }
}

@end
