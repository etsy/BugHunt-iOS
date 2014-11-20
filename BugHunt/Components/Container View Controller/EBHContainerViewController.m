//
//  EBHContainerViewController.m
//  BugHunt
//
//  Created by Christopher Constable on 6/11/14.
//  Copyright (c) 2014 Etsy. All rights reserved.
//

#import "EBHContainerViewController.h"
#import "UIColor+BugHunt.h"
#import "EBHConfig.h"

// View Controllers
#import "EBHSubmitBugViewController.h"
#import "EBHTaskViewController.h"
#import "EBHLeaderBoardViewController.h"

// Views / Controls
#import "EBHSegmentedControl.h"

// Navigation Constants and Enums
static CGFloat const EBHSegmentedControlOrigin = 64.0f;
static CGFloat const EBHSegmentedControlHeight = 40.0f;

NS_ENUM(NSUInteger, EBHNavigationItem) {
    EBHNavigationItemSubmitBug,
    EBHNavigationItemTasks,
    EBHNavigationItemLeaderboard
};

@interface EBHContainerViewController ()

// Navigation
@property (nonatomic, strong) EBHSegmentedControl *segmentedControl;
@property (nonatomic, strong) NSArray *segmentChildViewControllers;

// Child view controller
@property (nonatomic, strong) UIView *childViewControllerView;
@property (nonatomic, weak) UIViewController *currentChildViewController;

@end

@implementation EBHContainerViewController

#pragma mark - Initialization

- (void)loadView
{
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [UIColor whiteColor];
    
    self.view = view;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setupNavigationItem];
    [self setupViews];
    [self setupConstraints];
    [self setupViewControllers];
}

- (void)setupNavigationItem
{
    self.navigationController.navigationBar.barTintColor = [UIColor ebb_lightGreyColor];

    EBHConfig *ebhConfig = [EBHConfig sharedInstance];
    NSMutableDictionary *uiStrings = ebhConfig.ebhConfig[@"UIStrings"];
    self.title = uiStrings[@"BugHuntTitle"];
    
    UIBarButtonItem *leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Cancel"
                                                                          style:UIBarButtonItemStylePlain
                                                                         target:self
                                                                         action:@selector(closeButtonWasTapped:)];
    NSDictionary *textAttributes = @{NSFontAttributeName: [UIFont boldSystemFontOfSize:14],
                                     NSForegroundColorAttributeName: [UIColor blackColor]};
    [leftBarButtonItem setTitleTextAttributes:textAttributes
                                 forState:UIControlStateNormal];
    [leftBarButtonItem setTitleTextAttributes:textAttributes
                                 forState:UIControlStateHighlighted];
    self.navigationItem.leftBarButtonItem = leftBarButtonItem;
}

- (void)setupViews
{
    self.childViewControllerView = ({
        UIView *view = [[UIView alloc] init];
        view.translatesAutoresizingMaskIntoConstraints = NO;
        view;
    });
    [self.view addSubview:self.childViewControllerView];
    
    // Top navigation
    self.segmentedControl = ({
        EBHSegmentedControl *control = [[EBHSegmentedControl alloc] init];
        control.translatesAutoresizingMaskIntoConstraints = NO;
        [control addTarget:self
                    action:@selector(segmentWasSelected:)
          forControlEvents:UIControlEventValueChanged];
        control;
    });
    [self.view addSubview:self.segmentedControl];
}

