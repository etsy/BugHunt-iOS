//
//  EBHTask.h
//  BugHuntSample
//
//  Created by Christopher Constable on 6/20/14.
//  Copyright (c) 2014 Etsy. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  Task model.
 */
@interface EBHTask : NSObject

@property (nonatomic, copy) NSString *taskTitle;
@property (nonatomic, copy) NSString *taskDescription;

@end
