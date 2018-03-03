//
//  RWPhotoViewCell.h
//  RWFileTransferDemo
//
//  Created by RyanWong on 2018/3/1.
//  Copyright © 2018年 RyanWong. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^RWPhotoViewCellSelectAction)(BOOL selected);

@class RWimageViewModel;
@interface RWPhotoViewCell : UICollectionViewCell

@property (copy, nonatomic)RWPhotoViewCellSelectAction selectAction;

- (void)bindViewModel:(RWimageViewModel *)viewModel;

@end
