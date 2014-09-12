//
//  EBHButton.m
//  BugHuntSample
//
//  Created by Christopher Constable on 6/25/14.
//  Copyright (c) 2014 Etsy. All rights reserved.
//

#import "EBHButton.h"
#import "UIColor+BugHunt.h"

@implementation EBHButton

- (id)init
{
    return [self initWithFrame:CGRectZero];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initialize_];
    }
    return self;
}

- (void)initialize_
{
    self.backgroundColor = [UIColor whiteColor];
    
    [self setTitleColor:[UIColor ebb_lightPurple] forState:UIControlStateNormal];
    [self setTitleColor:[UIColor ebb_lightPurple] forState:UIControlStateHighlighted];
    self.titleLabel.font = [UIFont boldSystemFontOfSize:18];
   
    self.layer.borderWidth = 1.0 / [[UIScreen mainScreen] scale];
    self.layer.borderColor = [UIColor ebb_darkGreyColor].CGColor;
}

@end
