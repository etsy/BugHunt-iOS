//
//  EBHLeaderboardUser.h
//  BugHuntSample
//
//  Created by Christopher Constable on 6/20/14.
//  Copyright (c) 2014 Etsy. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  Leaderboard model.
 */
@interface EBHLeaderboardUser : NSObject

@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *score;
@property (nonatomic, copy) NSURL *userImageUrl;

@end
