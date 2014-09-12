//
//  InspectableBugHunt.h
//  BugHuntSample
//
//  Created by Christopher Constable on 7/2/14.
//  Copyright (c) 2014 Etsy. All rights reserved.
//

#import "BugHunt.h"
#import "EBHWindow.h"

@interface InspectableBugHunt : BugHunt

+ (instancetype)sharedInstance;
+ (void)resetSharedInstance;

@end
