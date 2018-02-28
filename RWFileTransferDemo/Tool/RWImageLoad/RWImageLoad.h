//
//  RWImageLoad.h
//  RWFileTransferDemo
//
//  Created by RyanWong on 2018/2/26.
//  Copyright © 2018年 RyanWong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RWImageLoad : NSObject

+(instancetype)shareLoad;

- (void)getAlbumContentImage:(BOOL)contentImage contentVideo:(BOOL)contentVideo  completion:(void (^)(NSMutableArray  *albums))completion;

@end
