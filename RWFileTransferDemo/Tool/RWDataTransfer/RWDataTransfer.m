//
//  RWDataTransfer.m
//  RWFileTransferDemo
//
//  Created by RyanWong on 2018/3/17.
//  Copyright © 2018年 RyanWong. All rights reserved.
//

#import "RWDataTransfer.h"

@implementation RWDataTransfer

+ (NSData *)dictionaryToData:(NSDictionary *)dict {
    NSError *error;
    NSData *data = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:&error];
    if (error) {
        RWError(@"%@", [error userInfo].description);
    }
    return data;
}

+ (NSDictionary *)dataToDictionary:(NSData *)data {
    NSError *error;
    NSDictionary *dictionary =[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&error];
    if (error) {
        RWError(@"%@", [error userInfo].description);
    }
    return dictionary;
}

@end
