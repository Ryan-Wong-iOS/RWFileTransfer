//
//  RWAlbumViewModel.h
//  RWFileTransferDemo
//
//  Created by RyanWong on 2018/2/27.
//  Copyright © 2018年 RyanWong. All rights reserved.
//

#import <UIKit/UIKit.h>
@class PHFetchResult,RWAlbumModel;
@interface RWAlbumViewModel : UIView

@property (copy, nonatomic)NSString *title;

@property (strong, nonatomic)PHFetchResult *result;

@property (assign, nonatomic)NSInteger count;

- (instancetype)initWithModel:(RWAlbumModel *)model;

@end
