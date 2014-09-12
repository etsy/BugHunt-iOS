//
//  EBHWindow.h
//  BugHunt
//
//  Created by Christopher Constable on 6/11/14.
//  Copyright (c) 2014 Etsy. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "EBHOverlayView.h"

/**
 *  This is the main window that is responsible for housing all
 *  the Bug Hunt views and view controllers. It conforms to the
 *  EBHOverlayViewDelegate protocol which allows it's overlay
 *  view to communicate with it.
 */
@interface EBHWindow : UIWindow <EBHOverlayViewDelegate>

@end
