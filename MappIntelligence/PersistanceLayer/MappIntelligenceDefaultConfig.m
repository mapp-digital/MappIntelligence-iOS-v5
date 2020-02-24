//
//  MappIntelligenceDefaultConfig.m
//  Webrekk
//
//  Created by Vladan Randjelovic on 15/01/2020.
//  Copyright © 2020 Stefan Stevanovic. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MappIntelligenceDefaultConfig.h"
#define key_trackIDs @"track_ids"
#define key_trackDomain @"track_domain"
#define key_logLevel @"log_level"
#define key_requestsInterval @"requests_interval"
#define key_autoTracking @"auto_tracking"
#define key_requestPerQueue @"request_per_batch"
#define key_batchSupport @"batch_support"
#define key_viewControllerAutoTracking @"view_controller_auto_tracking"
#define key_MappIntelligence_default_configuration @"defaultConfiguration"
#import "DefaultTracker.h"

@implementation MappIntelligenceDefaultConfig : NSObject

@synthesize autoTracking;

@synthesize batchSupport;

@synthesize requestPerQueue;

@synthesize requestsInterval;

/** Tracking domain is MANDATORY field */
@synthesize trackDomain;

/** Track ID is a mandatory field and must be entered at least one for the configuration to be saved */
@synthesize trackIDs;

@synthesize viewControllerAutoTracking;

@synthesize logLevel;
@synthesize tracker;

-(instancetype)init {
    
    self = [super init];
    self.autoTracking = YES;
    self.batchSupport = NO;
    self.requestPerQueue = 10;
    self.requestsInterval = 900;
    self.logLevel = kMappIntelligenceLogLevelDescriptionDebug;
    self.trackIDs = [[NSArray alloc] init];
    self.trackDomain = @"https://q3.MappIntelligence.net";
    self.viewControllerAutoTracking = YES;
    self.tracker = [[DefaultTracker alloc] init];
    [self saveToUserDefaults];
    [self logConfig];

    return self;
}

-(instancetype) initWithDictionary:(NSDictionary *) dictionary {
    
    self = [super init];

    self.autoTracking = [[dictionary valueForKey:key_autoTracking] boolValue];
        self.batchSupport = [[dictionary valueForKey:key_batchSupport] boolValue];
    if ([[dictionary valueForKey:key_requestPerQueue] integerValue] == 0) {
        self.requestPerQueue = 10;
    } else {
        self.requestPerQueue = [[dictionary valueForKey:key_requestPerQueue] integerValue];
    }
    if ([[dictionary valueForKey:key_requestsInterval] longValue] == 0) {
        self.requestsInterval = 900;
    } else {
        self.requestsInterval = [[dictionary valueForKey:key_requestsInterval] longValue];
    }
    if ([[dictionary valueForKey:key_logLevel] integerValue] == 0) {
        self.logLevel = kMappIntelligenceLogLevelDescriptionDebug;
    } else {
        self.logLevel = [[dictionary valueForKey:key_logLevel] integerValue];
    }
    if (([dictionary objectForKey:key_trackIDs] == [NSNull null] )|| [[dictionary objectForKey:key_trackIDs] isEqualToString:@""]) {
            [[MappIntelligenceLogger shared] logObj:(@"You must enter at least one tracking ID to save the configuration. ") forDescription:kMappIntelligenceLogLevelDescriptionWarning];
    } else {
        self.trackIDs = [[dictionary objectForKey:key_trackIDs] componentsSeparatedByString:@","];
    }
    if ([[dictionary objectForKey:key_trackDomain] isEqualToString:@""]) {
            [[MappIntelligenceLogger shared] logObj:(@"You must enter tracking domain to save the configuration. ") forDescription:kMappIntelligenceLogLevelDescriptionWarning];
    } else {
        self.trackDomain = [dictionary objectForKey:key_trackDomain];
    }
        self.viewControllerAutoTracking = [[dictionary valueForKey:key_viewControllerAutoTracking] boolValue];
    
        [self saveToUserDefaults];
        [self logConfig];
     return self;
}

