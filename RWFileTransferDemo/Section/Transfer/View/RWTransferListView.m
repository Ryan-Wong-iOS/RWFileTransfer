//
//  RWTransferListView.m
//  RWFileTransferDemo
//
//  Created by RyanWong on 2018/3/22.
//  Copyright © 2018年 RyanWong. All rights reserved.
//

#import "RWTransferListView.h"
#import "RWTransferListCell.h"
#import "RWTransferListProgressCell.h"

#import "RWTransferViewModel.h"
#import "RWTransferCenter.h"

static NSString *const cellId = @"RWTransferListCell";
static NSString *const progressCellId = @"RWTransferListProgressCell";
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
    if (taskViewModel.status == RWTransferStatusTransfer) {
        RWTransferListProgressCell *cell = [tableView dequeueReusableCellWithIdentifier:progressCellId forIndexPath:indexPath];
        [cell bindViewModel:taskViewModel];
        return cell;
    } else {
        RWTransferListCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId forIndexPath:indexPath];
        [cell bindViewModel:taskViewModel];
        return cell;
    }
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
            [self.tb reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
        }
    });
}

- (void)reloadProgressCell:(NSInteger)index {
    dispatch_async(dispatch_get_main_queue(), ^{
        if (index >= 0) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
            id cell = [self.tb cellForRowAtIndexPath:indexPath];
            RWTransferViewModel *taskModel = self.transferCenter.allTaskDatas[index];
            if ([cell isKindOfClass:[RWTransferListProgressCell class]]) {
                RWTransferListProgressCell *cellTemp = (RWTransferListProgressCell *)cell;
                [cellTemp bindViewModel:taskModel];
            } else {
                RWTransferListCell *cellTemp = (RWTransferListCell *)cell;
                [cellTemp bindViewModel:taskModel];
            }
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
        [_tb registerClass:[RWTransferListProgressCell class] forCellReuseIdentifier:progressCellId];
    }
    return _tb;
}

-(RWTransferCenter *)transferCenter {
    return [RWTransferCenter center];
}

@end
