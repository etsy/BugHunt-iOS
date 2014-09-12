//
//  MyNetworkCommunicator.m
//  BugHuntSample
//
//  Created by Christopher Constable on 6/24/14.
//  Copyright (c) 2014 Etsy. All rights reserved.
//

#import "MyNetworkCommunicator.h"

// Models
#import "EBHBugReport.h"
#import "EBHTask.h"
#import "EBHLeaderboardUser.h"

@implementation MyNetworkCommunicator

- (BOOL)createBugHuntIssue:(EBHBugReport *)bugReport
                  completion:(EBHCreateNewIssueCompletionBlock)completionBlock
{
    NSLog(@"Creating new issue...");
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        NSLog(@"Created new issue successfully!");
        completionBlock(nil); // nil error == success
    });
    
    return YES; // we'll try to make the request
}

- (BOOL)fetchBugHuntTasks:(EBHFetchTasksCompletionBlock)completionBlock
{
    NSLog(@"Fetching bounty tasks...");
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        NSLog(@"Fetched tasks successfully!");
        
        // Generate a bunch of fake tasks...
        NSMutableArray *tasks = [NSMutableArray array];
        for (int i = 1; i < 21; i++) {
            EBHTask *newTask = [[EBHTask alloc] init];
            newTask.taskTitle = [NSString stringWithFormat:@"Task %d", i];
            
            NSMutableString *descriptionString = [NSMutableString string];
            int numberOfWords = (arc4random() % 50) + 1;
            for (int wordIndex = 0; wordIndex < numberOfWords; wordIndex++) {
                [descriptionString appendString:@"yip "];
            }
            newTask.taskDescription = descriptionString;
            [tasks addObject:newTask];
        }
                
        completionBlock(tasks ,nil); // nil error == success
    });
    
    return YES; // we'll try to make the request
}

- (BOOL)fetchBugHuntLeaderboard:(EBHFetchLeaderboardCompletionBlock)completionBlock
{
    NSLog(@"Fetching leaderboard...");
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        NSLog(@"Leaderboard fetched successfully!");
        
        NSMutableArray *leaderboardUsers = [NSMutableArray array];

        EBHLeaderboardUser *newUser = [[EBHLeaderboardUser alloc] init];
        newUser.name = @"Gunter";
        newUser.score = @"8";
        [leaderboardUsers addObject:newUser];
        newUser = [[EBHLeaderboardUser alloc] init];
        newUser.name = @"Jake";
        newUser.score = @"3";
        [leaderboardUsers addObject:newUser];
        newUser = [[EBHLeaderboardUser alloc] init];
        newUser.name = @"Finn";
        newUser.score = @"1";
        [leaderboardUsers addObject:newUser];
        
        completionBlock(leaderboardUsers, nil); // nil error == success
    });
    
    return YES; // we'll try to make the request
}

@end
