//
//  RWAlbumListViewController.m
//  RWFileTransferDemo
//
//  Created by RyanWong on 2018/2/28.
//  Copyright © 2018年 RyanWong. All rights reserved.
//

#import "RWAlbumListViewController.h"
#import "RWAlbumTableView.h"

@interface RWAlbumListViewController ()

@property (strong, nonatomic)RWAlbumListViewModel *viewModel;

@property (strong, nonatomic)RWAlbumTableView *albumTv;

@property (strong, nonatomic)UIButton *sendBtn;

@end

@implementation RWAlbumListViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [_albumTv reloadData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.viewModel = (RWAlbumListViewModel *)self.baseViewModel;
    
    self.title = self.viewModel.title;
    
    [self.view addSubview:self.albumTv];
    
    [self.view addSubview:self.sendBtn];
    
    [self.viewModel loadAlbumData:^(id responseObject) {
        NSLog(@"%@",self.viewModel.albums);
        [self.albumTv reloadWithData:self.viewModel.albums];
    } failure:^(NSError *error) {
        
    }];
}

- (void)sendAction {
    [self.viewModel submitAllTransferDatas];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(RWAlbumTableView *)albumTv {
    if (!_albumTv) {
        _albumTv = [[RWAlbumTableView alloc] initWithViewController:self frame:self.view.frame];
    }
    return _albumTv;
}

-(UIButton *)sendBtn {
    if (!_sendBtn) {
        _sendBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - 50, self.view.frame.size.width, 50)];
        [_sendBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        [_sendBtn setTitle:@"发送" forState:UIControlStateNormal];
        [_sendBtn addTarget:self action:@selector(sendAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _sendBtn;
}

@end
