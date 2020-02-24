//
//  Config.h
//  Webrekk
//
//  Created by Vladan Randjelovic on 15/01/2020.
//  Copyright © 2020 Stefan Stevanovic. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Log/MappIntelligenceLogger.h"
@protocol Config

//MappIntelligence default configuration parameters:

@property NSArray *const trackIDs;
@property NSString *const trackDomain;
@property NSTimeInterval const requestsInterval;
@property MappIntelligenceLogLevelDescription logLevel;
@property BOOL autoTracking;
@property NSInteger const requestPerQueue;
@property BOOL batchSupport;
@property BOOL viewControllerAutoTracking;

-(void)setTrackIDs:(NSArray *const)trackIDs;
-(void)setTrackDomain:(NSString *const)trackDomain;
-(void)setRequestsInterval:(NSTimeInterval const)requestsInterval;
-(void)setLogLevel:(MappIntelligenceLogLevelDescription)logLevel;
-(void)setAutoTracking:(BOOL)autoTracking;
-(void)setrequestPerQueue:(NSInteger const)requestPerQueue;
-(void)setBatchSupport:(BOOL)batchSupport;
-(void)setViewControllerAutoTracking:(BOOL)viewControllerAutoTracking;

@end
