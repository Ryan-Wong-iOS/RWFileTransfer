//
//  RWCommon.m
//  RWFileTransferDemo
//
//  Created by RyanWong on 2018/3/31.
//  Copyright © 2018年 RyanWong. All rights reserved.
//

#import "RWCommon.h"

@implementation RWCommon

+(NSString *)getFileSizeTextFromSize:(long long)fileSize {
    int sizeDig = 1024*1.0;
    
    const int GB = sizeDig * sizeDig * sizeDig;//定义GB的计算常量
    const int MB = sizeDig * sizeDig;//定义MB的计算常量
    const int KB = sizeDig;//定义KB的计算常量
    
    NSString *fileSizeText = @"";
    if (fileSize / GB >= 1) {
        fileSizeText = [NSString stringWithFormat:@"%.2fGB", (CGFloat)fileSize / (CGFloat)GB];
    }else if (fileSize / MB >= 1){
        fileSizeText = [NSString stringWithFormat:@"%.2fMB", (CGFloat)fileSize / (CGFloat)MB];
    } else if (fileSize / KB >= 1){
        fileSizeText = [NSString stringWithFormat:@"%.0fKB", (CGFloat)fileSize / (CGFloat)KB];
    }else{
        fileSizeText = [NSString stringWithFormat:@"%.0fB", (CGFloat)fileSize];
    }
    
    return fileSizeText;
}

@end
