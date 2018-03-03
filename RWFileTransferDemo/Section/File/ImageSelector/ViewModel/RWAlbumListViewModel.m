//
//  RWAlbumListViewModel.m
//  RWFileTransferDemo
//
//  Created by RyanWong on 2018/2/28.
//  Copyright © 2018年 RyanWong. All rights reserved.
//

#import "RWAlbumListViewModel.h"
#import "RWAlbumViewModel.h"

#import "RWImageLoad.h"

@interface RWAlbumListViewModel()

@property (strong, nonatomic, readwrite)NSArray <RWAlbumViewModel *> *albums;

@end

@implementation RWAlbumListViewModel

- (void)loadAlbumData:(void (^)(id))success failure:(void (^)(NSError *))failure {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.5f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        [[RWImageLoad shareLoad] getAlbumContentImage:YES contentVideo:NO completion:^(NSMutableArray *albums) {
            self.albums = (NSArray *)albums;
            !success?:success(nil);
        }];
        
    });
}

@end
