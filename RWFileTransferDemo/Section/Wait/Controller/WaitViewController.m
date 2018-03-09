//
//  WaitViewController.m
//  RWFileTransferDemo
//
//  Created by RyanWong on 2018/1/17.
//  Copyright © 2018年 RyanWong. All rights reserved.
//

#import "WaitViewController.h"
#import "RWBrowser.h"
#import "RWSession.h"
#import "RWUserCenter.h"
#import "TransferListViewController.h"

@interface WaitViewController ()

@end

@implementation WaitViewController

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    
    [[RWBrowser shareInstance] stopWait];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [[RWUserCenter center].session.session disconnect];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"等待连接";
    
    NSString *deviceName = [UIDevice currentDevice].name;
    [[RWBrowser shareInstance] setConfigurationWithName:deviceName Identifier:@"rw"];
    
    [[RWBrowser shareInstance] startWaitForConnect];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(connect) name:kRWSessionStateConnectedNotification object:nil];
}

- (void)connect {
    dispatch_async(dispatch_get_main_queue(), ^{
        TransferListViewController *vc = [[TransferListViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    });
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
