//
//  RWAlbumListViewModel.h
//  RWFileTransferDemo
//
//  Created by RyanWong on 2018/2/28.
//  Copyright © 2018年 RyanWong. All rights reserved.
//

#import <Foundation/Foundation.h>
@class RWAlbumViewModel;
@interface RWAlbumListViewModel : NSObject

@property (strong, nonatomic)NSArray <RWAlbumViewModel *> *albums;

@end
