//
//  WebtrekkDefaultConfig.m
//  Webrekk
//
//  Created by Vladan Randjelovic on 15/01/2020.
//  Copyright © 2020 Stefan Stevanovic. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Config.h"

#define key_trackIDs @"track_ids"
#define key_trackDomain @"track_domain"
#define key_logLevel @"log_level"
#define key_requestsInterval @"requests_interval"
#define key_autoTracking @"auto_tracking"
#define key_urlSession @"url_session"
#define key_requestPerBatch @"request_per_batch"
#define key_batchSupport @"batch_support"
#define key_viewControllerAutoTracking @"view_controller_auto_tracking"




@interface WebtrekkDefaultConfig: NSObject <Config>

@end

@implementation WebtrekkDefaultConfig : NSObject

@synthesize autoTracking;

@synthesize batchSupport;

@synthesize requestPerBatch;

@synthesize requestsInterval;

@synthesize trackDomain;

@synthesize trackIDs;

@synthesize urlSession;

@synthesize viewControllerAutoTracking;

@synthesize logLevel;

-(instancetype)init {
    self = [super init];
    return self;
}
// Setters for configuration parameters with adding them to UserDefaults:

-(void)setTrackIDs:(NSDictionary *)trackIDs {
    self.trackIDs = trackIDs;
    
    NSUserDefaults * standardUserDefaults = [NSUserDefaults standardUserDefaults];
    if (standardUserDefaults) {
        [standardUserDefaults setObject:self.trackIDs forKey:key_trackIDs];
        [standardUserDefaults synchronize];
    }
}

-(void)setTrackDomain:(NSString *)trackDomain {
    self.trackDomain = trackDomain;
    
    NSUserDefaults * standardUserDefaults = [NSUserDefaults standardUserDefaults];
    if (standardUserDefaults) {
        [standardUserDefaults setObject:self.trackDomain forKey:key_trackDomain];
        [standardUserDefaults synchronize];
    }
}

-(void)setUrlSession:(NSURLSession *)urlSession {
    self.urlSession = urlSession;
    
    NSUserDefaults * standardUserDefaults = [NSUserDefaults standardUserDefaults];
    if (standardUserDefaults) {
        [standardUserDefaults setObject:self.urlSession forKey:key_urlSession];
        [standardUserDefaults synchronize];
    }
}

-(void)setRequestPerBatch:(NSInteger *)requestPerBatch {
    self.requestPerBatch = requestPerBatch;
    
    NSUserDefaults * standardUserDefaults = [NSUserDefaults standardUserDefaults];
    if (standardUserDefaults) {
        [standardUserDefaults setInteger:*(self.requestPerBatch) forKey:key_requestPerBatch];
        [standardUserDefaults synchronize];
    }
}

- (void)setAutoTracking:(BOOL)autoTracking {
    self.autoTracking = autoTracking;
    
    NSUserDefaults * standardUserDefaults = [NSUserDefaults standardUserDefaults];
    if (standardUserDefaults) {
        [standardUserDefaults setBool:self.autoTracking forKey:key_autoTracking];
        [standardUserDefaults synchronize];
    }
}

- (void)setBatchSupport:(BOOL)batchSupport {
    self.batchSupport = batchSupport;
    
    NSUserDefaults * standardUserDefaults = [NSUserDefaults standardUserDefaults];
    if (standardUserDefaults) {
        [standardUserDefaults setBool:self.batchSupport forKey:key_batchSupport];
        [standardUserDefaults synchronize];
    }
}

-(void)setRequestsInterval:(long *) requestsInterval {
    self.requestsInterval = requestsInterval;
    NSUserDefaults * standardUserDefaults = [NSUserDefaults standardUserDefaults];
    if (standardUserDefaults) {
        [standardUserDefaults setObject:[NSNumber numberWithLong: *(self.requestsInterval)] forKey:key_requestsInterval];
        [standardUserDefaults synchronize];
    }
}

- (void)setViewControllerAutoTracking:(BOOL)viewControllerAutoTracking {
    self.viewControllerAutoTracking = viewControllerAutoTracking;
    
    NSUserDefaults * standardUserDefaults = [NSUserDefaults standardUserDefaults];
    if (standardUserDefaults) {
        [standardUserDefaults setBool:self.viewControllerAutoTracking forKey:key_viewControllerAutoTracking];
        [standardUserDefaults synchronize];
    }
}

// Getters:

-(void)setLogLevel:(WebtrekkLogLevelDescription *)logLevel {
    self.logLevel = logLevel;
}

- (BOOL)autoTracking {
    return autoTracking;
}

- (BOOL)batchSupport {
    return batchSupport;
}

- (NSInteger *)requestPerBatch {
    return requestPerBatch;
}

- (NSDictionary *)trackIDs {
    return trackIDs;
}

- (NSString *)trackDomain {
    return trackDomain;
}

- (NSURLSession *)urlSession {
    return urlSession;
}

- (BOOL)viewControllerAutoTracking {
    return viewControllerAutoTracking;
}

-(WebtrekkLogLevelDescription *)logLevel {
    return logLevel;
}

@end
