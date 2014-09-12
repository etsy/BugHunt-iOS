//
//  EBHScreenshotCell.h
//  BugHuntSample
//
//  Created by Christopher Constable on 6/25/14.
//  Copyright (c) 2014 Etsy. All rights reserved.
//

#import <UIKit/UIKit.h>

@class EBHScreenshotCell;

/**
 *  Responsible for handling events caused by user 
 *  interaction with the cell.
 */
@protocol EBHScreenshotCellDelegate <NSObject>

- (void)screenshotCellDeleteWasTapped:(EBHScreenshotCell *)cell;

@end

@interface EBHScreenshotCell : UICollectionViewCell

@property (nonatomic, strong) UIImageView *screenshotImageView;
@property (nonatomic, weak) id<EBHScreenshotCellDelegate> delegate;

@end
