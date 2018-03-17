//
//  RWVideoListViewCell.h
//  RWFileTransferDemo
//
//  Created by RyanWong on 2018/3/9.
//  Copyright © 2018年 RyanWong. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^RWVideoListViewCellSelectAction)(BOOL selected);

@class RWimageViewModel;
@interface RWVideoListViewCell : UITableViewCell

@property (copy, nonatomic) RWVideoListViewCellSelectAction selectAction;

- (void)bindViewModel:(RWimageViewModel *)viewModel;

@end
