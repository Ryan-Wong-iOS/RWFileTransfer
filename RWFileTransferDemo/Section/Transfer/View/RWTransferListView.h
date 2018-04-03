//
//  RWTransferListView.h
//  RWFileTransferDemo
//
//  Created by RyanWong on 2018/3/22.
//  Copyright © 2018年 RyanWong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RWTransferListView : UIView

- (void)reloadTableView;

- (void)reloadSingleCell:(NSInteger)index;

- (void)reloadProgressCell:(NSInteger)index;

@end
