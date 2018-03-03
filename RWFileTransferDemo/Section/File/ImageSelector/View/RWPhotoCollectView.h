//
//  RWPhotoCollectView.h
//  RWFileTransferDemo
//
//  Created by RyanWong on 2018/3/1.
//  Copyright © 2018年 RyanWong. All rights reserved.
//

#import <UIKit/UIKit.h>
@class RWAlbumViewModel;
@interface RWPhotoCollectView : UIView

- (void)reloadWithData:(RWAlbumViewModel *)viewModel;

@end
