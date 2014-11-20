//
//  EBHTaskViewController.m
//  BugHunt
//
//  Created by Christopher Constable on 6/11/14.
//  Copyright (c) 2014 Etsy. All rights reserved.
//

#import "EBHTaskViewController.h"
#import "EBHNetworkManager.h"
#import "EBHConfig.h"

// Models
#import "EBHTask.h"

// Views
#import "EBHTaskCell.h"
#import "MBProgressHUD.h"

NSString * const kTaskViewCell = @"TaskViewCell";

@interface EBHTaskViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, assign) BOOL hasFetchedTasks;
@property (nonatomic, strong) NSArray *tasks;
@property (nonatomic, strong) UITableView *tableView;

@end

@implementation EBHTaskViewController

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
    
    if (self.hasFetchedTasks == NO) {
        [self fetchTasks];
        self.hasFetchedTasks = YES;
    }
}

- (void)setupViews
{
    self.tableView = ({
        UITableView *tableView = [[UITableView alloc] init];
        tableView.translatesAutoresizingMaskIntoConstraints = NO;
        tableView.dataSource = self;
        tableView.delegate = self;
        UINib *nib = [UINib nibWithNibName:@"EBHTaskCell" bundle:nil];
        [tableView registerNib:nib forCellReuseIdentifier:kTaskViewCell];
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
    return self.tasks.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    EBHTask *currentTask = self.tasks[indexPath.row];
    EBHTaskCell *cell = [tableView dequeueReusableCellWithIdentifier:kTaskViewCell];
    cell.task = currentTask;
    
    [cell.contentView setNeedsLayout];
    [cell.contentView layoutIfNeeded];

    CGSize size = [cell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];    
    return size.height;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 100;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    EBHTask *currentTask = self.tasks[indexPath.row];
    EBHTaskCell *cell = [tableView dequeueReusableCellWithIdentifier:kTaskViewCell];
    cell.task = currentTask;
    
    [cell setNeedsUpdateConstraints];
    [cell updateConstraintsIfNeeded];
    
    return cell;
}

#pragma mark - Actions

- (void)fetchTasks
{
    EBHConfig *ebhConfig = [EBHConfig sharedInstance];
    NSMutableDictionary *uiStrings = ebhConfig.ebhConfig[@"UIStrings"];
    
    BOOL willMakeRequest = [[EBHNetworkManager networkCommunicator] fetchBugHuntTasks:^(NSArray *tasks, NSError *error) {
        if (error == nil) {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            
            self.tasks = tasks;
            [self.tableView reloadData];
        }
        else {
            MBProgressHUD *hud = [MBProgressHUD HUDForView:self.view];
            hud.mode = MBProgressHUDModeText;
            hud.labelText = uiStrings[@"NetworkErrorTitle"];
            [hud hide:YES afterDelay:2.0];
        } 
    }];
    
    if (willMakeRequest == YES) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.mode = MBProgressHUDModeIndeterminate;
        hud.labelText = uiStrings[@"RequestingTasksTitle"];
    }
}

@end
