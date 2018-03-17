//
//  RWInputStream.m
//  RWFileTransferDemo
//
//  Created by RyanWong on 2018/3/3.
//  Copyright © 2018年 RyanWong. All rights reserved.
//

#import "RWInputStream.h"
#import "RWStream.h"
#import "RWFileManager.h"

UInt32 const kRWStreamReadMaxLength = 4096;

@interface RWInputStream()<RWStreamDelegate>

@property (strong, nonatomic)RWStream *stream;

@property (strong, nonatomic)NSThread *streamThread;

@property (strong, nonatomic)NSMutableData *appendData;

@property (strong, nonatomic)NSFileHandle *fileHandle;

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

- (void)stop
{
    [self performSelector:@selector(stopThread) onThread:self.streamThread withObject:nil waitUntilDone:YES];
}

- (void)stopThread
{
    [self.stream close];
    NSLog(@"Stop");
}

#pragma mark - RWStreamDelegate
- (void)rwStream:(RWStream *)stream handleEvent:(RWStreamEvent)event {
    switch (event) {
        case RWStreamEventHasData: {
            @autoreleasepool {
                uint8_t bytes[kRWStreamReadMaxLength];
                UInt32 length = [stream readData:bytes maxLength:kRWStreamReadMaxLength];
                NSData *data = [NSData dataWithBytes:(const void *)bytes length:length];
                [self.fileHandle seekToEndOfFile];
                [self.fileHandle writeData:data];
                NSLog(@"Transfering %d", (unsigned int)length);
            }
            break;
        }
            
        case RWStreamEventEnd:
            NSLog(@"Transfer End");
            self.appendData = nil;
            [self.fileHandle  synchronizeFile];
            [self.fileHandle  closeFile];
            if (_delegate && [_delegate respondsToSelector:@selector(inputStream:transferEndWithStreamName:filePath:)]) {
                [_delegate inputStream:self transferEndWithStreamName:_streamName filePath:[self getTmpFilePath]];
            }
            break;
            
        case RWStreamEventError:
            NSLog(@"Transfer Error");
            if (_delegate && [_delegate respondsToSelector:@selector(inputStream:transferErrorWithStreamName:)]) {
                [_delegate inputStream:self transferErrorWithStreamName:_streamName];
            }
            break;
            
        default:
            break;
    }
}

#pragma mark - Lazy load

-(NSMutableData *)appendData {
    if (!_appendData) {
        _appendData = [NSMutableData data];
    }
    return _appendData;
}

-(NSFileHandle *)fileHandle {
    if (!_fileHandle) {
        NSString *path = [self getTmpFilePath];
        [RWFileManager createBlankFileAtPath:path];
        _fileHandle = [NSFileHandle fileHandleForWritingAtPath:path];
    }
    return _fileHandle;
}

- (NSString *)getTmpFilePath {
    NSString *tmp = [RWFileManager tmpPath];
    NSString *path = [NSString stringWithFormat:@"%@%@", tmp, _streamName];
    return path;
}

@end
