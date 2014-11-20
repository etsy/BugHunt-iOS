//
//  EBHConfig.m
//  BugHunt
//
//  Created by Lauren Sperber on 11/19/14.
//  Copyright (c) 2014 Etsy. All rights reserved.
//

#import "EBHConfig.h"

@implementation EBHConfig

+ (instancetype)sharedInstance
{
    static EBHConfig *sharedInstance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[EBHConfig alloc] init];
    });
    
    [sharedInstance loadConfigFromFile];
    
    return sharedInstance;
}

+ (instancetype)defaultInstance {
    return [self sharedInstance];
}

+ (instancetype)mainInstance
{
    return [self sharedInstance];
}

- (void)loadConfigFromFile {
    NSString *configFilePath = [[NSBundle mainBundle]
                                pathForResource:@"EBHConfig" ofType:@"plist"];
    NSMutableDictionary *myConfig = [NSMutableDictionary dictionaryWithContentsOfFile:configFilePath];
    
    self.ebhConfig = myConfig;
}

@end
