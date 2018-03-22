//
//  SearchViewController.m
//  RWFileTransferDemo
//
//  Created by RyanWong on 2018/1/17.
//  Copyright © 2018年 RyanWong. All rights reserved.
//

#import "SearchViewController.h"
#import "RWBrowser.h"
#import "RWSession.h"
#import "RWUserCenter.h"
#import "TransferListViewController.h"

@interface SearchViewController ()

@property (strong, nonatomic)NSMutableArray *peerArray;

@end

@implementation SearchViewController

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    
    [[RWBrowser shareInstance] stopSearch];
    [RWSession kickPeer:[RWUserCenter center].myPeerID];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [[RWUserCenter center].session.session disconnect];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(connect) name:kRWSessionStateConnectedNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notConnect) name:kRWSessionStateNotConnectedNotification object:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"搜索设备";
    
    NSString *deviceName = [UIDevice currentDevice].name;
    [[RWBrowser shareInstance] setConfigurationWithName:deviceName Identifier:@"rw"];
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"PeerIdCell"];
    
    [[RWBrowser shareInstance] startSearchNearbyService];
    [RWBrowser shareInstance].nearbyPeerBlock = ^(NSArray<MCPeerID *> *peerArray) {
        [self.peerArray setArray:peerArray];
        [self.tableView reloadData];
    };
}

- (void)connect {
    dispatch_async(dispatch_get_main_queue(), ^{
        RWTransferListViewModel *vm = [[RWTransferListViewModel alloc] init];
        vm.title = @"传输圈";
        TransferListViewController *vc = [[TransferListViewController alloc] initWithViewModel:vm];
        [self.navigationController pushViewController:vc animated:YES];
    });
}

- (void)notConnect {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.navigationController popViewControllerAnimated:YES];
    });
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.peerArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PeerIdCell" forIndexPath:indexPath];
    MCPeerID *peerId = self.peerArray[indexPath.row];
    cell.textLabel.text = peerId.displayName;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    MCPeerID *peerId = self.peerArray[indexPath.row];
    [[RWBrowser shareInstance] invitePeer:peerId];
}

- (NSMutableArray *)peerArray {
    if (!_peerArray) {
        _peerArray = [NSMutableArray array];
    }
    return _peerArray;
}

@end
