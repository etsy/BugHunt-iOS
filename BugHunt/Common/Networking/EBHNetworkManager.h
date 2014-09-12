//
//  EBHNetworkManager.h
//  BugHuntSample
//
//  Created by Christopher Constable on 6/24/14.
//  Copyright (c) 2014 Etsy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EBHNetworkCommunicator.h"

/**
 *  The EBHNetworkManager owns the EBHNetworkCommunicator object
 *  that is used to make requests. It's role is exposing the
 *  EBHNetworkCommunicator to the module.
 */
@interface EBHNetworkManager : NSObject

/**
 *  EBHNetworkCommunicator object that is used to communicate with the
 *  backend.
 */
@property (nonatomic, strong) id<EBHNetworkCommunicator> networkCommunicator;

/**
 *  Convenience method for accessing the networkCommunicator property.
 *
 *  @return EBHNetworkCommunicator object that is used to communicate 
 *          with the backend.
 */
+ (id<EBHNetworkCommunicator>)networkCommunicator;

/**
 *  Shared instance. Use this instead of creating new instances.
 *
 *  @return Shared instance of EBHNetworkManager.
 */
+ (instancetype)sharedManager;

@end
