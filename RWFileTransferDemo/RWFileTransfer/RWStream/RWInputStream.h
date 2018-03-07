//
//  RWInputStream.h
//  RWFileTransferDemo
//
//  Created by RyanWong on 2018/3/3.
//  Copyright © 2018年 RyanWong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RWInputStream : NSObject

- (instancetype)initWithInputStream:(NSInputStream *)inputStream;

- (void)start;

@end
