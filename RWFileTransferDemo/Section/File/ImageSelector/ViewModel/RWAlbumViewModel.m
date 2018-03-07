//
//  RWAlbumViewModel.m
//  RWFileTransferDemo
//
//  Created by RyanWong on 2018/2/27.
//  Copyright © 2018年 RyanWong. All rights reserved.
//

#import "RWAlbumViewModel.h"
#import "RWAlbumModel.h"
#import "RWPhotoModel.h"
#import "RWimageViewModel.h"

@interface RWAlbumViewModel()

@property (strong, nonatomic)RWAlbumModel *albumModel;

@property (copy, nonatomic, readwrite)NSString *title;

@property (copy, nonatomic, readwrite)PHFetchResult *result;

@property (assign, nonatomic, readwrite)NSInteger count;

@property (strong, nonatomic, readwrite)NSArray *allAssets;

@property (assign, nonatomic, readwrite)NSInteger selectedCount;

@end

@implementation RWAlbumViewModel

- (instancetype)initWithModel:(RWAlbumModel *)model {
    self = [super init];
    if (self) {
        self.albumModel = model;
        self.title = model.title;
        self.result = model.result;
        self.count = model.count;
        self.allAssets = [self readAllAssets];
        self.selectedAssets = [NSMutableArray array];
    }
    return self;
}

- (NSArray *)readAllAssets {
    NSMutableArray *photos = [NSMutableArray arrayWithCapacity:_result.count];
    NSRange range = NSMakeRange(0, _result.count);
    NSIndexSet *indexSet = [[NSIndexSet alloc] initWithIndexesInRange:range];
    NSArray *array = [[_result objectsAtIndexes:indexSet] mutableCopy];
    
    for (PHAsset *asset in array) {
        RWPhotoModel *photoModel = [[RWPhotoModel alloc] init];
        photoModel.name = [NSString stringWithFormat:@"%zd", (NSInteger)[[NSDate date] timeIntervalSince1970]];
        photoModel.asset = asset;
        RWimageViewModel *imageViewModel = [[RWimageViewModel alloc] initWithModel:photoModel];
        [photos addObject:imageViewModel];
    }
    return photos;
}

- (void)selectOne:(NSInteger)index {
    RWimageViewModel *imageViewModel = _allAssets[index];
    if (![_selectedAssets containsObject:imageViewModel]) {
        [_selectedAssets addObject:imageViewModel];
    }
}

- (void)selectedAll {
    _selectedAssets = [_allAssets mutableCopy];
    for (RWimageViewModel *viewModel in _selectedAssets) {
        viewModel.selected = YES;
    }
}

- (void)removeOne:(NSInteger)index {
    RWimageViewModel *imageViewModel = _allAssets[index];
    if ([_selectedAssets containsObject:imageViewModel]) {
        [_selectedAssets removeObject:imageViewModel];
    }
}

- (void)removeAll {
    for (RWimageViewModel *viewModel in _selectedAssets) {
        viewModel.selected = NO;
    }
    [_selectedAssets removeAllObjects];
}

- (BOOL)selected {
    if (self.count == self.selectedCount) {
        return YES;
    } else {
        return NO;
    }
}

- (NSInteger)selectedCount {
    return _selectedAssets.count;
}

-(NSArray *)returnSelectedModels {
    NSMutableArray *array = [NSMutableArray array];
    for (RWimageViewModel *imageModel in _selectedAssets) {
        [array addObject:imageModel.model];
    }
    return array;
}

@end
