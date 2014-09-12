//
//  EBHScreenshotDatasource.h
//  BugHuntSample
//
//  Created by Christopher Constable on 6/27/14.
//  Copyright (c) 2014 Etsy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EBHScreenshotDatasource : NSObject <UICollectionViewDataSource>

@property (nonatomic, strong) NSMutableArray *screenshots;

- (instancetype)initWithCollectionView:(UICollectionView *)collectionView;

@end
