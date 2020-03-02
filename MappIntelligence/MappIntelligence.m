//
//  Webrekk.m
//  Webrekk
//
//  Created by Stefan Stevanovic on 1/3/20.
//  Copyright © 2020 Stefan Stevanovic. All rights reserved.
//

#import "MappIntelligence.h"
#import "MappIntelligenceDefaultConfig.h"

@interface MappIntelligence()

//@property MappIntelligenceDataService *dataService;
@property MappIntelligenceDefaultConfig * configuration;
@property DefaultTracker *tracker;

@end

@implementation MappIntelligence
static MappIntelligence *sharedInstance = nil;
static MappIntelligenceDefaultConfig * config = nil;

@synthesize tracker;

-(id) init {
    if (!sharedInstance) {
        sharedInstance = [super init];
//        _dataService = [[MappIntelligenceDataService alloc]init];
        config = [[MappIntelligenceDefaultConfig alloc] init];
        tracker = [[DefaultTracker alloc] init];
    }
    return sharedInstance;
}

+ (nullable instancetype)shared
{
    static MappIntelligence *shared = nil;
    
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        
        shared = [[MappIntelligence alloc] init];
    });
    
    return shared;
}

/** Method for setting up the Mapp Intelligence configuration by user.
 @brief Call this methond in your application to allow user to configue tracking.
 @param dictionary NSDictionary which contains user input configuration, that look like the example below.
@code
 class YourAppViewController
 var dictionary = [NSString: Any]()
 {
 func setConfiguration(autoTracking: Bool, batchSupport: Bool, requestsPerBatch: Int, requestsInterval: Float, logLevel:Int,
                   trackingDomain: String, trackingIDs: String, viewControllerAutoTracking: Bool) {
 dictionary = ["auto_tracking": autoTracking, "batch_support": batchSupport, "request_per_batch": requestsPerBatch, "requests_interval": requestsInterval, "log_level": logLevel, "track_domain": trackingDomain,
               "track_ids": trackingIDs, "view_controller_auto_tracking": viewControllerAutoTracking]
 MappIntelligence.setConfigurationWith(dictionary)
 }
 @endcode
 @attention Dictionary parameters "trackingIDs" and "trackDomain" are mandatory and needed for configuration to be saved.
 */
+(void) setConfigurationWith: (NSDictionary *) dictionary {
    NSData * dictData = [NSKeyedArchiver archivedDataWithRootObject:dictionary requiringSecureCoding:NO error:NULL];
    NSDictionary *dict = [NSKeyedUnarchiver unarchiveObjectWithData:dictData];
    config = [[MappIntelligenceDefaultConfig alloc] initWithDictionary: dict];
}

-(void)trackPage:(UIViewController*) controller {
    [tracker track:controller];
}

-(void)initWithConfiguration:(NSArray *)trackIDs onDomain:(NSString *)trackDomain withAutotrackingEnabled:(BOOL)autoTracking requestTimeout:(NSTimeInterval)requestTimeout numberOfRequests:(NSInteger)numberOfRequestInQueue batchSupportEnabled:(BOOL)batchSupport viewControllerAutoTrackingEnabled:(BOOL)viewControllerAutoTracking andLogLevel:(enum MappIntelligenceLogLevelDescription)logLevel {
    [config setLogLevel:logLevel];
    [config setTrackIDs:trackIDs];
    [config setTrackDomain:trackDomain];
    [config setAutoTracking:autoTracking];
    [config setBatchSupport:batchSupport];
    [config setViewControllerAutoTracking:viewControllerAutoTracking];
    [config setrequestPerQueue:numberOfRequestInQueue];
    [config setRequestsInterval:requestTimeout];
}

@end
