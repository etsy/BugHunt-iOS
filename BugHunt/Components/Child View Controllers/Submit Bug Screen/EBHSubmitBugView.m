//
//  EBHSubmitBugView.m
//  BugHuntSample
//
//  Created by Christopher Constable on 6/27/14.
//  Copyright (c) 2014 Etsy. All rights reserved.
//

#import "EBHSubmitBugView.h"
#import "EBHConfig.h"

// Views
#import "EBHButton.h"
#import "EBH_SZTextView.h"
#import "EBHScreenshotCell.h"

@interface EBHSubmitBugView ()

@end

@implementation EBHSubmitBugView

#pragma mark - Initialization

- (id)init
{
    self = [super init];
    if (self) {
        self.translatesAutoresizingMaskIntoConstraints = NO;
        self.backgroundColor = [UIColor whiteColor];
        
        EBHConfig *myConfig = [EBHConfig sharedInstance];
        self.uiStrings = myConfig.ebhConfig[@"UIStrings"];

        [self setupViews];
        [self setupConstraints];
    }
    
    return self;
}

- (void)setupViews
{
    self.descriptionLabel = ({
        UILabel *label = [[UILabel alloc] init];
        label.translatesAutoresizingMaskIntoConstraints = NO;
        label.textColor = [UIColor darkGrayColor];
        label.font = [UIFont systemFontOfSize:16];
        label.text = self.uiStrings[@"DescriptionFieldLabel"];
        [label sizeToFit];
        label;
    });
    [self addSubview:self.descriptionLabel];
    
    self.addScreenshotLabel = ({
        UILabel *label = [[UILabel alloc] init];
        label.translatesAutoresizingMaskIntoConstraints = NO;
        label.textColor = [UIColor darkGrayColor];
        label.font = [UIFont systemFontOfSize:16];
        label.text = self.uiStrings[@"AddScreenshotsLabel"];
        [label sizeToFit];
        label;
    });
    [self addSubview:self.addScreenshotLabel];
    
    NSString *dismissButtonLabel = self.uiStrings[@"DismissButtonLabel"];
    self.bugReportTextView = ({
        EBH_SZTextView *textView = [[EBH_SZTextView alloc] init];
        textView.translatesAutoresizingMaskIntoConstraints = NO;
        textView.contentMode = UIViewContentModeLeft;
        textView.showsHorizontalScrollIndicator = NO;
        textView.directionalLockEnabled = YES;
        textView.layer.borderWidth = 0.5;
        textView.layer.borderColor = [UIColor lightGrayColor].CGColor;
        textView.textColor = [UIColor darkGrayColor];
        textView.font = [UIFont systemFontOfSize:14.0];
        textView.placeholder = self.uiStrings[@"DescriptionPlaceholder"];
        UIToolbar *toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 320, 40)];
        UIBarButtonItem *spacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                                                                                target:nil
                                                                                action:nil];
        UIBarButtonItem *dismissButton = [[UIBarButtonItem alloc] initWithTitle:dismissButtonLabel
                                                                          style:UIBarButtonItemStylePlain
                                                                         target:self
                                                                         action:@selector(dismissKeyboardButtonWasTapped:)];
        [toolbar setItems:@[spacer, dismissButton]];
        textView.inputAccessoryView = toolbar;
        textView;
    });
    [self addSubview:self.bugReportTextView];
    
    self.screenshotCollectionView = ({
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        
        if ([UIScreen mainScreen].bounds.size.height < 500) {
            flowLayout.itemSize = CGSizeMake(70.0, 118.0);
        }
        else {
            flowLayout.itemSize = CGSizeMake(124.0, 211.0);
        }
        
        flowLayout.minimumInteritemSpacing = 25.0;
        flowLayout.minimumLineSpacing = 25.0;
        UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero
                                                              collectionViewLayout:flowLayout];
        
        collectionView.backgroundColor = [UIColor clearColor];
        collectionView.contentInset = UIEdgeInsetsMake(0.0, 20.0, 0.0, 20.0);
        collectionView.translatesAutoresizingMaskIntoConstraints = NO;
        collectionView.directionalLockEnabled = YES;
        [collectionView registerClass:[EBHScreenshotCell class]
           forCellWithReuseIdentifier:NSStringFromClass([EBHScreenshotCell class])];
        collectionView;
    });
    [self addSubview:self.screenshotCollectionView];
    
    NSString *addScreenshotButtonTitle = self.uiStrings[@"AddScreenshotButtonTitle"];
    self.addNewScreenshotButton= ({
        EBHButton *button = [[EBHButton alloc] init];
        button.translatesAutoresizingMaskIntoConstraints = NO;
        [button setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor darkGrayColor] forState:UIControlStateHighlighted];
        button.titleLabel.font = [UIFont systemFontOfSize:14];
        [button setTitle:addScreenshotButtonTitle forState:UIControlStateNormal];
        [button setTitle:addScreenshotButtonTitle forState:UIControlStateHighlighted];
        [button addTarget:self
                   action:@selector(addNewScreenshotButtonWasTapped:)
         forControlEvents:UIControlEventTouchUpInside];
        button;
    });
    [self addSubview:self.addNewScreenshotButton];
    
    NSString *screenshotHelpButtonTitle = self.uiStrings[@"ScreenshotHelpButtonTitle"];
    self.howToScreenshotButton = ({
        EBHButton *button = [[EBHButton alloc] init];
        button.translatesAutoresizingMaskIntoConstraints = NO;
        [button setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
        button.titleLabel.font = [UIFont systemFontOfSize:14];
        [button setTitle:screenshotHelpButtonTitle forState:UIControlStateNormal];
        [button setTitle:screenshotHelpButtonTitle forState:UIControlStateHighlighted];
        [button addTarget:self
                   action:@selector(howToTakeAScreenShotWasTapped:)
         forControlEvents:UIControlEventTouchUpInside];
        button;
    });
    [self addSubview:self.howToScreenshotButton];
}

