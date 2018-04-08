//
//  RWVideoTableView.m
//  RWFileTransferDemo
//
//  Created by RyanWong on 2018/3/9.
//  Copyright © 2018年 RyanWong. All rights reserved.
//

#import "RWVideoTableView.h"
#import "RWVideoListViewCell.h"
#import "RWAlbumViewModel.h"

@interface RWVideoTableView()<UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) UITableView *tv;

@property (strong, nonatomic)NSMutableArray *albums;

@property (strong, nonatomic)RWAlbumViewModel *albumViewModel;

@end

@implementation RWVideoTableView

- (instancetype) initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupView];
    }
    return self;
}

- (void)setupView {
    [self addSubview:self.tv];
}

#pragma mark - TableView delegate datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _albumViewModel.allAssets.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    RWVideoListViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([RWVideoListViewCell class]) forIndexPath:indexPath];
    
    [cell bindViewModel:_albumViewModel.allAssets[indexPath.row]];
    
    __weak typeof(self) weakSelf = self;
    cell.selectAction = ^(BOOL selected) {
        if (selected) {
            [weakSelf.albumViewModel selectOne:indexPath.row];
        } else {
            [weakSelf.albumViewModel removeOne:indexPath.row];
        }
    };
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 70.0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - reload
- (void)reloadData {
    [_tv reloadData];
}

- (void)reloadWithData:(NSArray <RWAlbumViewModel *> *)data {
//    [self.albums removeAllObjects];
//    [self.albums setArray:data];
    _albumViewModel = data[0];
    [_tv reloadData];
}

#pragma mark - Lazy load

- (UITableView *)tv {
    if (!_tv) {
        _tv = [[UITableView alloc] initWithFrame:self.frame style:UITableViewStylePlain];
        _tv.delegate = self;
        _tv.dataSource = self;
        
        [_tv registerNib:[UINib nibWithNibName:NSStringFromClass([RWVideoListViewCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([RWVideoListViewCell class])];
    }
    return _tv;
}

- (NSMutableArray *)albums {
    if (!_albums) {
        _albums = [NSMutableArray array];
    }
    return _albums;
}

@end
