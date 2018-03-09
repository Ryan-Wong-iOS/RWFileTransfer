//
//  RWSessionManager.m
//  RWFileTransferDemo
//
//  Created by RyanWong on 2018/1/17.
//  Copyright © 2018年 RyanWong. All rights reserved.
//

#import "RWSession.h"
#import "RWUserCenter.h"

@interface RWSession()<MCSessionDelegate>

@end

@implementation RWSession

- (instancetype)initWithPeer:(MCPeerID *)peerId {
    self = [super init];
    if (self) {
        _session = [[MCSession alloc] initWithPeer:peerId securityIdentity:nil encryptionPreference:MCEncryptionNone];
        _session.delegate = self;
    }
    return self;
}

+ (void)kickPeer:(MCPeerID *)peerId {
    [[RWUserCenter center].session.session cancelConnectPeer:peerId];
}

- (NSArray *)connectedPeers {
    return [self.session connectedPeers];
}

- (NSOutputStream *)outputStreamForPeer:(MCPeerID *)peer With:(NSString *)name {
    NSError *error;
    NSOutputStream *outputStream = [self.session startStreamWithName:name toPeer:peer error:&error];
    if (error) {
        NSLog(@"error : %@", [error userInfo].description);
    }
    return outputStream;
}

#pragma mark - MCSession Delegate
-(void)session:(MCSession *)session peer:(MCPeerID *)peerID didChangeState:(MCSessionState)state {
    if (state == MCSessionStateConnected) {
        NSLog(@"与%@连接上",peerID.displayName);
        self.session = session;
        
        [[NSNotificationCenter defaultCenter] postNotificationName:kRWSessionStateConnectedNotification object:nil];
    } else if (state == MCSessionStateConnecting) {
        NSLog(@"与%@连接中",peerID.displayName);
    } else if (state == MCSessionStateNotConnected) {
        NSLog(@"与%@连接断开",peerID.displayName);
        self.session = nil;
    }
}

-(void)session:(MCSession *)session didReceiveData:(NSData *)data fromPeer:(MCPeerID *)peerID {
    
}

-(void)session:(MCSession *)session didReceiveStream:(NSInputStream *)stream withName:(NSString *)streamName fromPeer:(MCPeerID *)peerID {
    if (_delegate && [_delegate respondsToSelector:@selector(session:didReceiveStream:WithName:)]) {
        [_delegate session:self didReceiveStream:stream WithName:streamName];
    }
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

@end