- (void)setupConstraints
{
    // Vertical constraints
    NSString *visualFormat = @"V:|-topPadding-[_segmentedControl(segmentedControlHeight)][_childViewControllerView]|";
    NSDictionary *metrics = @{@"topPadding": @(EBHSegmentedControlOrigin),
                              @"segmentedControlHeight": @(EBHSegmentedControlHeight)};
    NSDictionary *views = NSDictionaryOfVariableBindings(_segmentedControl,
                                                         _childViewControllerView);
    NSArray *constraints = [NSLayoutConstraint constraintsWithVisualFormat:visualFormat
                                                                   options:NSLayoutFormatAlignAllLeft
                                                                   metrics:metrics
                                                                     views:views];
    [self.view addConstraints:constraints];
    
    // Horizontal constraints
    visualFormat = @"|[_segmentedControl]|";
    constraints = [NSLayoutConstraint constraintsWithVisualFormat:visualFormat
                                                          options:0
                                                          metrics:nil
                                                            views:views];
    [self.view addConstraints:constraints];
    
    // Size constraints
    visualFormat = @"|[_childViewControllerView(==_segmentedControl)]|";
    constraints = [NSLayoutConstraint constraintsWithVisualFormat:visualFormat
                                                          options:0
                                                          metrics:nil
                                                            views:views];
    [self.view addConstraints:constraints];
}

- (void)setupViewControllers
{
    EBHSubmitBugViewController *bugViewController = [[EBHSubmitBugViewController alloc] init];
    bugViewController.containerDelegate = self;
    EBHTaskViewController *taskViewController = [[EBHTaskViewController alloc] init];
    EBHLeaderBoardViewController *leaderboardViewController = [[EBHLeaderBoardViewController alloc] init];
    
    self.segmentChildViewControllers = @[bugViewController, taskViewController, leaderboardViewController];
    
    [self displayChildViewController:self.segmentChildViewControllers[0]];
}

#pragma mark - EBHContainerViewControllerChildDelegate

- (void)childViewControllerWantsToClose:(UIViewController *)childViewController
{
    [self closeBugHuntModal];
}

#pragma mark - Actions

- (void)segmentWasSelected:(UISegmentedControl *)segmentControl
{
    NSUInteger selectedIndex = segmentControl.selectedSegmentIndex;
    UIViewController *viewControllerToDisplay = self.segmentChildViewControllers[selectedIndex];
    
    [self displayChildViewController:viewControllerToDisplay];
}

- (void)displayChildViewController:(UIViewController *)childViewController
{
    // Holds the constraints we added for the last child view.
    static NSMutableArray *subviewConstraints;
    
    // 1. Remove any constraints we added to the old child view...
    if (subviewConstraints) {
        [self.childViewControllerView removeConstraints:subviewConstraints];
        [subviewConstraints removeAllObjects];
    }
    else {
        subviewConstraints = [NSMutableArray array];
    }
    
    // 2. Remove old current child VC from view...
    [self.currentChildViewController willMoveToParentViewController:nil];
    [self.currentChildViewController.view removeFromSuperview];
    [self.currentChildViewController removeFromParentViewController];
    
    // 3. Add the new child view...
    [self addChildViewController:childViewController];
    [self.childViewControllerView addSubview:childViewController.view];
    [childViewController didMoveToParentViewController:self];
    
    // 4. Add some constraints so it takes up the whole area...
    UIView *childView = childViewController.view;
    NSString *visualFormat = @"V:|[childView]|";
    NSDictionary *views = NSDictionaryOfVariableBindings(childView);
    [subviewConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:visualFormat
                                                                                    options:0
                                                                                    metrics:nil
                                                                                      views:views]];
    visualFormat = @"|[childView]|";
    [subviewConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:visualFormat
                                                                                    options:0
                                                                                    metrics:nil
                                                                                      views:views]];
    [self.childViewControllerView addConstraints:subviewConstraints];
    
    // 5. Copy any navigation items that might be useful...
    [self.navigationItem setRightBarButtonItems:childViewController.navigationItem.rightBarButtonItems animated:YES];
    
    self.currentChildViewController = childViewController;
}

- (void)closeButtonWasTapped:(id)sender
{
    [self closeBugHuntModal];
}

- (void)closeBugHuntModal
{
    if ([self.containerDelegate respondsToSelector:@selector(containerViewControllerWantsToClose:)]) {
        [self.containerDelegate containerViewControllerWantsToClose:self];
    }
}

@end
