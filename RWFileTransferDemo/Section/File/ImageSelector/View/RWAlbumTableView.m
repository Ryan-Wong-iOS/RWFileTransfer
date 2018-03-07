//
//  RWAlbumTableView.m
//  RWFileTransferDemo
//
//  Created by RyanWong on 2018/2/27.
//  Copyright © 2018年 RyanWong. All rights reserved.
//

#import "RWAlbumTableView.h"
#import "RWAlbumModel.h"
#import "RWAlbumViewModel.h"
#import "RWAlbumListViewCell.h"
#import "RWImageSelectorViewModel.h"

#import "RWImageSelectorViewController.h"

@interface RWAlbumTableView()<UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic)UITableView *tv;

@property (strong, nonatomic)NSMutableArray *albums;

@property (strong, nonatomic)UIViewController *parentViewController;

@end

@implementation RWAlbumTableView

- (instancetype) initWithViewController:(UIViewController *)vc frame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _parentViewController = vc;
        [self setupView];
    }
    return self;
}

- (void)setupView {
    [self addSubview:self.tv];
}

#pragma mark - TableView delegate datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.albums.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    RWAlbumListViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([RWAlbumListViewCell class]) forIndexPath:indexPath];
    
    [cell bindViewModel:_albums[indexPath.row]];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50.0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    RWImageSelectorViewModel *imageSelectorViewModel = [[RWImageSelectorViewModel alloc] init];
    RWAlbumViewModel *albumViewModel = _albums[indexPath.row];
    imageSelectorViewModel.albumViewModel = albumViewModel;
    imageSelectorViewModel.title = albumViewModel.title;
    RWImageSelectorViewController *vc = [[RWImageSelectorViewController alloc] initWithViewModel:imageSelectorViewModel];
    [self.parentViewController.navigationController pushViewController:vc animated:YES];
}

#pragma mark - reload
- (void)reloadData {
    [_tv reloadData];
}

- (void)reloadWithData:(NSArray *)data {
    [self.albums removeAllObjects];
    [self.albums setArray:data];
    [_tv reloadData];
}

#pragma mark - Lazy load

- (UITableView *)tv {
    if (!_tv) {
        _tv = [[UITableView alloc] initWithFrame:self.frame style:UITableViewStylePlain];
        _tv.delegate = self;
        _tv.dataSource = self;
        
        [_tv registerNib:[UINib nibWithNibName:NSStringFromClass([RWAlbumListViewCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([RWAlbumListViewCell class])];
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
