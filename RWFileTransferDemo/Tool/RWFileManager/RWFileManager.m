//
//  RWFileManager.m
//  RWFileTransferDemo
//
//  Created by RyanWong on 2018/3/8.
//  Copyright © 2018年 RyanWong. All rights reserved.
//

#import "RWFileManager.h"

@implementation RWFileManager

+ (NSString *)picturesDirectory {
    NSString *picturesDirectory = [[self documentPath] stringByAppendingFormat:@"/%@", PictureDirectoryName];
    if (![self fileExistsAtPath:picturesDirectory]) {
        [self createDirectoryAtPath:picturesDirectory];
    }
    return picturesDirectory;
}

+ (NSString *)videosDirectory {
    NSString *videosDirectory = [[self documentPath] stringByAppendingFormat:@"/%@", VideoDirectoryName];
    if (![self fileExistsAtPath:videosDirectory]) {
        [self createDirectoryAtPath:videosDirectory];
    }
    return videosDirectory;
}

+ (NSString *)documentPath {
    return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
}

+ (NSString *)cachePath {
    return [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject];
}

+ (NSString *)tmpPath {
    return NSTemporaryDirectory();
}



+ (BOOL)fileExistsAtPath:(NSString *)path {
    return [[NSFileManager defaultManager] fileExistsAtPath:path];
}

+ (BOOL)createBlankFileAtPath:(NSString *)path {
    return [self createFileAtPath:path contents:nil];
}

+ (BOOL)createFileAtPath:(NSString *)path contents:(NSData *)data{
    return [[NSFileManager defaultManager] createFileAtPath:path contents:data attributes:nil];
}

+ (BOOL)createDirectoryAtPath:(NSString *)path {
    NSError *error;
    BOOL isSuccess = [[NSFileManager defaultManager] createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:&error];
    if (error) {
        NSLog(@"createDirectoryError : %@", error);
    }
    return isSuccess;
}

+ (BOOL)deleteFileAtPath:(NSString *)path {
    NSError *error;
    BOOL isSuccess = [[NSFileManager defaultManager] removeItemAtPath:path error:&error];
    if (error) {
        NSLog(@"deleteFileError : %@", error);
    }
    return isSuccess;
}

+ (NSArray *)subPathAtPath:(NSString *)path {
    NSError *error;
    NSArray *array = [[NSFileManager defaultManager] subpathsOfDirectoryAtPath:path error:&error];
    if (error) {
        NSLog(@"subpathsOfDirectoryError : %@", error);
    }
    return array;
}

@end
