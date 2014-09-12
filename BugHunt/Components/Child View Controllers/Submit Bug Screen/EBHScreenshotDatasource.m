//
//  EBHScreenshotDatasource.m
//  BugHuntSample
//
//  Created by Christopher Constable on 6/27/14.
//  Copyright (c) 2014 Etsy. All rights reserved.
//

#import "EBHScreenshotDatasource.h"
#import "EBHScreenshotCell.h"

@interface EBHScreenshotDatasource () <EBHScreenshotCellDelegate>

@property (nonatomic, weak) UICollectionView *collectionView;

@end

@implementation EBHScreenshotDatasource

#pragma mark - Initialization

- (instancetype)initWithCollectionView:(UICollectionView *)collectionView
{
    self = [super init];
    if (self) {
        self.collectionView = collectionView;
        self.collectionView.dataSource = self;
    }
    
    return self;
}

#pragma mark - UICollectionViewDatasource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.screenshots.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    EBHScreenshotCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([EBHScreenshotCell class]) forIndexPath:indexPath];
    cell.screenshotImageView.image = self.screenshots[indexPath.row];
    cell.delegate = self;
    
    return cell;
}

#pragma mark - EBHScreenshotCellDelegate

- (void)screenshotCellDeleteWasTapped:(EBHScreenshotCell *)cell
{
    NSIndexPath *deletedIndex = [self.collectionView indexPathForCell:cell];
    [self.screenshots removeObjectAtIndex:deletedIndex.row];
    [self.collectionView deleteItemsAtIndexPaths:@[deletedIndex]];
}

@end
