//
//  EBHNetworkCommunicator.h
//  BugHuntSample
//
//  Created by Christopher Constable on 6/24/14.
//  Copyright (c) 2014 Etsy. All rights reserved.
//

#import <Foundation/Foundation.h>

// Models
@class EBHBugReport;

typedef void(^EBHCreateNewIssueCompletionBlock)(NSError *error);
typedef void(^EBHFetchTasksCompletionBlock)(NSArray *tasks, NSError *error);
typedef void(^EBHFetchLeaderboardCompletionBlock)(NSArray *leaderboardUsers, NSError *error);

/**
 *  Defines an object that is able to communicate to a Bug Hunt
 *  back-end on behalf of the Bug Hunt module. Since this module
 *  may be used in different apps, it is up to the individual apps
 *  to provide their own networking implementations.
 *
 *  Communication with a EBHNetworkCommunicator is two-way:
 *
 *  1. The EBHNetworkCommunicator receieves a message from the
 *     Bug Hunt module requesting some networking be done.
 *  2. The EBHNetworkCommunicator performs the request and
 *     responds via a completion block.
 *
 *  All implemented methods should be non-blocking and immediately
 *  return their intent ("YES" meaning "I will perform the request" and
 *  "NO" meaning "I will not peform the request).
 */
@protocol EBHNetworkCommunicator <NSObject>

@required

/**
 *  A request to create an issue. The EBHNetworkCommunicator must take
 *  the appropriate action, perform any necessary requests and call
 *  the completion block when finished.
 *
 *  @param bugReport       The bug report to file.
 *  @param completionBlock Completion block to be called upon finishing.
 *
 *  @return A BOOL that indicated whether or not the EBHNetworkCommunicator
 *          object is going to attempt to make the request.
 */
- (BOOL)createBugHuntIssue:(EBHBugReport *)bugReport
                  completion:(EBHCreateNewIssueCompletionBlock)completionBlock;

/**
 *  A request to fetch the current tasks. The EBHNetworkCommunicator must 
 *  take the appropriate action, perform any necessary requests and call
 *  the completion block when finished.
 *
 *  @param completionBlock Completion block to be called upon finishing.
 *                         This array should contain EBHTask objects.
 *
 *  @return A BOOL that indicated whether or not the EBHNetworkCommunicator
 *          object is going to attempt to make the request.
 */
- (BOOL)fetchBugHuntTasks:(EBHFetchTasksCompletionBlock)completionBlock;

/**
 *  A request to fetch the current leaderboard. The EBHNetworkCommunicator 
 *  must take the appropriate action, perform any necessary requests and call
 *  the completion block when finished.
 *
 *  @param completionBlock Completion block to be called upon finishing.
 *                         This array should contain EBHLeaderboardUser objects.
 *
 *  @return A BOOL that indicated whether or not the EBHNetworkCommunicator
 *          object is going to attempt to make the request.
 */
- (BOOL)fetchBugHuntLeaderboard:(EBHFetchLeaderboardCompletionBlock)completionBlock;

@end
