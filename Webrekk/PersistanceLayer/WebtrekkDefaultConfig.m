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
@end
