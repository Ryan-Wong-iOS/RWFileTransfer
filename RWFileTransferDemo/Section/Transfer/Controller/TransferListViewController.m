//
//  TransferViewController.m
//  RWFileTransferDemo
//
//  Created by RyanWong on 2018/1/17.
//  Copyright © 2018年 RyanWong. All rights reserved.
//

#import "TransferListViewController.h"
#import "RWAlbumListViewController.h"
#import "RWTransferCenter.h"

@interface TransferListViewController ()

@end

@implementation TransferListViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    NSArray *array = [RWTransferCenter center].readyTaskDatas;
    NSLog(@"任务准备：%@", array);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIBarButtonItem *chooseBtn = [[UIBarButtonItem alloc] initWithTitle:@"选择文件" style:UIBarButtonItemStylePlain target:self action:@selector(chooseAction)];
    self.navigationItem.rightBarButtonItem = chooseBtn;
}

- (void)chooseAction {
    RWAlbumListViewModel *viewModel = [[RWAlbumListViewModel alloc] init];
    viewModel.title = @"选择相册";
    RWAlbumListViewController *vc = [[RWAlbumListViewController alloc] initWithViewModel:viewModel];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 0;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"tran" forIndexPath:indexPath];
    
    
    return cell;
}


@end
