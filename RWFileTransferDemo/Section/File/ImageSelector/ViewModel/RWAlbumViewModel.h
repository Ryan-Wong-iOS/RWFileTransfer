//
//  RWAlbumViewModel.h
//  RWFileTransferDemo
//
//  Created by RyanWong on 2018/2/27.
//  Copyright © 2018年 RyanWong. All rights reserved.
//

#import <UIKit/UIKit.h>
@class PHFetchResult,RWAlbumModel;
@interface RWAlbumViewModel : NSObject

@property (copy, nonatomic, readonly)NSString *title;

@property (copy, nonatomic, readonly)PHFetchResult *result;

@property (assign, nonatomic, readonly)NSInteger count;

@property (strong, nonatomic, readonly)NSArray *allAssets;

@property (strong, nonatomic, readwrite)NSMutableArray *selectedAssets;

@property (assign, nonatomic, readonly)NSInteger selectedCount;

@property (assign, nonatomic, readonly)BOOL selected;

- (instancetype)initWithModel:(RWAlbumModel *)model;

- (void)selectOne:(NSInteger)index;

- (void)selectedAll;

- (void)removeOne:(NSInteger)index;

- (void)removeAll;

- (NSArray *)returnSelectedModels;

@end
