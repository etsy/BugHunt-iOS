//
//  EBHLeaderboardCell.m
//  BugHuntSample
//
//  Created by Christopher Constable on 6/26/14.
//  Copyright (c) 2014 Etsy. All rights reserved.
//

#import "EBHLeaderboardCell.h"
#import "UIImageView+AFNetworking.h"

// Models
#import "EBHLeaderboardUser.h"

@implementation EBHLeaderboardCell

#pragma mark - Initialization

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    self.userImageView.layer.cornerRadius = self.userImageView.frame.size.height / 2.0;
    self.userImageView.clipsToBounds = YES;
    self.userImageView.backgroundColor = [UIColor lightGrayColor];
}

#pragma mark - Accessors

- (void)setLeaderboardUser:(EBHLeaderboardUser *)leaderboardUser
{
    _leaderboardUser = leaderboardUser;
    [self updateUI];
}

#pragma mark - Methods

- (void)prepareForReuse
{
    [super prepareForReuse];
    [self.userImageView cancelImageRequestOperation];
}

- (void)updateUI
{
    self.usernameLabel.text = self.leaderboardUser.name;
    self.userScoreLabel.text = self.leaderboardUser.score;
    [self.userImageView setImageWithURL:self.leaderboardUser.userImageUrl];
}

@end
