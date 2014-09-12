//
//  EBHNetworkManager.m
//  BugHuntSample
//
//  Created by Christopher Constable on 6/24/14.
//  Copyright (c) 2014 Etsy. All rights reserved.
//

#import "EBHNetworkManager.h"

@implementation EBHNetworkManager

+ (id<EBHNetworkCommunicator>)networkCommunicator
{
    return [[EBHNetworkManager sharedManager] networkCommunicator];
}

+ (instancetype)sharedManager
{
    static EBHNetworkManager *networkManager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        networkManager = [[EBHNetworkManager alloc] init];
    });
    
    return networkManager;
}

@end
