//
//  EBHScreenshotUtility.h
//  BugHuntSample
//
//  Created by Christopher Constable on 6/25/14.
//  Copyright (c) 2014 Etsy. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  Manages taking and storing screenshots. 
 */
@interface EBHScreenshotUtility : NSObject

/**
 *  Captures a screenshot of the main UIWindow.
 */
+ (void)captureScreenshotOfMainWindow;

/**
 *  Returns an array of all the screenshots taken since
 *  since the last time Bug Hunt was shown.
 *
 *  @return NSArray of UIImages.
 */
+ (NSArray *)screenshots;

/**
 *  Returns the last captured screenshot.
 *
 *  @return UIImage of the last captured screenshot.
 */
+ (UIImage *)lastScreenshot;

/**
 *  Used to clean up. Removes all currently stored screenshots.
 */
+ (void)clearScreenshots;

@end
