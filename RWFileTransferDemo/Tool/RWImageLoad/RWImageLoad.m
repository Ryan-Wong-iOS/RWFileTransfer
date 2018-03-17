//
//  RWImageLoad.m
//  RWFileTransferDemo
//
//  Created by RyanWong on 2018/2/26.
//  Copyright © 2018年 RyanWong. All rights reserved.
//

#import "RWImageLoad.h"
#import "RWConfig.h"
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
    
    if (!contentVideo) {
        for (PHAssetCollection *collection in smartAlbums)
        {
            if (![collection isKindOfClass:[PHAssetCollection class]]) continue; // 有可能是PHCollectionList类的的对象，过滤掉
            PHFetchResult<PHAsset *>  *fetchResult = [PHAsset fetchAssetsInAssetCollection:collection options:option];
            if (fetchResult.count > 0) {
                RWAlbumModel *model = [self modelWithResult:fetchResult name:collection.localizedTitle];
                model.fileType = 0;
                [albums addObject:model];
            }
        }
    }
    
    // 获得相机胶卷
    PHAssetCollection *cameraRoll = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum subtype:PHAssetCollectionSubtypeSmartAlbumUserLibrary options:nil].lastObject;
    PHFetchResult<PHAsset *>  *fetchResult = [PHAsset fetchAssetsInAssetCollection:cameraRoll options:option];
    if (fetchResult.count > 0) {
        RWAlbumModel *model = [self modelWithResult:fetchResult name:cameraRoll.localizedTitle];
        if (!contentVideo) {
            model.fileType = 0;
        } else {
            model.fileType = 1;
        }
        [albums insertObject:model atIndex:0];
    }
    
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

- (PHImageRequestID)getPhotoWithAsset:(id)asset photoWidth:(CGFloat)photoWidth completion:(void (^)(UIImage *photo,NSDictionary *info,BOOL isDegraded))completion progressHandler:(void (^)(double progress, NSError *error, BOOL *stop, NSDictionary *info))progressHandler networkAccessAllowed:(BOOL)networkAccessAllowed
{
    
    PHImageManager *manger = [PHImageManager defaultManager];
    int32_t imageRequestID = [manger requestImageForAsset:asset targetSize:CGSizeMake(([[UIScreen mainScreen] bounds].size.width-15)/3, ([[UIScreen mainScreen] bounds].size.width-15)/3) contentMode:PHImageContentModeAspectFill options:nil resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
        completion(result,info,true);
    }];
    return imageRequestID;
}

- (PHImageRequestID)getPhotoDataWithAsset:(id)asset completion:(void (^)(NSData *imageData, NSString *dataUTI, NSDictionary * info))completion {
    
    PHImageManager *manger = [PHImageManager defaultManager];
    PHImageRequestOptions *option = [[PHImageRequestOptions alloc] init];
    option.synchronous = YES;
    int32_t imageRequestID = [manger requestImageDataForAsset:asset options:option resultHandler:^(NSData * _Nullable imageData, NSString * _Nullable dataUTI, UIImageOrientation orientation, NSDictionary * _Nullable info) {
        UIImage* image = [UIImage imageWithData:imageData];
        imageData = UIImageJPEGRepresentation(image, 1.0);
        
        !completion?:completion(imageData, dataUTI, info);
        
    }];
    return imageRequestID;
}

- (PHImageRequestID)getVideoInfoWithAsset:(id)asset completion:(void (^)(long long size, UIImage *image))completion {
    return [self getVideoInfo:YES AndData:NO WithAsset:asset completion:^(long long size, UIImage *image, NSData *data) {
        !completion?:completion(size, image);
    }];
}

- (PHImageRequestID)getVideoDataWithAsset:(id)asset completion:(void (^)(NSData *data))completion {
    return [self getVideoInfo:NO AndData:YES WithAsset:asset completion:^(long long size, UIImage *image, NSData *data) {
        !completion?:completion(data);
    }];
}

- (PHImageRequestID)getVideoInfo:(BOOL)returnInfo AndData:(BOOL)returnData WithAsset:(id)asset completion:(void (^)(long long size, UIImage *image, NSData *data))completion {
    __weak typeof(self) weakSelf = self;
    PHVideoRequestOptions *options = [[PHVideoRequestOptions alloc] init];
    options.version = PHVideoRequestOptionsVersionOriginal;
    int32_t imageRequestID = [[PHImageManager defaultManager] requestAVAssetForVideo:asset options:options resultHandler:^(AVAsset *asset, AVAudioMix *audioMix, NSDictionary *info) {
         if ([asset isKindOfClass:[AVURLAsset class]]) {
             AVURLAsset* urlAsset = (AVURLAsset*)asset;
             if (returnInfo) {
                 NSNumber *size;
                 [urlAsset.URL getResourceValue:&size forKey:NSURLFileSizeKey error:nil];
                 
                 UIImage *image = [weakSelf getThumbnailImage:urlAsset];
                 image = [weakSelf imageWithImageSimple:image scaledToSize:CGSizeMake(150, 150)];
                 !completion?:completion([size longLongValue], image, nil);
             }
             
             if (returnData) {
                 NSError *error = nil;
                 NSData *data = [NSData dataWithContentsOfURL:urlAsset.URL options:NSDataReadingMappedIfSafe error:&error];
                 if (error) {
                     NSLog(@"视频错误 :%@", error);
                 }
                 NSLog(@"data length %ld", data.length);
                 !completion?:completion(0, nil, data);
             }
         }
    }];
    return imageRequestID;
}

- (UIImage *)getThumbnailImage:(id)object
{
    AVURLAsset *asset;
    if ([object isKindOfClass:[NSString class]]) {
        asset = [[AVURLAsset alloc] initWithURL:[NSURL fileURLWithPath:object] options:nil];
    } else if ([object isKindOfClass:[AVURLAsset class]]) {
        asset = (AVURLAsset *)object;
    }
    AVAssetImageGenerator *gen = [[AVAssetImageGenerator alloc] initWithAsset:asset];
    gen.appliesPreferredTrackTransform = YES;
    CMTime time = CMTimeMakeWithSeconds(0.0, 600);
    NSError *error = nil;
    CMTime actualTime;
    CGImageRef image = [gen copyCGImageAtTime:time actualTime:&actualTime error:&error];
    UIImage *thumb = [[UIImage alloc] initWithCGImage:image];
    CGImageRelease(image);
    return thumb;
}

- (UIImage*)imageWithImageSimple:(UIImage*)image scaledToSize:(CGSize)newSize
{
    CGSize oldSize = image.size;
    CGFloat radio = oldSize.width / oldSize.height;
    CGSize finalSize;
    if (radio < 1.0) {
        finalSize = CGSizeMake(newSize.width, newSize.width / radio);
    } else {
        finalSize = CGSizeMake(newSize.height / radio, newSize.height);
    }
    
    UIGraphicsBeginImageContext(newSize);
    [image drawInRect:CGRectMake(0,0,finalSize.width,finalSize.height)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

@end
