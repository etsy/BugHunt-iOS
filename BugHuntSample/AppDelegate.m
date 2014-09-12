//
//  EBHAppDelegate.m
//  BugHuntSample
//
//  Created by Christopher Constable on 6/11/14.
//  Copyright (c) 2014 Etsy. All rights reserved.
//

#import "AppDelegate.h"
#import "BugHunt.h"
#import "MyNetworkCommunicator.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    MyNetworkCommunicator *networkCommunicator = [[MyNetworkCommunicator alloc] init];
    [BugHunt setNetworkCommunicator:networkCommunicator];
    
    [BugHunt showBugHunt];

    return YES;
}

@end
