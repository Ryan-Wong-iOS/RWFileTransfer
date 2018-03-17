//
//  RWAlbumListViewModel.h
//  RWFileTransferDemo
//
//  Created by RyanWong on 2018/2/28.
//  Copyright © 2018年 RyanWong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RWBaseViewModel.h"

typedef NS_ENUM(NSUInteger, RWAlbumListContentType) {
    RWAlbumListContentTypePhoto,
    RWAlbumListContentTypeVideo,
};

@class RWAlbumViewModel;
@interface RWAlbumListViewModel : RWBaseViewModel

@property (strong, nonatomic, readonly)NSArray <RWAlbumViewModel *> *albums;

- (void)loadAlbumDataContentType:(RWAlbumListContentType)contentType success:(void (^)(id))success failure:(void (^)(NSError *))failure;

- (void)submitAllTransferDatas;

@end
