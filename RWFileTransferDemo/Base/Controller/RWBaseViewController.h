//
//  RWBaseViewController.h
//  RWFileTransferDemo
//
//  Created by RyanWong on 2018/2/28.
//  Copyright © 2018年 RyanWong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RWBaseViewController : UIViewController

@property (strong, nonatomic, readonly)id baseViewModel;

- (instancetype)initWithViewModel:(id)baseViewModel;

@end
