//
//  RWFileHandle.m
//  RWFileTransferDemo
//
//  Created by RyanWong on 2018/3/8.
//  Copyright © 2018年 RyanWong. All rights reserved.
//

#import "RWFileHandle.h"
#import "RWFileManager.h"

@implementation RWFileHandle

+ (void)copyFileFromPath:(NSString *)path1 toPath:(NSString *)path2
{
    NSFileHandle * fh1 = [NSFileHandle fileHandleForReadingAtPath:path1];//读到内存
    [[NSFileManager defaultManager] createFileAtPath:path2 contents:nil attributes:nil];//写之前必须有该文件
    NSFileHandle * fh2 = [NSFileHandle fileHandleForWritingAtPath:path2];//写到文件
    NSData * _data = nil;
    unsigned long long ret = [fh1 seekToEndOfFile];//返回文件大小
    if (ret < 1024 * 1024 * 5) {//小于5M的文件一次读写
        [fh1 seekToFileOffset:0];
        _data = [fh1 readDataToEndOfFile];
        [fh2 writeData:_data];
    }else{
        NSUInteger n = ret / (1024 * 1024 * 5);
        if (ret % (1024 * 1024 * 5) != 0) {
            n++;
        }
        NSUInteger offset = 0;
        NSUInteger size = 1024 * 1024 * 5;
        for (NSUInteger i = 0; i < n - 1; i++) {
            //大于5M的文件多次读写
            [fh1 seekToFileOffset:offset];
            @autoreleasepool {
                /*该自动释放池必须要有否则内存一会就爆了
                 原因在于readDataOfLength方法返回了一个自动释放的对象,它只能在遇到自动释放池的时候才释放.如果不手动写这个自动释放池,会导致_data指向的对象不能及时释放,最终导致内存爆了.
                 */
                _data = [fh1 readDataOfLength:size];
                [fh2 seekToEndOfFile];
                [fh2 writeData:_data];
                NSLog(@"%lu/%lu", i + 1, n - 1);
            }
            offset += size;
        }
        //最后一次剩余的字节
        [fh1 seekToFileOffset:offset];
        _data = [fh1 readDataToEndOfFile];
        [fh2 seekToEndOfFile];
        [fh2 writeData:_data];
    }
    [fh1 closeFile];
    [fh2 closeFile];
}

@end
