//
//  RWAlbumListViewModel.m
//  RWFileTransferDemo
//
//  Created by RyanWong on 2018/2/28.
//  Copyright © 2018年 RyanWong. All rights reserved.
//

#import "RWAlbumListViewModel.h"
#import "RWAlbumViewModel.h"
#import "RWTransferCenter.h"

#import "RWImageLoad.h"

@interface RWAlbumListViewModel()

@property (strong, nonatomic, readwrite)NSArray <RWAlbumViewModel *> *albums;

@end

@implementation RWAlbumListViewModel

- (void)loadAlbumData:(void (^)(id))success failure:(void (^)(NSError *))failure {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.5f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        [[RWImageLoad shareLoad] getAlbumContentImage:YES contentVideo:NO completion:^(NSMutableArray *albums) {
            NSMutableArray *array = [NSMutableArray array];
            for (RWAlbumModel *model in albums) {
                RWAlbumViewModel *viewModel = [[RWAlbumViewModel alloc] initWithModel:model];
                [array addObject:viewModel];
            }
            self.albums = (NSArray *)array;
            !success?:success(nil);
        }];
    });
}

- (void)submitAllTransferDatas {
    NSMutableArray *array = [NSMutableArray array];
    for (RWAlbumViewModel *albums in _albums) {
        [array addObjectsFromArray:[albums returnSelectedModels]];
    }
    
    [[RWTransferCenter center] setupReadyTaskDatas:array];
}

-(NSArray<RWAlbumViewModel *> *)albums {
    if (!_albums) {
        _albums = [NSMutableArray array];
    }
    return _albums;
}

@end
