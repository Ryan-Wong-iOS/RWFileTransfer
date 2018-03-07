//
//  RWSessionManager.m
//  RWFileTransferDemo
//
//  Created by RyanWong on 2018/1/17.
//  Copyright © 2018年 RyanWong. All rights reserved.
//

#import "RWSessionManager.h"
#import "RWUserCenter.h"

@interface RWSessionManager()<MCSessionDelegate>

@property (strong, nonatomic)RWUserCenter *userCenter;

@end

@implementation RWSessionManager

- (instancetype)initWithPeer:(MCPeerID *)peerId {
    self = [super init];
    if (self) {
        _session = [[MCSession alloc] initWithPeer:peerId securityIdentity:nil encryptionPreference:MCEncryptionNone];
        _session.delegate = self;
    }
    return self;
}

+ (void)kickPeer:(MCPeerID *)peerId {
    [[RWUserCenter center].session cancelConnectPeer:peerId];
}

#pragma mark - MCSession Delegate
-(void)session:(MCSession *)session peer:(MCPeerID *)peerID didChangeState:(MCSessionState)state {
    if (state == MCSessionStateConnected) {
        NSLog(@"与%@连接上",peerID.displayName);
        _userCenter.session = session;
        
        [[NSNotificationCenter defaultCenter] postNotificationName:kRWSessionStateConnectedNotification object:nil];
    } else if (state == MCSessionStateConnecting) {
        NSLog(@"与%@连接中",peerID.displayName);
    } else if (state == MCSessionStateNotConnected) {
        NSLog(@"与%@连接断开",peerID.displayName);
        _userCenter.session = nil;
    }
}

-(void)session:(MCSession *)session didReceiveData:(NSData *)data fromPeer:(MCPeerID *)peerID {
    
}

-(void)session:(MCSession *)session didReceiveStream:(NSInputStream *)stream withName:(NSString *)streamName fromPeer:(MCPeerID *)peerID {
    
}

// Start receiving a resource from remote peer.
- (void)                    session:(MCSession *)session
  didStartReceivingResourceWithName:(NSString *)resourceName
                           fromPeer:(MCPeerID *)peerID
                       withProgress:(NSProgress *)progress{}

// Finished receiving a resource from remote peer and saved the content
// in a temporary location - the app is responsible for moving the file
// to a permanent location within its sandbox.
- (void)                    session:(MCSession *)session
 didFinishReceivingResourceWithName:(NSString *)resourceName
                           fromPeer:(MCPeerID *)peerID
                              atURL:(nullable NSURL *)localURL
                          withError:(nullable NSError *)error{}

#pragma mark - Lazy load
-(RWUserCenter *)userCenter {
    if (!_userCenter) {
        _userCenter = [RWUserCenter center];
    }
    return _userCenter;
}

@end
