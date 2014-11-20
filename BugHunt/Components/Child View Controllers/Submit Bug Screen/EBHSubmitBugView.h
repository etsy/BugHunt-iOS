//
//  EBHSubmitBugView.h
//  BugHuntSample
//
//  Created by Christopher Constable on 6/27/14.
//  Copyright (c) 2014 Etsy. All rights reserved.
//

#import <UIKit/UIKit.h>


@class EBHButton;
@class EBH_SZTextView;
@class EBHSubmitBugView;

@protocol EBHSubmitBugViewDelegate <NSObject>

@required
- (void)submitBugViewAddNewScreenshotWasTapped:(EBHSubmitBugView *)submitBugView;

@end

@interface EBHSubmitBugView : UIView

@property (nonatomic, strong) UILabel *descriptionLabel;
@property (nonatomic, strong) UITextView *bugReportTextView;
@property (nonatomic, strong) UILabel *addScreenshotLabel;
@property (nonatomic, strong) UICollectionView *screenshotCollectionView;
@property (nonatomic, strong) EBHButton *addNewScreenshotButton;
@property (nonatomic, strong) EBHButton *howToScreenshotButton;
@property (nonatomic, strong) NSMutableDictionary *uiStrings;

@property (nonatomic, weak) id<EBHSubmitBugViewDelegate>delegate;

@end
