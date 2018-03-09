//
//  RWFileHandle.h
//  RWFileTransferDemo
//
//  Created by RyanWong on 2018/3/8.
//  Copyright © 2018年 RyanWong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RWFileHandle : NSObject

+ (void)copyFileFromPath:(NSString *)path1 toPath:(NSString *)path2;

@end
