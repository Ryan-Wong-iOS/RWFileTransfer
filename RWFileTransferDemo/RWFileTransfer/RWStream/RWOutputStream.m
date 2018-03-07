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

- (void)streamWithAsset:(id)asset {
    [[RWImageLoad shareLoad] getPhotoDataWithAsset:asset completion:^(NSData *imageData, NSString *dataUTI, NSDictionary *info) {
        _imageData = imageData;
        _totalSize = _imageData.length;
        _sendSize = 0;
        _readyForSend = YES;
    }];
}

- (void)sendDataChunk {
    
    while (_sendSize >= _totalSize) {
        uint8_t *buffer = (Byte*)malloc(512);
        [_imageData getBytes:buffer length:512];
        NSData *sendData = [[NSData alloc] initWithBytesNoCopy:buffer length:512 freeWhenDone:YES];
        UInt32 length = (UInt32)sendData.length;
        [self.stream writeData:buffer maxLength:length];
    }
    [self.stream writeData:nil maxLength:0];
}

#pragma mark - RWStreamDelegate
- (void)rwStream:(RWStream *)stream handleEvent:(RWStreamEvent)event {
    switch (event) {
        case RWStreamEventHasSpace:{
            break;
        }
            
        case RWStreamEventEnd:{
            NSLog(@"Send End");
            break;
        }
            
        case RWStreamEventError:{
            NSLog(@"Send Error");
            break;
        }
            
        default:
            break;
    }
}

@end
