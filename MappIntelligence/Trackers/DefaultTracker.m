//
//  DefaultTracker.m
//  MappIntelligenceSDK
//
//  Created by Vladan Randjelovic on 11/02/2020.
//  Copyright © 2020 Stefan Stevanovic. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DefaultTracker.h"
#import "MappIntelligenceLogger.h"
#import "MappIntelligence.h"
#import "Properties.h"
#import "Enviroment.h"
#import "Configuration.h"
#import "RequestTrackerBuilder.h"
#import "TrackerRequest.h"

#define appHibernationDate @"appHibernationDate"
#define appVersion @"appVersion"
#define configuration @"configuration"
#define everId @"everId"
#define isFirstEventAfterAppUpdate @"isFirstEventAfterAppUpdate"
#define isFirstEventOfApp @"isFirstEventOfApp"
#define isSampling @"isSampling"
#define isOptedOut @"isOptedOut"
#define migrationCompleted @"migrationCompleted"
#define samplingRate @"samplingRate"
#define adClearId @"adClearId"
#define crossDeviceProperties @"crossDeviceProperties"
#define isSettingsToAppSpecificConverted @"isSettingsToAppSpecificConverted"
#define productListOrder @"productListOrder"

@interface DefaultTracker()

@property Configuration* config;
@property TrackingEvent* event;

-(void)enqueueRequestForEvent;
-(Properties*) generateRequestProperties;

@end

@implementation DefaultTracker:NSObject

static DefaultTracker * sharedTracker = nil;
static NSString * everID;
static NSString* userAgent;

+(nullable instancetype) sharedInstance {
    
    static DefaultTracker *shared = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shared = [[DefaultTracker alloc] init];
    });
    return shared;
}

-(instancetype)init {
    if (!sharedTracker) {
        sharedTracker = [super init];
        everID = [sharedTracker generateEverId];
        [self generateUserAgent];
        [self initializeTracking];
    }
    return sharedTracker;
}

-(void) generateUserAgent {
    Enviroment* env = [[Enviroment alloc] init];
    NSString* properties = [env.operatingSystemName stringByAppendingFormat:@" %@; %@; %@", env.operatingSystemVersionString, env.deviceModelString, NSLocale.currentLocale.localeIdentifier];

    userAgent = [[NSString alloc] initWithFormat:@"Tracking Library %@ (%@))", MappIntelligence.version,  properties];
}

-(void)initializeTracking {
    self.config.serverUrl = [[NSURL alloc] initWithString:[MappIntelligence getUrl]];
    self.config.MappIntelligenceId = [MappIntelligence getId];
}

-(NSString *)generateEverId {
    
    NSString* tmpEverId = [[DefaultTracker sharedDefaults] stringForKey:everId];
    //https://nshipster.com/nil/ read for more explanation
    if ( tmpEverId != nil) {
        return tmpEverId;
    } else {
        tmpEverId = [[NSString alloc] initWithFormat:@"6%010.0f%08u", [[[NSDate alloc] init] timeIntervalSince1970], arc4random_uniform(99999999) + 1];
        [[DefaultTracker sharedDefaults] setValue:tmpEverId forKey:everId];
        
        if ( [everId isEqual:[[NSNull alloc] init]]) {
            @throw @"Can't generate ever id";
        }
        return tmpEverId;
    }
    
    return @"";
}

- (void)track:(UIViewController *)controller {
    NSString *CurrentSelectedCViewController = NSStringFromClass([controller class]);
    [[MappIntelligenceLogger shared] logObj:[[NSString alloc]initWithFormat:@"Content ID is: %@", CurrentSelectedCViewController] forDescription:kMappIntelligenceLogLevelDescriptionDebug];
    
    //create request
    
}

- (void)enqueueRequestForEvent {
    Properties* requestProperties = [self generateRequestProperties];
    requestProperties.locale = [NSLocale currentLocale];
    
    #ifdef TARGET_OS_WATCHOS
        
    #else
        //requestProperties.screenSize =
    #endif
    [requestProperties setIsFirstEventOfApp:NO];
    [requestProperties setIsFirstEventOfSession:NO];
    [requestProperties setIsFirstEventAfterAppUpdate:NO];
    
    RequestTrackerBuilder* builder = [[RequestTrackerBuilder alloc] initWithConfoguration:self.config];
    
    TrackerRequest* request = [builder createRequestWith:_event andWith:requestProperties];
}

- (Properties *)generateRequestProperties {
    return [[Properties alloc] initWithEverID:everID andSamplingRate:0 withTimeZone: [NSTimeZone localTimeZone] withTimestamp: [NSDate date] withUserAgent:userAgent];
}

+(NSUserDefaults *)sharedDefaults {
    return [NSUserDefaults standardUserDefaults];
}

@end

