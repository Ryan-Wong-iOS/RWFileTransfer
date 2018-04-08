//
//  RWTransferListView.m
//  RWFileTransferDemo
//
//  Created by RyanWong on 2018/3/22.
//  Copyright © 2018年 RyanWong. All rights reserved.
//

#import "RWTransferListView.h"
#import "RWTransferListCell.h"

#import "RWTransferViewModel.h"
#import "RWTransferCenter.h"

static NSString *const cellId = @"RWTransferListCell";
@interface RWTransferListView () <UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic)UITableView *tb;

@property (strong, nonatomic)RWTransferCenter *transferCenter;

@end

@implementation RWTransferListView

#pragma mark - TableView

-(instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupView];
    }
    return self;
}

-(void)setupView {
    [self addSubview:self.tb];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.transferCenter.allTaskDatas.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    RWTransferViewModel *taskViewModel = self.transferCenter.allTaskDatas[indexPath.row];
    RWTransferListCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId forIndexPath:indexPath];
    [cell bindViewModel:taskViewModel];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 70;
}

- (void)reloadTableView {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tb reloadData];
    });
}

- (void)reloadSingleCell:(NSInteger)index {
    dispatch_async(dispatch_get_main_queue(), ^{
        if (index >= 0) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
            RWTransferListCell *cell = [self.tb cellForRowAtIndexPath:indexPath];
            RWTransferViewModel *taskModel = self.transferCenter.allTaskDatas[index];
            [cell bindViewModel:taskModel];
        }
    });
}

- (void)reloadProgressCell:(NSInteger)index {
    dispatch_async(dispatch_get_main_queue(), ^{
        if (index >= 0) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
            RWTransferListCell *cell = [self.tb cellForRowAtIndexPath:indexPath];
            RWTransferViewModel *taskModel = self.transferCenter.allTaskDatas[index];
            [cell inProgressModel:taskModel];
        }
    });
}

#pragma mark - Lazy load

-(UITableView *)tb {
    if (!_tb) {
        _tb = [[UITableView alloc] initWithFrame:self.frame style:UITableViewStylePlain];
        _tb.delegate = self;
        _tb.dataSource = self;
        [_tb registerClass:[RWTransferListCell class] forCellReuseIdentifier:cellId];
    }
    return _tb;
}

-(RWTransferCenter *)transferCenter {
    return [RWTransferCenter center];
}

@end
