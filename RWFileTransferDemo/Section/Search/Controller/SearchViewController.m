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
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [[RWUserCenter center].session.session disconnect];
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
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(connect) name:kRWSessionStateConnectedNotification object:nil];
}

- (void)connect {
    dispatch_async(dispatch_get_main_queue(), ^{
        TransferListViewController *vc = [[TransferListViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
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
