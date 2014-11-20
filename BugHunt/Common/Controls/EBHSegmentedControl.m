//
//  EBHSegmentedControl.m
//  BugHuntSample
//
//  Created by Christopher Constable on 6/25/14.
//  Copyright (c) 2014 Etsy. All rights reserved.
//

#import "EBHSegmentedControl.h"
#import "UIColor+BugHunt.h"
#import "EBHConfig.h"

@implementation EBHSegmentedControl

- (id)init
{
    return [self initWithFrame:CGRectZero];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initialize_];
    }
    return self;
}

- (void)initialize_
{
    self.backgroundColor = [UIColor ebb_lightGreyColor];
    self.tintColor = [UIColor whiteColor];
    
    // Text
    NSDictionary *normalAttributes = @{NSFontAttributeName: [UIFont systemFontOfSize:12],
                                       NSForegroundColorAttributeName: [UIColor blackColor]};
    NSDictionary *highlightedAttributes = @{NSForegroundColorAttributeName: [UIColor darkGrayColor]};
    NSDictionary *selectedAttributes = @{NSFontAttributeName: [UIFont boldSystemFontOfSize:12],
                                         NSForegroundColorAttributeName: [UIColor blackColor]};
    [self setTitleTextAttributes:normalAttributes forState:UIControlStateNormal];
    [self setTitleTextAttributes:highlightedAttributes forState:UIControlStateHighlighted];
    [self setTitleTextAttributes:selectedAttributes forState:UIControlStateSelected];

    // Segments
    EBHConfig *ebhConfig = [EBHConfig sharedInstance];
    NSMutableDictionary *uiStrings = ebhConfig.ebhConfig[@"UIStrings"];
    
    [self insertSegmentWithTitle:uiStrings[@"NewBugViewTitle"] atIndex:0 animated:NO];
    [self insertSegmentWithTitle:uiStrings[@"TasksViewTitle"] atIndex:1 animated:NO];
    [self insertSegmentWithTitle:uiStrings[@"LeaderboardViewTitle"] atIndex:2 animated:NO];
    self.selectedSegmentIndex = 0;
    
    [self setDividerImage:[self imageWithColor:[UIColor ebb_darkGreyColor]]
      forLeftSegmentState:UIControlStateNormal
        rightSegmentState:UIControlStateNormal
               barMetrics:UIBarMetricsDefault];
    
    self.layer.borderWidth = 0.5;
    self.layer.borderColor = [UIColor ebb_darkGreyColor].CGColor;
}

#pragma mark - Helper Methods

- (UIImage *)imageWithColor:(UIColor *)color {
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

@end
