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

@property (assign, nonatomic, readwrite)NSString *fileType;

@end

@implementation RWAlbumViewModel

- (instancetype)initWithModel:(RWAlbumModel *)model {
    self = [super init];
    if (self) {
        _albumModel = model;
        _title = model.title;
        _result = model.result;
        _count = model.count;
        _fileType = model.fileType;
        _allAssets = [self readAllAssets];
        _selectedAssets = [NSMutableArray array];
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
        photoModel.name = [self getFileNameWith:asset];
        photoModel.asset = asset;
        photoModel.fileType = _fileType;
        photoModel.pathExtension = [photoModel.name pathExtension];
        RWimageViewModel *imageViewModel = [[RWimageViewModel alloc] initWithModel:photoModel];
        [photos addObject:imageViewModel];
    }
    return photos;
}

- (NSString *)getFileNameWith:(PHAsset *)asset {
    NSString *name = [NSString stringWithFormat:@"%ld", (long)([[NSDate date] timeIntervalSince1970] * 10000)];
    name = [name stringByReplacingOccurrencesOfString:@"." withString:@"_"];
    NSString *pathExtension = [self getPathExtensionWith:asset];
    name = [NSString stringWithFormat:@"%@.%@", name, pathExtension];
    return name;
}

- (NSString *)getPathExtensionWith:(PHAsset *)asset {
    NSString *filename = [asset valueForKey:@"filename"];
    NSString *pathExtension = [filename pathExtension];
    return  pathExtension;
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
