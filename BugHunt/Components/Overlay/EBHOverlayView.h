//
//  EBHOverlayView.h
//  BugHuntSample
//
//  Created by Christopher Constable on 6/12/14.
//  Copyright (c) 2014 Etsy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EBHOverlayViewDelegate.h"

@class EBHOverlayView;

/**
 *  The actual overlay that the user interacts with. Notifies it's
 *  delegate after processing user interaction.
 */
@interface EBHOverlayView : UIView

@property (nonatomic, weak) id<EBHOverlayViewDelegate> overlayDelegate;

@end
