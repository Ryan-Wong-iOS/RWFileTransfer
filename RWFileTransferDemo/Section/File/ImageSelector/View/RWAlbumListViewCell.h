//
//  RWAlbumListViewCell.h
//  RWFileTransferDemo
//
//  Created by RyanWong on 2018/2/28.
//  Copyright © 2018年 RyanWong. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RWAlbumViewModel;
@interface RWAlbumListViewCell : UITableViewCell

- (void)bindViewModel:(RWAlbumViewModel *)viewModel;

@end
