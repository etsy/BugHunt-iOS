//
//  EBHLeaderboardCell.h
//  BugHuntSample
//
//  Created by Christopher Constable on 6/26/14.
//  Copyright (c) 2014 Etsy. All rights reserved.
//

#import <UIKit/UIKit.h>

@class EBHLeaderboardUser;

@interface EBHLeaderboardCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *userImageView;
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
@property (weak, nonatomic) IBOutlet UILabel *userScoreLabel;

@property (strong, nonatomic) EBHLeaderboardUser *leaderboardUser;

@end
