//
//  RWAlbumTableView.h
//  RWFileTransferDemo
//
//  Created by RyanWong on 2018/2/27.
//  Copyright © 2018年 RyanWong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RWAlbumTableView : UIView

- (instancetype) initWithViewController:(UIViewController *)vc frame:(CGRect)frame;

- (void)reloadData;

- (void)reloadWithData:(NSArray *)data;

@end
