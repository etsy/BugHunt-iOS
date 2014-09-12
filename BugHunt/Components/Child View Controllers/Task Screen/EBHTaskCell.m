//
//  EBHTaskCell.m
//  BugHuntSample
//
//  Created by Christopher Constable on 6/27/14.
//  Copyright (c) 2014 Etsy. All rights reserved.
//

#import "EBHTaskCell.h"
#import "EBHTask.h"

@implementation EBHTaskCell

- (void)updateUI
{
    self.taskTitleLabel.text = self.task.taskTitle;
    self.taskDescriptionLabel.text = self.task.taskDescription;
}

#pragma mark - Accessors

- (void)setTask:(EBHTask *)task
{
    _task = task;
    [self updateUI];
}

@end
