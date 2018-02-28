//
//  RWImageLoad.m
//  RWFileTransferDemo
//
//  Created by RyanWong on 2018/2/26.
//  Copyright © 2018年 RyanWong. All rights reserved.
//

#import "RWImageLoad.h"
#import <Photos/Photos.h>

#import "RWAlbumModel.h"

static RWImageLoad *_instance = nil;
@implementation RWImageLoad

+ (instancetype)shareLoad {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[RWImageLoad alloc] init];
    });
    return _instance;
}

- (void)getAlbumContentImage:(BOOL)contentImage contentVideo:(BOOL)contentVideo  completion:(void (^)(NSMutableArray  *albums))completion
{
    
    PHFetchOptions *option = [[PHFetchOptions alloc] init];
    if (!contentVideo) option.predicate = [NSPredicate predicateWithFormat:@"mediaType == %ld", PHAssetMediaTypeImage];
    if (!contentImage) option.predicate = [NSPredicate predicateWithFormat:@"mediaType == %ld",
                                           PHAssetMediaTypeVideo];
    option.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:YES]];
    
    PHFetchResult<PHAssetCollection *>  *smartAlbums = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeAlbum subtype:PHAssetCollectionSubtypeAlbumRegular options:nil];
    
    __block NSMutableArray *albums = [[NSMutableArray alloc] initWithCapacity:smartAlbums.count];
    
    for (PHAssetCollection *collection in smartAlbums)
    {
        if (![collection isKindOfClass:[PHAssetCollection class]]) continue; // 有可能是PHCollectionList类的的对象，过滤掉
        PHFetchResult<PHAsset *>  *fetchResult = [PHAsset fetchAssetsInAssetCollection:collection options:option];
        RWAlbumModel *model = [self modelWithResult:fetchResult name:collection.localizedTitle];
        [albums addObject:model];
    }
    
    // 获得相机胶卷
    PHAssetCollection *cameraRoll = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum subtype:PHAssetCollectionSubtypeSmartAlbumUserLibrary options:nil].lastObject;
    PHFetchResult<PHAsset *>  *fetchResult = [PHAsset fetchAssetsInAssetCollection:cameraRoll options:option];
    RWAlbumModel *model = [self modelWithResult:fetchResult name:cameraRoll.localizedTitle];
    [albums insertObject:model atIndex:0];
    
    if (completion) {
        completion(albums);
    }
}

- (RWAlbumModel *)modelWithResult:(PHFetchResult<PHAsset *>*)result name:(NSString *)name {
    RWAlbumModel *album = [[RWAlbumModel alloc] init];
    album.title = name;
    album.result = result;
    album.count = result.count;
    return album;
}
@end
