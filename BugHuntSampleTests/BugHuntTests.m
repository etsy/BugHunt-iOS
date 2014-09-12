//
//  BugHuntTests.m
//  BugHuntSample
//
//  Created by Christopher Constable on 7/2/14.
//  Copyright (c) 2014 Etsy. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <objc/runtime.h>
#import "InspectableBugHunt.h"

@interface BugHuntTests : XCTestCase

@end

@implementation BugHuntTests

- (void)setUp
{
    [super setUp];
    [self replaceSharedInstanceImplementation];
    [InspectableBugHunt resetSharedInstance];
}

- (void)tearDown
{
    [InspectableBugHunt hideBugHuntAndDeallocate:YES];
    [super tearDown];
}

/**
 *  This allows us to "reset" the shared instances. We are not swapping method implementations
 *  here, rather, we are just setting the original [BugHunt sharedInstance] method to the
 *  execute the implementation of [InspectableBugHunt sharedInstance]. This is because we
 *  "sharedInstance" is called internally by the BugHunt class (it's not publically exposed)
 *  and we want to make sure that if a method executing in the scope of the BugHunt class invokes
 *  "sharedInstance" that it will execute the right one.
 */
- (void)replaceSharedInstanceImplementation
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^ {
        SEL testingSharedInstance = @selector(sharedInstance);
        Method testingSharedInstanceMethod = class_getClassMethod([InspectableBugHunt class], testingSharedInstance);
        IMP testingSharedInstanceImp = method_getImplementation(testingSharedInstanceMethod);
        
        SEL originalSelector = @selector(sharedInstance);
        Method originalMethod = class_getClassMethod([BugHunt class], originalSelector);
        method_setImplementation(originalMethod, testingSharedInstanceImp);
    });
}

#pragma mark - Tests

- (void)testShowBugHuntCreatesWindow
{
    [InspectableBugHunt showBugHunt];
    
    UIWindow *window = [[InspectableBugHunt sharedInstance] valueForKeyPath:@"bugHuntWindow"];
    XCTAssertNotNil(window, @"'bugHuntWindow' must be non-nil after calling 'showBugHunt'");
}

- (void)testShowBugHuntStoresMainWindow
{
    [InspectableBugHunt showBugHunt];
    
    UIWindow *window = [[InspectableBugHunt sharedInstance] valueForKeyPath:@"mainAppWindow"];
    XCTAssertNotNil(window, @"'mainAppWindow' must be non-nil after calling 'showBugHunt'");
}

- (void)testHidingBugHuntDestroysWindow
{
    [InspectableBugHunt showBugHunt];
    
    // Drain the current run loop
    [[NSRunLoop mainRunLoop] runMode:NSDefaultRunLoopMode
                          beforeDate:[NSDate date]];
    
    [InspectableBugHunt hideBugHunt];
    UIWindow *window = [[InspectableBugHunt sharedInstance] valueForKeyPath:@"bugHuntWindow"];
    XCTAssertNil(window, @"'bugHuntWindow' must be nil after calling 'hideBugHunt'");
}

@end
