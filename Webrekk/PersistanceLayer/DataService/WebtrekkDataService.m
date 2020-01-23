//
//  WebtrekkDataService.m
//  Webrekk
//
//  Created by Vladan Randjelovic on 15/01/2020.
//  Copyright © 2020 Stefan Stevanovic. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WebtrekkDataService.h"
#import "WebtrekkDefaultConfig.h"
#import "WebtrekkLogger.h"

#define key_webtrekk_default_configuration @"defaultConfiguration"

@interface WebtrekkDataService()

@property WebtrekkDefaultConfig * defaultConfiguration;

@end

@implementation WebtrekkDataService: NSObject

- (id)init
{
    self = [super init];
    [self setDefaultConfigurationAndSaveToUserDefaults];
    return self;
}

+ (instancetype)shared
{
    static WebtrekkDataService *shared = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shared = [[WebtrekkDataService alloc] init];
    });
    
    return shared;
}

-(void) setDefaultConfigurationAndSaveToUserDefaults {
   _defaultConfiguration = [[WebtrekkDefaultConfig alloc] init];
    _defaultConfiguration.autoTracking = YES;
    [[WebtrekkLogger shared] logObj:([@"Auto Tracking is enabled: " stringByAppendingFormat:_defaultConfiguration.autoTracking ? @"Yes" : @"No"]) forDescription:kWebtrekkLogLevelDescriptionDebug];
    _defaultConfiguration.batchSupport = NO;
    [[WebtrekkLogger shared] logObj:([@"Batch Support is enabled: " stringByAppendingFormat:_defaultConfiguration.batchSupport ? @"Yes" :@"No"]) forDescription:kWebtrekkLogLevelDescriptionDebug];
    _defaultConfiguration.logLevel = kWebtrekkLogLevelDescriptionDebug;
    [[WebtrekkLogger shared] logObj:([@"Log Level is:  " stringByAppendingFormat:@"%@", [NSString stringWithFormat:@"%ld", (long)_defaultConfiguration.logLevel]]) forDescription:kWebtrekkLogLevelDescriptionDebug];
    _defaultConfiguration.requestPerBatch = 5000;
    [[WebtrekkLogger shared] logObj:([@"Number of requests per batch: "  stringByAppendingFormat:@"%@", [NSString stringWithFormat:@"%ld", (long)_defaultConfiguration.requestPerBatch]]) forDescription:kWebtrekkLogLevelDescriptionDebug];
    _defaultConfiguration.requestsInterval = 900;
    [[WebtrekkLogger shared] logObj:([@"Request time interval in seconds: " stringByAppendingFormat:@"%@", [NSString stringWithFormat:@"%ld", _defaultConfiguration.requestsInterval]]) forDescription:kWebtrekkLogLevelDescriptionDebug];
    _defaultConfiguration.trackDomain = @"https://q3.webtrekk.net";
    [[WebtrekkLogger shared] logObj:([@"Tracking domain is: " stringByAppendingFormat:@"%@", _defaultConfiguration.trackDomain]) forDescription:kWebtrekkLogLevelDescriptionDebug];
    _defaultConfiguration.trackIDs = [[NSDictionary alloc] init];
    [[WebtrekkLogger shared] logObj:([@"Tracking IDs: " stringByAppendingFormat:@"%@", _defaultConfiguration.trackIDs]) forDescription:kWebtrekkLogLevelDescriptionDebug];
    _defaultConfiguration.viewControllerAutoTracking = YES;
    [[WebtrekkLogger shared] logObj:([@"View Controller auto tracking is enabbled: " stringByAppendingFormat:_defaultConfiguration.viewControllerAutoTracking ? @"Yes" : @"No"]) forDescription:kWebtrekkLogLevelDescriptionDebug];

//    NSMutableArray * configArray = [[NSMutableArray alloc] init];
//    [configArray addObject:_defaultConfiguration];
    NSData *econdedConfiguration = [NSKeyedArchiver archivedDataWithRootObject:_defaultConfiguration];
    NSUserDefaults *standardDefaults = [NSUserDefaults standardUserDefaults];
    if (standardDefaults) {
        [standardDefaults setObject:econdedConfiguration forKey:key_webtrekk_default_configuration];
        [standardDefaults synchronize];
    }
}
-(void) setConfigurationAndSaveToUserDefault: (BOOL) autoTracking batchSupport: (BOOL) batchSupport logLevel: (WebtrekkLogLevelDescription) logLevel requestPerBatch: (long) requestPerBatch requestsInterval: (long) requestsInterval trackDomain: (NSString *) trackDomain trackIDs: (NSDictionary *) trackIDs viewControllerAutoTracking: (BOOL) viewControllerAutotracking  {
   _defaultConfiguration = [[WebtrekkDefaultConfig alloc] init];
    [_defaultConfiguration setAutoTracking:autoTracking];
    [[WebtrekkLogger shared] logObj:([@"Auto Tracking is enabled: " stringByAppendingFormat:_defaultConfiguration.autoTracking ? @"Yes" : @"No"]) forDescription:kWebtrekkLogLevelDescriptionDebug];
    [_defaultConfiguration setBatchSupport:batchSupport];
    [[WebtrekkLogger shared] logObj:([@"Batch Support is enabled: " stringByAppendingFormat:_defaultConfiguration.batchSupport ? @"Yes" :@"No"]) forDescription:kWebtrekkLogLevelDescriptionDebug];
    [_defaultConfiguration setLogLevel:logLevel];
    [[WebtrekkLogger shared] logObj:([@"Log Level is:  " stringByAppendingFormat:@"%@", [NSString stringWithFormat:@"%ld", (long)_defaultConfiguration.logLevel]]) forDescription:kWebtrekkLogLevelDescriptionDebug];
    [_defaultConfiguration setRequestPerBatch:requestPerBatch];
    [[WebtrekkLogger shared] logObj:([@"Number of requests per batch: "  stringByAppendingFormat:@"%@", [NSString stringWithFormat:@"%ld", (long)_defaultConfiguration.requestPerBatch]]) forDescription:kWebtrekkLogLevelDescriptionDebug];
    [_defaultConfiguration setRequestsInterval:requestsInterval];
    [[WebtrekkLogger shared] logObj:([@"Request time interval in seconds: " stringByAppendingFormat:@"%@", [NSString stringWithFormat:@"%ld", _defaultConfiguration.requestsInterval]]) forDescription:kWebtrekkLogLevelDescriptionDebug];
    [_defaultConfiguration setTrackDomain:trackDomain];
    [[WebtrekkLogger shared] logObj:([@"Tracking domain is: " stringByAppendingFormat:@"%@", _defaultConfiguration.trackDomain]) forDescription:kWebtrekkLogLevelDescriptionDebug];
    [_defaultConfiguration setTrackIDs:trackIDs];
    [[WebtrekkLogger shared] logObj:([@"Tracking IDs: " stringByAppendingFormat:@"%@", _defaultConfiguration.trackIDs]) forDescription:kWebtrekkLogLevelDescriptionDebug];
    [_defaultConfiguration setViewControllerAutoTracking:viewControllerAutotracking];
    [[WebtrekkLogger shared] logObj:([@"View Controller auto tracking is enabbled: " stringByAppendingFormat:_defaultConfiguration.viewControllerAutoTracking ? @"Yes" : @"No"]) forDescription:kWebtrekkLogLevelDescriptionDebug];

//    NSMutableArray * configArray = [[NSMutableArray alloc] init];
//    [configArray addObject:_defaultConfiguration];
    NSData *econdedConfiguration = [NSKeyedArchiver archivedDataWithRootObject:_defaultConfiguration];
    NSUserDefaults *standardDefaults = [NSUserDefaults standardUserDefaults];
    if (standardDefaults) {
        [standardDefaults setObject:econdedConfiguration forKey:key_webtrekk_default_configuration];
        [standardDefaults synchronize];
    }
}
@end