-(void)encodeWithCoder:(NSCoder *) encoder {
    
    [encoder encodeInt64:self.requestPerQueue forKey:key_requestPerQueue];
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
        self.requestPerQueue = [coder decodeIntForKey:key_requestPerQueue];
        self.requestsInterval = [coder decodeIntForKey:key_requestsInterval];
        self.trackDomain = [coder decodeObjectForKey:key_trackDomain];
        self.logLevel = [coder decodeIntForKey:key_logLevel];
        self.trackIDs = [coder decodeObjectForKey:key_trackIDs];
        self.viewControllerAutoTracking = [coder decodeBoolForKey:key_viewControllerAutoTracking];
    }
    return self;
}

-(void) logConfig {
    
    [[MappIntelligenceLogger shared] logObj:([@"Auto Tracking is enabled: " stringByAppendingFormat:self.autoTracking ? @"Yes" : @"No"]) forDescription:self.logLevel];
    [[MappIntelligenceLogger shared] logObj:([@"Batch Support is enabled: " stringByAppendingFormat:self.batchSupport ? @"Yes" :@"No"]) forDescription:self.logLevel];
    [self validateNumberOfRequestsPerQueue:self.requestPerQueue];
    [[MappIntelligenceLogger shared] logObj:([@"Number of requests in queue: "  stringByAppendingFormat:@"%@", [NSString stringWithFormat:@"%ld", (long)self.requestPerQueue]]) forDescription:self.logLevel];
    [self validateRequestTimeInterval:self.requestsInterval];
    [[MappIntelligenceLogger shared] logObj:([@"Request time interval in minutes: " stringByAppendingFormat:@"%@", [NSString stringWithFormat:@"%f", (self.requestsInterval/60.0)]]) forDescription:self.logLevel];
    [[MappIntelligenceLogger shared] logObj:([@"Log Level is:  " stringByAppendingFormat:@"%@", [[MappIntelligenceLogger shared] logLevelFor: self.logLevel]]) forDescription:self.logLevel];
    [[MappIntelligenceLogger shared] logObj:([@"Tracking IDs: " stringByAppendingFormat:@"%@", self.trackIDs]) forDescription:self.logLevel];
    [self trackDomainValidation:self.trackDomain];
    [[MappIntelligenceLogger shared] logObj:([@"Tracking domain is: " stringByAppendingFormat:@"%@", self.trackDomain]) forDescription:self.logLevel];
    [[MappIntelligenceLogger shared] logObj:([@"View Controller auto tracking is enabbled: " stringByAppendingFormat:self.viewControllerAutoTracking ? @"Yes" : @"No"]) forDescription:self.logLevel];
    @try {
        [self.tracker generateEverId];
    } @catch (NSException *exception) {
        NSLog(@"Exception %@", exception);
    } @finally {
//        [[MappIntelligenceLogger shared] logObj:([@"Ever ID is: " stringByAppendingFormat:@"%@", [self.tracker generateEverId]]) forDescription:self.logLevel];
    }
    
}

-(void)validateNumberOfRequestsPerQueue:(NSInteger) numberOfRequests {
    if (numberOfRequests > 10000) {
        NSLog(@"Number of requests can't be grater than 10000, will be returned to default (10).");
        self.requestPerQueue = 10;
    }
}

-(void)validateRequestTimeInterval:(NSInteger) timeInterval {
    if (timeInterval > 3600.0) {
        NSLog(@"Request time interval can't be more than 3600 seconds (60 minutes), will be reset to default (15 minutes).");
        self.requestsInterval = 900.0;
    }
}

-(BOOL)trackDomainValidation:(NSString *)trackDomain {
    
    NSURL *urlFormatDomain = [NSURL URLWithString:trackDomain];

    if ([trackDomain isEqualToString:@""]) {
        
        if (!urlFormatDomain.scheme) {
            self.trackDomain = [@"https://" stringByAppendingString:trackDomain];
        } else if (!(urlFormatDomain && urlFormatDomain.scheme && urlFormatDomain.host)) {
            NSLog(@"You must enter a valid url format for tracking domain!");
        }
    }
    
    return urlFormatDomain && urlFormatDomain.scheme && urlFormatDomain.host;
    
}

-(void) saveToUserDefaults {
    
    NSData *encodedObject = [NSKeyedArchiver archivedDataWithRootObject:self requiringSecureCoding:NO error:NULL];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:encodedObject forKey:key_MappIntelligence_default_configuration];
    [defaults synchronize];
}

@end
