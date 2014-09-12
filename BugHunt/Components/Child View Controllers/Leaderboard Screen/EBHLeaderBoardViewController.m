//
//  EBHLeaderBoardViewController.m
//  BugHunt
//
//  Created by Christopher Constable on 6/11/14.
//  Copyright (c) 2014 Etsy. All rights reserved.
//

#import "EBHLeaderBoardViewController.h"
#import "EBHNetworkManager.h"

// Models
#import "EBHLeaderboardUser.h"

// Views
#import "EBHLeaderboardCell.h"
#import "MBProgressHUD.h"

NSString * const kLeaderboardCell = @"LeaderboardCell";

@interface EBHLeaderBoardViewController () <UITableViewDataSource>

@property (nonatomic, assign) BOOL hasFetchedLeaderboard;
@property (nonatomic, strong) NSArray *leaderboardUsers;
@property (nonatomic, strong) UITableView *tableView;

@end

@implementation EBHLeaderBoardViewController

- (void)loadView
{
    UIView *view = [[UIView alloc] init];
    view.translatesAutoresizingMaskIntoConstraints = NO;
    view.backgroundColor = [UIColor whiteColor];
    
    self.view = view;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setupViews];
    [self setupConstraints];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    if (self.hasFetchedLeaderboard == NO) {
        [self fetchLeaderboard];
        self.hasFetchedLeaderboard = YES;
    }
}

- (void)setupViews
{
    self.tableView = ({
        UITableView *tableView = [[UITableView alloc] init];
        tableView.translatesAutoresizingMaskIntoConstraints = NO;
        tableView.dataSource = self;
        tableView.rowHeight = 75;
        [tableView registerNib:[UINib nibWithNibName:@"EBHLeaderboardCell" bundle:nil] forCellReuseIdentifier:kLeaderboardCell];
        tableView;
    });
    [self.view addSubview:self.tableView];
}

- (void)setupConstraints
{
    // Vertical constraints
    NSString *visualFormat = @"V:|[_tableView]|";
    NSDictionary *views = NSDictionaryOfVariableBindings(_tableView);
    NSArray *constraints = [NSLayoutConstraint constraintsWithVisualFormat:visualFormat
                                                                   options:0
                                                                   metrics:nil
                                                                     views:views];
    [self.view addConstraints:constraints];
    
    // Horizontal constraints
    visualFormat = @"|[_tableView]|";
    constraints = [NSLayoutConstraint constraintsWithVisualFormat:visualFormat
                                                          options:0
                                                          metrics:nil
                                                            views:views];
    [self.view addConstraints:constraints];
}

#pragma mark - UITableView

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.leaderboardUsers.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    EBHLeaderboardCell *cell = [tableView dequeueReusableCellWithIdentifier:kLeaderboardCell];
    cell.leaderboardUser = self.leaderboardUsers[indexPath.row];
    
    return cell;
}

#pragma mark - Actions 

- (void)fetchLeaderboard
{
    BOOL willMakeRequest = [[EBHNetworkManager networkCommunicator] fetchBugHuntLeaderboard:^(NSArray *leaderboardUsers, NSError *error) {
        if (error == nil) {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            
            self.leaderboardUsers = leaderboardUsers;
            [self.tableView reloadData];
        }
        else {
            MBProgressHUD *hud = [MBProgressHUD HUDForView:self.view];
            hud.mode = MBProgressHUDModeText;
            hud.labelText = @"Network error. Please try again.";
            [hud hide:YES afterDelay:2.0];
        }
    }];
    
    if (willMakeRequest) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.mode = MBProgressHUDModeIndeterminate;
        hud.labelText = @"Requesting leaderboard";
    }
}

@end
