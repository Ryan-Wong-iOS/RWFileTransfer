//
//  RWVideoTableView.h
//  RWFileTransferDemo
//
//  Created by RyanWong on 2018/3/9.
//  Copyright © 2018年 RyanWong. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RWAlbumViewModel;
@interface RWVideoTableView : UIView

- (void)reloadWithData:(NSArray <RWAlbumViewModel *> *)data;

@end
