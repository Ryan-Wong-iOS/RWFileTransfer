//
//  RWAlbumListViewController.m
//  RWFileTransferDemo
//
//  Created by RyanWong on 2018/2/28.
//  Copyright © 2018年 RyanWong. All rights reserved.
//

#import "RWAlbumListViewController.h"
#import "RWAlbumTableView.h"
#import "RWAlbumListViewModel.h"

@interface RWAlbumListViewController ()

@property (strong, nonatomic)RWAlbumListViewModel *viewModel;

@property (strong, nonatomic)RWAlbumTableView *albumTv;

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
    
    [self.viewModel loadAlbumData:^(id responseObject) {
        NSLog(@"%@",self.viewModel.albums);
        [self.albumTv reloadWithData:self.viewModel.albums];
    } failure:^(NSError *error) {
        
    }];
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

@end
