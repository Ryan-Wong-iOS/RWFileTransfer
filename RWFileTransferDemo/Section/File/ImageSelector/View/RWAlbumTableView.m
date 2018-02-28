//
//  RWAlbumTableView.m
//  RWFileTransferDemo
//
//  Created by RyanWong on 2018/2/27.
//  Copyright © 2018年 RyanWong. All rights reserved.
//

#import "RWAlbumTableView.h"

@interface RWAlbumTableView()<UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic)UITableView *tv;

@property (strong, nonatomic)NSMutableArray *albums;

@end

@implementation RWAlbumTableView

- (instancetype) initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}

- (void)setupView {
    
}

#pragma mark - TableView delegate datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.albums.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - Lazy load

- (UITableView *)tv {
    if (!_tv) {
        _tv = [[UITableView alloc] initWithFrame:self.frame style:UITableViewStylePlain];
        _tv.delegate = self;
        _tv.dataSource = self;
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
