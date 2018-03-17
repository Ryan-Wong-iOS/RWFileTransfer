//
//  RWVideoListViewController.m
//  RWFileTransferDemo
//
//  Created by RyanWong on 2018/3/9.
//  Copyright © 2018年 RyanWong. All rights reserved.
//

#import "RWVideoListViewController.h"
#import "RWAlbumListViewModel.h"
#import "RWVideoTableView.h"

@interface RWVideoListViewController ()

@property (strong, nonatomic)RWVideoTableView *tv;

@property (strong, nonatomic)RWAlbumListViewModel *viewModel;

@property (strong, nonatomic)UIButton *sendBtn;

@end

@implementation RWVideoListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.viewModel = (RWAlbumListViewModel *)self.baseViewModel;
    
    self.title = self.viewModel.title;
    
    [self.view addSubview:self.tv];
    
    [self.view addSubview:self.sendBtn];
    
    [self.viewModel loadAlbumDataContentType:RWAlbumListContentTypeVideo success:^(id responseObject) {
        NSLog(@"%@",self.viewModel.albums);
        [self.tv reloadWithData:self.viewModel.albums];
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

-(RWVideoTableView *)tv {
    if (!_tv) {
        _tv = [[RWVideoTableView alloc] initWithFrame:self.view.frame];
    }
    return _tv;
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
