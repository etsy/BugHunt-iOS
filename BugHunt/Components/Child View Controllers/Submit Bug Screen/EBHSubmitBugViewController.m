//
//  EBHSubmitBugViewController.m
//  BugHunt
//
//  Created by Christopher Constable on 6/11/14.
//  Copyright (c) 2014 Etsy. All rights reserved.
//

#import "EBHSubmitBugViewController.h"

#import "EBHScreenshotUtility.h"
#import "EBHNetworkManager.h"
#import "EBHConfig.h"

// Models
#import "EBHBugReport.h"
#import "EBHScreenshotDatasource.h"

// Views
#import "EBHSubmitBugView.h"
#import "EBHScreenshotCell.h"
#import "EBH_SZTextView.h"
#import "MBProgressHUD.h"

static const NSUInteger MaxNumberOfScreenshotsAllowed = 3;

@interface EBHSubmitBugViewController () <UIImagePickerControllerDelegate, UINavigationControllerDelegate, EBHSubmitBugViewDelegate>

@property (nonatomic, strong) UIBarButtonItem *submitBarButtonItem;
@property (nonatomic, strong) EBHScreenshotDatasource *screenshotDatasource;
@property (nonatomic, strong) EBHSubmitBugView *submitBugView;
@property (nonatomic, strong) NSMutableDictionary *uiStrings;

@end

@implementation EBHSubmitBugViewController

#pragma mark - Initialization 

- (void)loadView
{
    self.submitBugView = [[EBHSubmitBugView alloc] init];
    self.submitBugView.delegate = self;
    self.view = self.submitBugView;
    EBHConfig *ebhConfig = [EBHConfig sharedInstance];
    self.uiStrings = ebhConfig.ebhConfig[@"UIStrings"];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setupNavigationItem];
    
    UICollectionView *collectionView = self.submitBugView.screenshotCollectionView;
    self.screenshotDatasource = [[EBHScreenshotDatasource alloc] initWithCollectionView:collectionView];
    
    self.screenshotDatasource.screenshots = [NSMutableArray arrayWithArray:[EBHScreenshotUtility screenshots]];
}

- (void)setupNavigationItem
{
    self.submitBarButtonItem = [[UIBarButtonItem alloc] init];
    self.submitBarButtonItem.title = self.uiStrings[@"SubmitButtonTitle"];
    self.submitBarButtonItem.target = self;
    self.submitBarButtonItem.action = @selector(submitBugReportWasTapped:);
    NSDictionary *textAttributes = @{NSFontAttributeName: [UIFont systemFontOfSize:14],
                                     NSForegroundColorAttributeName: [UIColor blackColor]};
    [self.submitBarButtonItem setTitleTextAttributes:textAttributes
                                 forState:UIControlStateNormal];
    [self.submitBarButtonItem setTitleTextAttributes:textAttributes
                                 forState:UIControlStateHighlighted];
    self.navigationItem.rightBarButtonItem = self.submitBarButtonItem;
}

#pragma mark - UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *selectedScreenshot = info[UIImagePickerControllerOriginalImage];
    [self.screenshotDatasource.screenshots addObject:selectedScreenshot];
    
    NSUInteger insertionIndex = (self.screenshotDatasource.screenshots.count - 1);
    NSIndexPath *newIndexPath = [NSIndexPath indexPathForRow:insertionIndex inSection:0];
    [self.submitBugView.screenshotCollectionView insertItemsAtIndexPaths:@[newIndexPath]];
    
    [self dismissViewControllerAnimated:YES completion:^{
        [self.submitBugView.screenshotCollectionView scrollToItemAtIndexPath:newIndexPath
                                              atScrollPosition:UICollectionViewScrollPositionLeft
                                                      animated:YES];
    }];
}

#pragma mark - EBHSubmitBugViewDelegate

- (void)submitBugViewAddNewScreenshotWasTapped:(EBHSubmitBugView *)submitBugView
{
    NSString *errorAlertTitle = self.uiStrings[@"ImagePickerErrorAlertTitle"];
    NSString *errorAlertContent = self.uiStrings[@"ImagePickerErrorAlertContent"];
    NSString *errorAlertCancelButtonTitle = self.uiStrings[@"ErrorAlertCancelButtonTitle"];
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
        UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
        imagePickerController.delegate = self;
        [self presentViewController:imagePickerController animated:YES completion:nil];
    }
    else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:errorAlertTitle
                                                        message:errorAlertContent
                                                       delegate:nil
                                              cancelButtonTitle:errorAlertCancelButtonTitle
                                              otherButtonTitles:nil];
        [alert show];
    }
}

