//
//  EBHWindow.m
//  BugHunt
//
//  Created by Christopher Constable on 6/11/14.
//  Copyright (c) 2014 Etsy. All rights reserved.
//

#import "EBHWindow.h"
#import <objc/runtime.h>

#import "EBHContainerViewController.h"
#import "EBHScreenshotUtility.h"

@interface EBHWindow () <EBHContainerViewControllerDelegate>

/**
 *  Although the Bug Hunt is visible and able to be interacted
 *  with, it should not be the keyWindow. Other components may rely
 *  on the keyWindow being the window that that holds the "main contents".
 *  While EBHWindow is presenting it's modal, views such as UITextViews might
 *  force the EBHWindow to be the keyWindow and that may break things
 *  in the app after the modal is dismissed. To restore the previous state
 *  in case we become the keyWindow we use this property.
 */
@property (nonatomic, weak) UIWindow *keyWindowBeforeModal;

@property (nonatomic, assign) BOOL isShowingBugHuntModal;
@property (nonatomic, strong) EBHOverlayView *overlayView;
@property (nonatomic, strong) EBHContainerViewController *bugHuntContainerViewController;

@end

//////////////////////////////
// DANGER: SWIZZLING AHEAD
//////////////////////////////

/**
 *  Here we are swizzling a private method _statusBarControllingWindow 
 *  that let's us make sure aren't controlling the status bar styles.
 *  We are using this format of swizzling (as opposed to using
 *  method_exchangeImplementations) so that the _cmd parameter is always
 *  the original method's selector (i.e. we've left a minimal footprint).
 */
static IMP __original_imp_statusBarControllingWindow;
UIWindow * __swizzled_statusBarControllingWindow(id self, SEL _cmd)
{
    UIWindow *window = ((UIWindow *(*)(id,SEL))__original_imp_statusBarControllingWindow)(self, _cmd);
    if ([window isKindOfClass:[EBHWindow class]]) {
        window = [[UIApplication sharedApplication] keyWindow];
    }
    
    return window;
}

//////////////////////////////
// END OF SWIZZLING
//////////////////////////////

@implementation EBHWindow

#pragma mark - Initialization

- (id)init
{
    CGRect frame = [[UIScreen mainScreen] bounds];
    self = [self initWithFrame:frame];
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self initialize_];
    }
    
    return self;
}

- (void)initialize_
{
    self.windowLevel = UIWindowLevelAlert + 1;
    
    // See notes at top of file for why we are swizzling.
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        IMP swizzledMethodImp = (IMP)__swizzled_statusBarControllingWindow;
        
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wundeclared-selector"
        Method originalMethod = class_getClassMethod([self class], @selector(_statusBarControllingWindow));
#pragma clang diagnostic pop
        
        __original_imp_statusBarControllingWindow = method_setImplementation(originalMethod, swizzledMethodImp);
    });
    
    // Dummy VC
    self.rootViewController = [[UIViewController alloc] init];
    
    // The "Bug Hunt" view.
    self.overlayView = [[EBHOverlayView alloc] init];
    self.overlayView.overlayDelegate = self;
    [self.rootViewController.view addSubview:self.overlayView];
}

#pragma mark - Accessors

- (EBHContainerViewController *)bugHuntContainerViewController
{
    if (!_bugHuntContainerViewController) {
        _bugHuntContainerViewController = [[EBHContainerViewController alloc] init];
        _bugHuntContainerViewController.containerDelegate = self;
    }
    
    return _bugHuntContainerViewController;
}

#pragma mark - Touch

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event
{
    BOOL isPointInside;
    
    // If the Bug Hunt modal is being shown, behave normally...
    if (self.isShowingBugHuntModal) {
        isPointInside = [super pointInside:point withEvent:event];
    }
    
    // Else, only capture touches on the Bug Hunt button...
    else {
        point = [self convertPoint:point toView:self.overlayView];
        isPointInside = [self.overlayView pointInside:point withEvent:event];
    }
    
    return isPointInside;
}

#pragma mark - EBHOverlayViewControllerDelegate

- (void)overlayViewReceicedTap:(UIView *)overlayView
{
    // If the user hasn't been manually taking screenshots (via the overlay
    // gesture), take one for them.
    if ([EBHScreenshotUtility screenshots].count == 0) {
        [EBHScreenshotUtility captureScreenshotOfMainWindow];
    }
    
    self.keyWindowBeforeModal = [[UIApplication sharedApplication] keyWindow];
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:self.bugHuntContainerViewController];
    [self.rootViewController presentViewController:navigationController
                                          animated:YES
                                        completion:^{
                                            self.isShowingBugHuntModal = YES;
                                        }];
}

- (void)overlayViewReceicedDoubleTap:(UIView *)overlayView
{
    // Save a screenshot for later...
    [EBHScreenshotUtility captureScreenshotOfMainWindow];
    [self performScreenshotAnimation];
}

- (void)performScreenshotAnimation
{
    CGRect screenBounds = [[UIScreen mainScreen] bounds];
    UIImageView *screenshotImageView = [[UIImageView alloc] initWithFrame:screenBounds];
    screenshotImageView.image = [EBHScreenshotUtility lastScreenshot];
    [self.rootViewController.view insertSubview:screenshotImageView
                                   belowSubview:self.overlayView];
    
    CGRect destinationRect = CGRectInset(self.overlayView.frame, 20, 20);
    [UIView animateWithDuration:0.5
                          delay:0.0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         screenshotImageView.frame = destinationRect;
                     }
                     completion:^(BOOL finished) {
                         if (finished) {
                             [screenshotImageView removeFromSuperview];
                         }
                     }];
}

#pragma mark - EBHContainerViewControllerDelegate

- (void)containerViewControllerWantsToClose:(EBHContainerViewController *)containerViewController
{
    [self.rootViewController dismissViewControllerAnimated:YES
                                                completion:^{
                                                    self.bugHuntContainerViewController = nil;
                                                    self.isShowingBugHuntModal = NO;
                                                    
                                                    // Relinquish "keyWindow" status.
                                                    if ([self isKeyWindow]) {
                                                        [self.keyWindowBeforeModal makeKeyAndVisible];
                                                    }
                                                    
                                                    [EBHScreenshotUtility clearScreenshots];
                                                }];
}

@end
