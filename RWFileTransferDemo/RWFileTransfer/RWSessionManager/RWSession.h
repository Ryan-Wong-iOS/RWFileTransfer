//
//  RWSession.h
//  RWFileTransferDemo
//
//  Created by RyanWong on 2018/1/17.
//  Copyright © 2018年 RyanWong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MultipeerConnectivity/MCSession.h>

static NSString *const kRWSessionStateConnectedNotification = @"RWSessionStateConnectedNotification";

@class RWSession;
@protocol RWSessionDelegate <NSObject>

- (void)session:(RWSession *)session didReceiveStream:(NSInputStream *)stream WithName:(NSString *)streamName;
- (void)session:(RWSession *)session didReceiveData:(NSData *)data;

@end

@interface RWSession : NSObject

@property (strong, nonatomic)MCSession *session;

@property (assign, nonatomic)id <RWSessionDelegate> delegate;

- (instancetype)initWithPeer:(MCPeerID *)peerId;

+ (void)kickPeer:(MCPeerID *)peerId;

- (NSArray *)connectedPeers;

- (NSOutputStream *)outputStreamForPeer:(MCPeerID *)peer With:(NSString *)name;

@end