- (void)setupConstraints
{
    // Vertical constraints
    NSString *visualFormat = @"V:|-20-[_descriptionLabel(==22)]-4-[_bugReportTextView(<=62)]-20-[_addScreenshotLabel(==22)]-8-[_screenshotCollectionView]-20-[_addNewScreenshotButton(<=45)]-20-|";
    NSDictionary *views = NSDictionaryOfVariableBindings(_descriptionLabel,
                                                         _bugReportTextView,
                                                         _addScreenshotLabel,
                                                         _screenshotCollectionView,
                                                         _addNewScreenshotButton,
                                                         _howToScreenshotButton);
    NSArray *constraints = [NSLayoutConstraint constraintsWithVisualFormat:visualFormat
                                                                   options:NSLayoutFormatAlignAllLeft
                                                                   metrics:nil
                                                                     views:views];
    [self addConstraints:constraints];
    
    // Horizontal constraints
    visualFormat = @"|-20-[_bugReportTextView(>=280)]-20-|";
    constraints = [NSLayoutConstraint constraintsWithVisualFormat:visualFormat
                                                          options:0
                                                          metrics:nil
                                                            views:views];
    [self addConstraints:constraints];
    
    // All the left edges are aligned already. Snap these buttons to the right
    // side so they stretch.
    visualFormat = @"[_addNewScreenshotButton]-10-[_howToScreenshotButton]-|";
    constraints = [NSLayoutConstraint constraintsWithVisualFormat:visualFormat
                                                          options:NSLayoutFormatAlignAllBottom
                                                          metrics:nil
                                                            views:views];
    [self addConstraints:constraints];
    
    // Size constraints
    visualFormat = @"[_screenshotCollectionView(==_bugReportTextView)]";
    constraints = [NSLayoutConstraint constraintsWithVisualFormat:visualFormat
                                                          options:0
                                                          metrics:nil
                                                            views:views];
    [self addConstraints:constraints];
    
    visualFormat = @"[_addNewScreenshotButton(==_howToScreenshotButton)]";
    constraints = [NSLayoutConstraint constraintsWithVisualFormat:visualFormat
                                                          options:0
                                                          metrics:nil
                                                            views:views];
    [self addConstraints:constraints];
}

#pragma mark - Actions

- (void)dismissKeyboardButtonWasTapped:(id)sender
{
    [self endEditing:YES];
}

- (void)howToTakeAScreenShotWasTapped:(id)sender
{
    NSString *screenshotHelpModalTitle = self.uiStrings[@"ScreenshotHelpModalTitle"];
    NSString *screenshotHelpModalContent = self.uiStrings[@"ScreenshotHelpModalContent"];
    NSString *screenshotHelpModalDismissButtonTitle = self.uiStrings[@"ScreenshotHelpModalDismissButtonTitle"];

    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:screenshotHelpModalTitle
                                                    message:screenshotHelpModalContent
                                                   delegate:nil
                                          cancelButtonTitle:screenshotHelpModalDismissButtonTitle
                                          otherButtonTitles:nil];
    [alert show];
}

- (void)addNewScreenshotButtonWasTapped:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(submitBugViewAddNewScreenshotWasTapped:)]) {
        [self.delegate submitBugViewAddNewScreenshotWasTapped:self];
    }
}

@end
