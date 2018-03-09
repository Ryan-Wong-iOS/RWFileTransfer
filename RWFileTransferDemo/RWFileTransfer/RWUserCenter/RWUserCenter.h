//
//  RWUserCenter.h
//  RWFileTransferDemo
//
//  Created by RyanWong on 2018/1/17.
//  Copyright © 2018年 RyanWong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MultipeerConnectivity/MultipeerConnectivity.h>
#import "RWSession.h"

@interface RWUserCenter : NSObject

@property (strong, nonatomic)NSString *name;

@property (strong, nonatomic)NSString *identifier;

@property (strong, nonatomic)MCPeerID *myPeerID;

@property (strong, nonatomic)RWSession *session;

+ (instancetype)center;

@end
