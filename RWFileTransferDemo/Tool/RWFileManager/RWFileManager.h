//
//  RWFileManager.h
//  RWFileTransferDemo
//
//  Created by RyanWong on 2018/3/8.
//  Copyright © 2018年 RyanWong. All rights reserved.
//

#import <Foundation/Foundation.h>

static NSString *const PictureDirectoryName = @"pictures";

static NSString *const VideoDirectoryName = @"videos";

@interface RWFileManager : NSObject


+ (NSString *)picturesDirectory;

+ (NSString *)videosDirectory;

+ (NSString *)documentPath;

+ (NSString *)cachePath;

+ (NSString *)tmpPath;


+ (BOOL)fileExistsAtPath:(NSString *)path;

+ (BOOL)createBlankFileAtPath:(NSString *)path;

+ (BOOL)createFileAtPath:(NSString *)path contents:(NSData *)data;

+ (BOOL)createDirectoryAtPath:(NSString *)path;

+ (BOOL)deleteFileAtPath:(NSString *)path;

+ (NSArray *)subPathAtPath:(NSString *)path;

@end
