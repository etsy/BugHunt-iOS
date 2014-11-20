//
//  EBHConfig.h
//  BugHunt
//
//  Created by Lauren Sperber on 11/19/14.
//  Copyright (c) 2014 Etsy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EBHConfig : NSObject

+ (instancetype)sharedInstance;
+ (instancetype)defaultInstance;
+ (instancetype)mainInstance;

@property (nonatomic, strong) NSMutableDictionary *ebhConfig;

@end
