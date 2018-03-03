//
//  RWImageSelectorViewModel.h
//  RWFileTransferDemo
//
//  Created by RyanWong on 2018/3/1.
//  Copyright © 2018年 RyanWong. All rights reserved.
//

#import "RWBaseViewModel.h"

@class RWAlbumViewModel;
@interface RWImageSelectorViewModel : RWBaseViewModel

@property (strong, nonatomic)RWAlbumViewModel *albumViewModel;

@end
