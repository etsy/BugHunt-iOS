//
//  UIColor+BugHunt.m
//  BugHuntSample
//
//  Created by Christopher Constable on 6/25/14.
//  Copyright (c) 2014 Etsy. All rights reserved.
//

#import "UIColor+BugHunt.h"

@implementation UIColor (BugHunt)

+ (instancetype)ebb_lightGreyColor
{
    return [UIColor colorWithRed:242.0 / 255.0
                           green:243.0 / 255.0
                            blue:237.0 / 255.0
                           alpha:1.0];
}

+ (instancetype)ebb_darkGreyColor
{
    return [UIColor colorWithRed:193.0 / 255.0
                           green:193.0 / 255.0
                            blue:193.0 / 255.0
                           alpha:1.0];
}

+ (instancetype)ebb_lightPurple
{
    return [UIColor colorWithRed:0.0 / 255.0
                           green:127.0 / 255.0
                            blue:168.0 / 255.0
                           alpha:1.0];
}

@end
