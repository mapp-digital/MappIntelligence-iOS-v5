//
//  WebtrekkDefaultConfig.m
//  Webrekk
//
//  Created by Vladan Randjelovic on 15/01/2020.
//  Copyright © 2020 Stefan Stevanovic. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WebtrekkDefaultConfig.h"
#define key_trackIDs @"track_ids"
#define key_trackDomain @"track_domain"
#define key_logLevel @"log_level"
#define key_requestsInterval @"requests_interval"
#define key_autoTracking @"auto_tracking"
#define key_requestPerBatch @"request_per_batch"
#define key_batchSupport @"batch_support"
#define key_viewControllerAutoTracking @"view_controller_auto_tracking"
#define key_webtrekk_default_configuration @"defaultConfiguration"


@implementation WebtrekkDefaultConfig : NSObject

@synthesize autoTracking;

@synthesize batchSupport;

@synthesize requestPerBatch;

@synthesize requestsInterval;

@synthesize trackDomain;

@synthesize trackIDs;

@synthesize viewControllerAutoTracking;

@synthesize logLevel;

-(instancetype)init {
    self = [super init];
    self.autoTracking = YES;
    self.batchSupport = NO;
    self.requestPerBatch = 5000;
    self.requestsInterval = 900;
    self.logLevel = kWebtrekkLogLevelDescriptionDebug;
    self.trackIDs = [[NSDictionary alloc] init];
    self.trackDomain = @"https://q3.webtrekk.net";
    self.viewControllerAutoTracking = YES;
   
    [self logConfig];

    return self;
}

-(instancetype) initWithDictionary:(NSDictionary *) dictionary {
    
    self = [super init];
    for (id key in dictionary) {
        self.autoTracking = [dictionary objectForKey:key_autoTracking];
        self.batchSupport = [dictionary objectForKey:key_batchSupport];
        self.requestPerBatch = [dictionary objectForKey:key_requestPerBatch];
        self.requestsInterval = [dictionary objectForKey:key_requestsInterval];
        self.logLevel = [dictionary objectForKey:key_logLevel];
        self.trackIDs = [dictionary objectForKey:key_trackIDs];
        self.trackDomain = [dictionary objectForKey:key_trackDomain];
        self.viewControllerAutoTracking = [dictionary objectForKey:key_viewControllerAutoTracking];
    }
    
     [self logConfig];

     return self;
}

-(void)encodeWithCoder:(NSCoder *) encoder {
    [encoder encodeInt:self.requestPerBatch forKey:key_requestPerBatch];
    [encoder encodeBool:self.autoTracking forKey:key_autoTracking];
    [encoder encodeBool:self.batchSupport forKey:key_batchSupport];
    [encoder encodeInt:self.requestsInterval forKey:key_requestsInterval];
    [encoder encodeBool:self.viewControllerAutoTracking forKey:key_viewControllerAutoTracking];
    [encoder encodeInt:self.logLevel forKey:key_logLevel];
    [encoder encodeObject:self.trackIDs forKey:key_trackIDs];
    [encoder encodeObject:self.trackDomain forKey:key_trackDomain];
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    if (self = [super init]) {
        self.autoTracking = [coder decodeBoolForKey:key_autoTracking];
        self.batchSupport = [coder decodeBoolForKey:key_batchSupport];
        self.requestPerBatch = [coder decodeIntForKey:key_requestPerBatch];
        self.requestsInterval = [coder decodeIntForKey:key_requestsInterval];
        self.trackDomain = [coder decodeObjectForKey:key_trackDomain];
        self.logLevel = [coder decodeIntForKey:key_logLevel];
        self.trackIDs = [coder decodeObjectForKey:key_trackIDs];
        self.viewControllerAutoTracking = [coder decodeBoolForKey:key_viewControllerAutoTracking];
    }
    return self;
}
-(void) logConfig {
    [[WebtrekkLogger shared] logObj:([@"Auto Tracking is enabled: " stringByAppendingFormat:self.autoTracking ? @"Yes" : @"No"]) forDescription:self.logLevel];
    [[WebtrekkLogger shared] logObj:([@"Batch Support is enabled: " stringByAppendingFormat:self.batchSupport ? @"Yes" :@"No"]) forDescription:self.logLevel];
    [[WebtrekkLogger shared] logObj:([@"Number of requests per batch: "  stringByAppendingFormat:@"%@", [NSString stringWithFormat:@"%ld", (long)self.requestPerBatch]]) forDescription:kWebtrekkLogLevelDescriptionDebug];
    [[WebtrekkLogger shared] logObj:([@"Request time interval in seconds: " stringByAppendingFormat:@"%@", [NSString stringWithFormat:@"%ld", self.requestsInterval]]) forDescription:self.logLevel];
    [[WebtrekkLogger shared] logObj:([@"Log Level is:  " stringByAppendingFormat:@"%@", [NSString stringWithFormat:@"%ld", (long)self.logLevel]]) forDescription:self.logLevel];
    [[WebtrekkLogger shared] logObj:([@"Tracking IDs: " stringByAppendingFormat:@"%@", self.trackIDs]) forDescription:self.logLevel];
    [[WebtrekkLogger shared] logObj:([@"Tracking domain is: " stringByAppendingFormat:@"%@", self.trackDomain]) forDescription:self.logLevel];
    [[WebtrekkLogger shared] logObj:([@"View Controller auto tracking is enabbled: " stringByAppendingFormat:self.viewControllerAutoTracking ? @"Yes" : @"No"]) forDescription:self.logLevel];
}


@end
