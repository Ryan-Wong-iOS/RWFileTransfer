//
//  RWTransferListProgressCell.h
//  RWFileTransferDemo
//
//  Created by RyanWong on 2018/3/23.
//  Copyright © 2018年 RyanWong. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RWTransferViewModel;
@interface RWTransferListProgressCell : UITableViewCell

- (void)bindViewModel:(RWTransferViewModel *)viewModel;

@end
