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
    
   NSData *encodedObject = [NSKeyedArchiver archivedDataWithRootObject:self requiringSecureCoding:NO error:NULL];
   NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
   [defaults setObject:encodedObject forKey:key_webtrekk_default_configuration];
   [defaults synchronize];
    
    [self logConfig];

    return self;
}

-(instancetype) initWithDictionary:(NSDictionary *) dictionary {
    
    self = [super init];

    for (id key in [dictionary allKeys]) {
        
        self.autoTracking = [dictionary valueForKey:key];
        self.batchSupport = [dictionary valueForKey:key];
        self.requestPerBatch = [dictionary valueForKey:key];
        self.requestsInterval = [dictionary valueForKey:key];
        self.logLevel = [dictionary valueForKey:key];
        self.trackIDs = [dictionary objectForKey:key];
        self.trackDomain = [dictionary objectForKey:key];
        self.viewControllerAutoTracking = [dictionary valueForKey:key];
    }
    
    NSData *encodedObject = [NSKeyedArchiver archivedDataWithRootObject:self requiringSecureCoding:NO error:NULL];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:encodedObject forKey:key_webtrekk_default_configuration];
    [defaults synchronize];
    
    [self logConfig];

     return self;
}

-(void)encodeWithCoder:(NSCoder *) encoder {
    
    [encoder encodeInt64:self.requestPerBatch forKey:key_requestPerBatch];
    [encoder encodeBool:self.autoTracking forKey:key_autoTracking];
    [encoder encodeBool:self.batchSupport forKey:key_batchSupport];
    [encoder encodeInt64:self.requestsInterval forKey:key_requestsInterval];
    [encoder encodeBool:self.viewControllerAutoTracking forKey:key_viewControllerAutoTracking];
    [encoder encodeInt64:self.logLevel forKey:key_logLevel];
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
    [[WebtrekkLogger shared] logObj:([@"Number of requests per batch: "  stringByAppendingFormat:@"%@", [NSString stringWithFormat:@"%ld", (long)self.requestPerBatch]]) forDescription:self.logLevel];
    [[WebtrekkLogger shared] logObj:([@"Request time interval in seconds: " stringByAppendingFormat:@"%@", [NSString stringWithFormat:@"%ld", self.requestsInterval]]) forDescription:self.logLevel];
    [[WebtrekkLogger shared] logObj:([@"Log Level is:  " stringByAppendingFormat:@"%@", [NSString stringWithFormat:@"%ld", (long)self.logLevel]]) forDescription:self.logLevel];
    [[WebtrekkLogger shared] logObj:([@"Tracking IDs: " stringByAppendingFormat:@"%@", self.trackIDs]) forDescription:self.logLevel];
    [[WebtrekkLogger shared] logObj:([@"Tracking domain is: " stringByAppendingFormat:@"%@", self.trackDomain]) forDescription:self.logLevel];
    [[WebtrekkLogger shared] logObj:([@"View Controller auto tracking is enabbled: " stringByAppendingFormat:self.viewControllerAutoTracking ? @"Yes" : @"No"]) forDescription:self.logLevel];

}


@end
