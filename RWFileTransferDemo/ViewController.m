//
//  ViewController.m
//  RWFileTransferDemo
//
//  Created by RyanWong on 2018/1/17.
//  Copyright © 2018年 RyanWong. All rights reserved.
//

#import "ViewController.h"
#import "SearchViewController.h"
#import "WaitViewController.h"
#import "RWBrowser.h"


#import "RWImageLoad.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSString *deviceName = [UIDevice currentDevice].name;
    [[RWBrowser shareInstance] setConfigurationWithName:deviceName Identifier:@"rw"];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)sendAction:(id)sender {
    SearchViewController *vc = [[SearchViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}
- (IBAction)receiveAction:(id)sender {
    WaitViewController *vc = [[WaitViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}
- (IBAction)checkAction:(id)sender {
    
    [[RWImageLoad shareLoad] getAlbumContentImage:YES contentVideo:NO completion:^(NSMutableArray *albums) {
        
    }];
}

@end