#pragma mark - UI

- (BOOL)validateReportFields
{
    BOOL fieldsAreValid = YES;
    NSString *errorTitle;
    NSString *errorMessage;
    
    if (self.submitBugView.bugReportTextView.text.length == 0) {
        fieldsAreValid = NO;
        errorTitle = self.uiStrings[@"MissingDescriptionErrorTitle"];
        errorMessage = self.uiStrings[@"MissingDescriptionErrorMessage"];
    }
    else if (self.screenshotDatasource.screenshots.count > MaxNumberOfScreenshotsAllowed) {
        fieldsAreValid = NO;
        errorTitle = self.uiStrings[@"TooManyScreenshotsErrorTitle"];
        errorMessage = self.uiStrings[@"TooManyScreenshotsErrorMessageBeforeScreenshotLimit"];
        errorMessage = [errorMessage stringByAppendingString:[NSString stringWithFormat:@" %lx ", (unsigned long) MaxNumberOfScreenshotsAllowed]];
        errorMessage = [errorMessage stringByAppendingString:self.uiStrings[@"TooManyScreenshotsErrorMessageAfterScreenshotLimit"]];
    }
    else if (self.screenshotDatasource.screenshots.count < 1) {
        fieldsAreValid = NO;
        errorTitle = self.uiStrings[@"NoScreenshotsErrorTitle"];
        errorMessage = self.uiStrings[@"NoScreenshotsErrorMessage"];
    }
    
    if (fieldsAreValid == NO) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:errorTitle
                                                            message:errorMessage
                                                           delegate:nil
                                                  cancelButtonTitle:self.uiStrings[@"ErrorAlertCancelButtonTitle"]
                                                  otherButtonTitles:nil];
        [alertView show];
    }
    
    return fieldsAreValid;
}

#pragma mark - Actions

- (void)submitBugReportWasTapped:(id)sender
{
    BOOL fieldsAreValid = [self validateReportFields];
    if (fieldsAreValid == YES) {
        
        EBHBugReport *newBugReport = [[EBHBugReport alloc] init];
        newBugReport.bugDescription = self.submitBugView.bugReportTextView.text;
        newBugReport.screenshots = self.screenshotDatasource.screenshots;
        
        EBHCreateNewIssueCompletionBlock completion = ^(NSError *error){
            if (error == nil) {
                MBProgressHUD *hud = [MBProgressHUD HUDForView:self.navigationController.view];
                hud.mode = MBProgressHUDModeText;
                hud.labelFont = [UIFont systemFontOfSize:19];
                hud.labelText = self.uiStrings[@"SubmissionSuccessTitle"];
                hud.detailsLabelFont = [UIFont systemFontOfSize:17];
                hud.detailsLabelText = self.uiStrings[@"SubmissionSuccessMessage"];
                
                // Dismiss on tap
                UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self.containerDelegate action:@selector(childViewControllerWantsToClose:)];
                [hud addGestureRecognizer:tapGesture];
                
                // Dismiss after 2.5 seconds
               __typeof__(self) __weak weakSelf = self;
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    if (weakSelf && [self.containerDelegate respondsToSelector:@selector(childViewControllerWantsToClose:)]) {
                        [self.containerDelegate childViewControllerWantsToClose:self];
                    }
                });
            }
            else {
                MBProgressHUD *hud = [MBProgressHUD HUDForView:self.view];
                hud.mode = MBProgressHUDModeText;
                hud.labelText = self.uiStrings[@"NetworkErrorTitle"];
                [hud hide:YES afterDelay:2.0];
            }
        };
        
        BOOL willMakeRequest = [[EBHNetworkManager networkCommunicator] createBugHuntIssue:newBugReport
                                                                                  completion:completion];
        if (willMakeRequest == YES) {
            [self.view endEditing:YES];
            self.submitBarButtonItem.enabled = NO;
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
            hud.mode = MBProgressHUDModeIndeterminate;
            hud.dimBackground = YES;
            hud.labelText = self.uiStrings[@"SubmittingTitle"];
        }
    }
}

@end
