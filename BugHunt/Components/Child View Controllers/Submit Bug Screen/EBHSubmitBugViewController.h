//
//  EBHSubmitBugViewController.h
//  BugHunt
//
//  Created by Christopher Constable on 6/11/14.
//  Copyright (c) 2014 Etsy. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "EBHContainerViewController.h"

/**
 *  Used for submitting new bugs.
 */
@interface EBHSubmitBugViewController : UIViewController

@property (nonatomic, weak) id<EBHContainerViewControllerChildDelegate> containerDelegate;

@end
