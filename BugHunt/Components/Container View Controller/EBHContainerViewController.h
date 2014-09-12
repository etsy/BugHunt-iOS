//
//  EBHContainerViewController.h
//  BugHunt
//
//  Created by Christopher Constable on 6/11/14.
//  Copyright (c) 2014 Etsy. All rights reserved.
//

#import <UIKit/UIKit.h>

@class EBHContainerViewController;

/**
 *  Notifies the window or containing view controller when significant
 *  events occur with the Bug Hunt interface (e.g. the user has tapped
 *  the "Cancel" button).
 */
@protocol EBHContainerViewControllerDelegate <NSObject>

@required
- (void)containerViewControllerWantsToClose:(EBHContainerViewController *)containerViewController;

@end

@protocol EBHContainerViewControllerChildDelegate <NSObject>

@required
- (void)childViewControllerWantsToClose:(UIViewController *)childViewController;

@end

/**
 *  Contains all of the Bug Hunts module's user interface.
 */
@interface EBHContainerViewController : UIViewController <EBHContainerViewControllerChildDelegate>

@property (nonatomic, weak) id<EBHContainerViewControllerDelegate> containerDelegate;

@end
