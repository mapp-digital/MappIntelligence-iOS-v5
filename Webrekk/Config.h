//
//  Config.h
//  Webrekk
//
//  Created by Vladan Randjelovic on 15/01/2020.
//  Copyright © 2020 Stefan Stevanovic. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Log/WebtrekkLogger.h"

@protocol Config

//Webtrekk default configuration parameters:

@property NSDictionary *const trackIDs;
@property NSString *const trackDomain;
@property long *const requestsInterval;
@property WebtrekkLogLevelDescription * logLevel;
@property BOOL autoTracking;
@property NSURLSession *const urlSession;
@property NSInteger *const requestPerBatch;
@property BOOL batchSupport;
@property BOOL viewControllerAutoTracking;

-(void)setTrackIDs:(NSDictionary *const)trackIDs;
-(void)setTrackDomain:(NSString *const)trackDomain;
-(void)setRequestsInterval:(long *const)requestsInterval;
-(void)setLogLevel:(WebtrekkLogLevelDescription *)logLevel;
-(void)setAutoTracking:(BOOL)autoTracking;
-(void)setUrlSession:(NSURLSession *const)urlSession;
-(void)setRequestPerBatch:(NSInteger *const)requestPerBatch;
-(void)setBatchSupport:(BOOL)batchSupport;
-(void)setViewControllerAutoTracking:(BOOL)viewControllerAutoTracking;

@end
