//
//  EBHScreenshotUtility.m
//  BugHuntSample
//
//  Created by Christopher Constable on 6/25/14.
//  Copyright (c) 2014 Etsy. All rights reserved.
//

#import "EBHScreenshotUtility.h"
#import "EBHWindow.h"

@interface EBHScreenshotUtility ()
@property (nonatomic, strong) NSMutableArray *screenshots;
@end

/**
 *  In the future it would be nice to handle alert views.
 *
 *  // Get the visible alert view using private classes:
 *  id alertManager = NSClassFromString(@"_UIAlertManager");
 *  id alertView = [alertManager performSelector:@selector(visibleAlert)];
 *
 */
@implementation EBHScreenshotUtility

+ (instancetype)sharedInstance
{
    static EBHScreenshotUtility *screenshotUtil = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        screenshotUtil = [[EBHScreenshotUtility alloc] init];
        screenshotUtil.screenshots = [NSMutableArray array];
    });
    
    return screenshotUtil;
}

+ (void)captureScreenshotOfMainWindow
{
    UIWindow *mainWindow = [UIApplication sharedApplication].windows[0];
    
    if ([[UIScreen mainScreen] respondsToSelector:@selector(scale)]) {
        UIGraphicsBeginImageContextWithOptions(mainWindow.bounds.size,
                                               NO, [UIScreen mainScreen].scale);
    }
    else {
        UIGraphicsBeginImageContext(mainWindow.bounds.size);
    }
    
    for (UIWindow *window in [UIApplication sharedApplication].windows) {
        
        // Don't draw the Bug Hunt overlay
        if ([window isKindOfClass:[EBHWindow class]]) {
            continue;
        }
        
        // FIX: In iOS 8 this call causes the the actual context to be rendered
        // onscreen and there is a noticible flicker. As a work-around, renderInContext:
        // is being used below.
//        [window drawViewHierarchyInRect:mainWindow.bounds afterScreenUpdates:YES];
        
        CGContextRef context = UIGraphicsGetCurrentContext();
        [window.layer renderInContext:context];
        
    }
    
    UIImage *screenshot = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

    [[EBHScreenshotUtility sharedInstance].screenshots addObject:screenshot];
}

+ (NSArray *)screenshots
{
    NSArray *screenshots = [[EBHScreenshotUtility sharedInstance].screenshots copy];
    return screenshots;
}

+ (UIImage *)lastScreenshot
{
    return [[EBHScreenshotUtility sharedInstance].screenshots lastObject];
}

+ (void)clearScreenshots
{
    [[EBHScreenshotUtility sharedInstance].screenshots removeAllObjects];
}

@end
