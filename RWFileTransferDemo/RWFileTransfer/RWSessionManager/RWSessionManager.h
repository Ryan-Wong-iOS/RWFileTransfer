//
//  RWSessionManager.h
//  RWFileTransferDemo
//
//  Created by RyanWong on 2018/1/17.
//  Copyright © 2018年 RyanWong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MultipeerConnectivity/MCSession.h>

static NSString *const kRWSessionStateConnectedNotification = @"RWSessionStateConnectedNotification";

@interface RWSessionManager : NSObject

@property (strong, nonatomic)MCSession *session;

- (instancetype)initWithPeer:(MCPeerID *)peerId;

+ (void)kickPeer:(MCPeerID *)peerId;

@end
