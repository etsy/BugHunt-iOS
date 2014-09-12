//
//  EBHOverlayViewDelegate.h
//  BugHuntSample
//
//  Created by Christopher Constable on 6/17/14.
//  Copyright (c) 2014 Etsy. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  This protocol is used to allow communication between the overlay views
 *  and the EBHWindow.
 */
@protocol EBHOverlayViewDelegate <NSObject>

@required
- (void)overlayViewReceicedTap:(UIView *)overlayView;
- (void)overlayViewReceicedDoubleTap:(UIView *)overlayView;

@end
