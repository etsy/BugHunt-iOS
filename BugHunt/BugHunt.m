//
//  BugHunt.m
//  BugHunt
//
//  Created by Christopher Constable on 6/11/14.
//  Copyright (c) 2014 Etsy. All rights reserved.
//

#import "BugHunt.h"
#import "EBHWindow.h"
#import "EBHScreenshotUtility.h"
#import "EBHNetworkManager.h"

@interface BugHunt ()

@property (nonatomic, weak) UIWindow *mainAppWindow;
@property (nonatomic, strong) EBHWindow *bugHuntWindow;

@end

@implementation BugHunt

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.mainAppWindow = [[UIApplication sharedApplication] keyWindow];
    }
    return self;
}

/**
 *  This is a private method. We don't want people to actually use an
 *  instance of BugHunt. Instead, we want them to use the interface we've
 *  provided in the header file.
 */
+ (instancetype)sharedInstance
{
    static BugHunt *sharedInstance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    
    return sharedInstance;
}

#pragma mark - Factory Methods

+ (void)showBugHunt
{
    [BugHunt showBugHuntAtLevel:UIWindowLevelStatusBar - 1];
}

+ (void)showBugHuntAtLevel:(NSInteger)windowLevel
{
    BugHunt* bugHunt = [BugHunt sharedInstance];
    
    if (bugHunt.bugHuntWindow == nil) {
        bugHunt.bugHuntWindow = [[EBHWindow alloc] init];
    }
    
    bugHunt.bugHuntWindow.windowLevel = windowLevel;
    [bugHunt.bugHuntWindow makeKeyAndVisible];
    
    // We just want bugHunt to be visible, not key.
    [bugHunt.mainAppWindow makeKeyAndVisible];
}

+ (void)hideBugHunt
{
    [BugHunt hideBugHuntAndDeallocate:YES];
}

+ (void)hideBugHuntAndDeallocate:(BOOL)shouldDeallocate
{
    [EBHScreenshotUtility clearScreenshots];
    
    BugHunt* bugHunt = [BugHunt sharedInstance];
    bugHunt.bugHuntWindow.hidden = YES;
    [bugHunt.mainAppWindow makeKeyAndVisible];
    
    if (shouldDeallocate) {
        bugHunt.bugHuntWindow = nil;
    }
}

#pragma mark - Public Methods

+ (void)setNetworkCommunicator:(id<EBHNetworkCommunicator>)networkCommunicator
{
    [[EBHNetworkManager sharedManager] setNetworkCommunicator:networkCommunicator];
}

@end
