//
//  EBHScreenshotCell.m
//  BugHuntSample
//
//  Created by Christopher Constable on 6/25/14.
//  Copyright (c) 2014 Etsy. All rights reserved.
//

#import "EBHScreenshotCell.h"

@implementation EBHScreenshotCell

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
    CGRect imageFrame = self.frame;
    imageFrame.origin.x = imageFrame.origin.y = 0;
    self.screenshotImageView = [[UIImageView alloc] initWithFrame:imageFrame];
    self.screenshotImageView.contentMode = UIViewContentModeScaleAspectFill;
    self.screenshotImageView.autoresizingMask = UIViewAutoresizingFlexibleWidth |
    UIViewAutoresizingFlexibleHeight;
    self.screenshotImageView.clipsToBounds = YES;
    [self.contentView addSubview:self.screenshotImageView];
    
    UIButton *deleteButton = [[UIButton alloc] initWithFrame:CGRectMake(-10, -10, 25, 25)];
    [deleteButton setImage:[UIImage imageNamed:@"ebb_icon_close_circle"]
                  forState:UIControlStateNormal];
    [deleteButton setImage:[UIImage imageNamed:@"ebb_icon_close_circle"]
                  forState:UIControlStateHighlighted];
    [deleteButton addTarget:self
                     action:@selector(deleteButtonWasTapped:)
           forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:deleteButton];
}

#pragma mark - Actions

- (void)deleteButtonWasTapped:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(screenshotCellDeleteWasTapped:)]) {
        [self.delegate screenshotCellDeleteWasTapped:self];
    }
}

@end
