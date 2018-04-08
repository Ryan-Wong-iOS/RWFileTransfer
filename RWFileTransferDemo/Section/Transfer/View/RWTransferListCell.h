//
//  RWTransferListCell.h
//  RWFileTransferDemo
//
//  Created by RyanWong on 2018/3/22.
//  Copyright © 2018年 RyanWong. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RWTransferViewModel;
@interface RWTransferListCell : UITableViewCell

- (void)bindViewModel:(RWTransferViewModel *)viewModel;

- (void)inNormalModel:(RWTransferViewModel *)viewModel;

- (void)inProgressModel:(RWTransferViewModel *)viewModel;

@end
