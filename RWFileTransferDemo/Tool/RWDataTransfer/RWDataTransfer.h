//
//  RWDataTransfer.h
//  RWFileTransferDemo
//
//  Created by RyanWong on 2018/3/17.
//  Copyright © 2018年 RyanWong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RWDataTransfer : NSObject

+ (NSData *)dictionaryToData:(NSDictionary *)dict;

+ (NSDictionary *)dataToDictionary:(NSData *)data;

@end
