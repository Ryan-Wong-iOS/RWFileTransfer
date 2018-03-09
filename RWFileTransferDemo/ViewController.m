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
#import "RWAlbumListViewController.h"
#import "RWAlbumListViewModel.h"
#import "RWBrowser.h"


#import "RWImageLoad.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
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
    RWAlbumListViewModel *viewModel = [[RWAlbumListViewModel alloc] init];
    viewModel.title = @"选择相册";
    RWAlbumListViewController *vc = [[RWAlbumListViewController alloc] initWithViewModel:viewModel];
    [self.navigationController pushViewController:vc animated:YES];
}

@end
