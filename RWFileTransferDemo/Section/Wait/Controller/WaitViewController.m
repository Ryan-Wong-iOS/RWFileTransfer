//
//  WaitViewController.m
//  RWFileTransferDemo
//
//  Created by RyanWong on 2018/1/17.
//  Copyright © 2018年 RyanWong. All rights reserved.
//

#import "WaitViewController.h"
#import "RWBrowser.h"

@interface WaitViewController ()

@end

@implementation WaitViewController

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    
    [[RWBrowser shareInstance] stopWait];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"等待连接";
    
    [[RWBrowser shareInstance] startWaitForConnect];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
