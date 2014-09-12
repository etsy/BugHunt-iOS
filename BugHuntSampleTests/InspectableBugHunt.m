//
//  InspectableBugHunt.m
//  BugHuntSample
//
//  Created by Christopher Constable on 7/2/14.
//  Copyright (c) 2014 Etsy. All rights reserved.
//

#import "InspectableBugHunt.h"

BOOL shouldResetSharedInstance = YES;

@implementation InspectableBugHunt

+ (instancetype)sharedInstance
{
    static InspectableBugHunt *sharedInstance;
    if (shouldResetSharedInstance == YES) {
        sharedInstance = [[InspectableBugHunt alloc] init];
        shouldResetSharedInstance = NO;
    }
    
    return sharedInstance;
}

+ (void)resetSharedInstance
{
    shouldResetSharedInstance = YES;
}

@end
