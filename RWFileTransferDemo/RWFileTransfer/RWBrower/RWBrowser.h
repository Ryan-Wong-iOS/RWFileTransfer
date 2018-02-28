//
//  RWBrower.h
//  RWFileTransferDemo
//
//  Created by RyanWong on 2018/1/17.
//  Copyright © 2018年 RyanWong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MultipeerConnectivity/MCPeerID.h>

typedef void(^RWBrowserGetNearbyPeerBlock)(NSArray<MCPeerID *> *peerArray);

@interface RWBrowser : NSObject

@property (copy, nonatomic)RWBrowserGetNearbyPeerBlock nearbyPeerBlock;

+ (instancetype)shareInstance;

- (void)setConfigurationWithName:(NSString *)name Identifier:(NSString *)identifier;

- (void)startSearchNearbyService;

- (void)startWaitForConnect;

- (void)stopSearch;

- (void)stopWait;

- (void)invitePeer:(MCPeerID *)peerId;

@end
