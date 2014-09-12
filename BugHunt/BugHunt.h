//
//  BugHunt.h
//  BugHunt
//
//  Created by Christopher Constable on 6/11/14.
//  Copyright (c) 2014 Etsy. All rights reserved.
//

#import "EBHNetworkCommunicator.h"

/**
 *  The BugHunt class is meant to be used as a service rather
 *  than a singleton or individual instances. This means clients should not
 *  instantiate it, rather, they should use the methods provided
 *  in the public interface.
 *
 *  Usage is simple:
 *  Call "showBugHunt" when you want to show the Bug Hunt
 *  badge over the current app and "hideBugHunt" when you want
 *  to hide it. Be sure to set the EBHNetworkCommunicator object
 *  to a custom subclass that you have created.
 *
 *  @see EBHNetworkCommunicator
 */
@interface BugHunt : NSObject

/**
 *  Shows the Bug Hunt window immediately. The window level
 *  will default to UIWindowLevelStatusBar - 1.
 */
+ (void)showBugHunt;

/**
 *  Shows the Bug Hunt window immediately.
 *
 *  @param windowLevel UIWindow level at which Bug Hunt
 *                     should be displayed.
 */
+ (void)showBugHuntAtLevel:(NSInteger)windowLevel;

/**
 *  Hides the Bug Hunt window immediately.
 */
+ (void)hideBugHunt;

/**
 *  Hides the Bug Hunt window immediately.
 *
 *  @param shouldDeallocate Should the UIWindow resources be freed?
 */
+ (void)hideBugHuntAndDeallocate:(BOOL)shouldDeallocate;

/**
 *  Gives an object to Bug Hunt that conforms to the EBHNetworkCommunicator
 *  protocol. This object needs to be created by the client using the the
 *  Bug Hunt module. It is responsible for all network communication.
 *
 *  @param networkCommunicator The EBHNetworkCommunicator object.
 */
+ (void)setNetworkCommunicator:(id<EBHNetworkCommunicator>)networkCommunicator;

@end