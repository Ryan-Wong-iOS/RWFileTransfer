//
//  RWBrower.m
//  RWFileTransferDemo
//
//  Created by RyanWong on 2018/1/17.
//  Copyright © 2018年 RyanWong. All rights reserved.
//

#import "RWBrowser.h"
#import <MultipeerConnectivity/MultipeerConnectivity.h>
#import "RWSessionManager.h"
#import "RWUserCenter.h"

@interface RWBrowser()<MCNearbyServiceBrowserDelegate, MCNearbyServiceAdvertiserDelegate>

@property (strong, nonatomic)RWUserCenter *userCenter;

@property (strong, nonatomic)RWSessionManager *sessionManager;

@property (strong, nonatomic)MCNearbyServiceAdvertiser *advertiser;

@property (strong, nonatomic)MCNearbyServiceBrowser *browser;

@property (strong, nonatomic)NSMutableArray *peerArray;

@end

static RWBrowser *_instance = nil;
@implementation RWBrowser

+ (instancetype)shareInstance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[RWBrowser alloc] init];
    });
    return _instance;
}

- (void)setConfigurationWithName:(NSString *)name Identifier:(NSString *)identifier {
    _userCenter = [RWUserCenter center];
    _userCenter.name = name;
    _userCenter.identifier = identifier;
    _userCenter.myPeerID = [[MCPeerID alloc] initWithDisplayName:name];
    
    _sessionManager = [[RWSessionManager alloc] initWithPeer:_userCenter.myPeerID];
}

- (void)startSearchNearbyService {
    [self.peerArray removeAllObjects];
    
    _browser = [[MCNearbyServiceBrowser alloc] initWithPeer:_userCenter.myPeerID serviceType:_userCenter.identifier];
    _browser.delegate = self;
    [_browser startBrowsingForPeers];
}

- (void)startWaitForConnect {
    _advertiser = [[MCNearbyServiceAdvertiser alloc] initWithPeer:_userCenter.myPeerID discoveryInfo:nil serviceType:_userCenter.identifier];
    _advertiser.delegate = self;
    [_advertiser startAdvertisingPeer];
}

- (void)stopSearch {
    [_browser stopBrowsingForPeers];
}

- (void)stopWait {
    [_advertiser stopAdvertisingPeer];
}

- (void)invitePeer:(MCPeerID *)peerId {
    if ([_sessionManager.session.connectedPeers containsObject:peerId]) {
        NSLog(@"与%@已经连接了,无须再次连接",peerId.displayName);
        return;
    }
    [_browser invitePeer:peerId toSession:_sessionManager.session withContext:nil timeout:15];
}

#pragma mark - Browser Delegate
-(void)browser:(MCNearbyServiceBrowser *)browser foundPeer:(MCPeerID *)peerID withDiscoveryInfo:(NSDictionary<NSString *,NSString *> *)info {
    NSLog(@"发现附近用户%@",peerID.displayName);
    
    [self checkPeerArray:peerID];
    
    [self.peerArray addObject:peerID];
    
    if (_nearbyPeerBlock) {
        _nearbyPeerBlock((NSArray *)_peerArray);
    }
}

-(void)browser:(MCNearbyServiceBrowser *)browser lostPeer:(MCPeerID *)peerID {
    NSLog(@"丢失用户%@",peerID.displayName);
    
    [self checkPeerArray:peerID];
    
    if (_nearbyPeerBlock) {
        _nearbyPeerBlock((NSArray *)_peerArray);
    }
}

- (void)checkPeerArray:(MCPeerID *)peerID {
    NSMutableArray *existArray = [NSMutableArray arrayWithCapacity:_peerArray.count];
    for (MCPeerID *tempPeerId in _peerArray) {
        if ([tempPeerId.displayName isEqualToString:peerID.displayName]) {
            [existArray addObject:tempPeerId];
        }
    }
    if (existArray.count > 0) {
        [_peerArray removeObjectsInArray:existArray];
    }
}

#pragma mark - MCNearbyServiceAdvertiserDelegate
- (void)advertiser:(MCNearbyServiceAdvertiser *)advertiser didReceiveInvitationFromPeer:(MCPeerID *)peerID withContext:(nullable NSData *)context invitationHandler:(void (^)(BOOL accept, MCSession * __nullable session))invitationHandler {
    invitationHandler(YES, _sessionManager.session);
}

#pragma mark - Lazy load
- (NSMutableArray *)peerArray {
    if (!_peerArray) {
        _peerArray = [NSMutableArray array];
    }
    return _peerArray;
}
@end
