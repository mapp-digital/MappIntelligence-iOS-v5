//
//  Webrekk.m
//  Webrekk
//
//  Created by Stefan Stevanovic on 1/3/20.
//  Copyright © 2020 Stefan Stevanovic. All rights reserved.
//

#import "MappIntelligence.h"
#import "MappIntelligenceDataService.h"
#import "MappIntelligenceDefaultConfig.h"
#import "MappIntelligenceLogger.h"

@interface MappIntelligence()

@property MappIntelligenceDataService *dataService;

@property MappIntelligenceDefaultConfig * configuration;

@end

@implementation MappIntelligence
static MappIntelligence *sharedInstance = nil;
static MappIntelligenceDefaultConfig * config = nil;

/**
MappIntelligence  instance
@brief Method for getting a singleton instance of MappIntelligence. Called inside AppDelegate for initializing MappIntelligence SDK
@code
 #Swift
MappIntelligence.sharedMappIntelligence()
 #Objective C
[MappIntelligence sharedMappIntelligence];
@endcode
@return MappIntelligence an Instance Type of MappIntelligence.
*/

+(id) sharedMappIntelligence {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
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

-(id) init {
    if (!sharedInstance) {
        sharedInstance = [super init];
        _dataService = [[MappIntelligenceDataService alloc]init];
        _configuration = [[MappIntelligenceDefaultConfig alloc] init];
    }
    return sharedInstance;
}

@end
