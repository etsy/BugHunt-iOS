//
//  EBHBugReport.h
//  BugHunt
//
//  Created by Christopher Constable on 6/11/14.
//  Copyright (c) 2014 Etsy. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  Bug Report model.
 */
@interface EBHBugReport : NSObject

@property (nonatomic, copy) NSString *bugDescription;
@property (nonatomic, copy) NSString *username;
@property (nonatomic, strong) NSArray *screenshots;
@property (nonatomic, copy) NSString *operatingSystem;
@property (nonatomic, copy) NSString *appVersion;
@property (nonatomic, strong) NSDate *creationDate;

@end
