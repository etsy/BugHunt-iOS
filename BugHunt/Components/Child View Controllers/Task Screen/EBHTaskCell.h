//
//  EBHTaskCell.h
//  BugHuntSample
//
//  Created by Christopher Constable on 6/27/14.
//  Copyright (c) 2014 Etsy. All rights reserved.
//

#import <UIKit/UIKit.h>

@class EBHTask;

@interface EBHTaskCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *taskTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *taskDescriptionLabel;
@property (strong, nonatomic) EBHTask *task;

@end
