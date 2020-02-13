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

@end

@implementation DefaultTracker:NSObject

static DefaultTracker * sharedTracker = nil;
static NSString * everID;

+(instancetype) sharedInstance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedTracker = [[self alloc] init];
    });
    return sharedTracker;
}

-(instancetype)init {
    if (!sharedTracker) {
        sharedTracker = [super init];
        everID = [sharedTracker generateEverId];
    }
    return sharedTracker;
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
}

+(NSUserDefaults *)sharedDefaults {
    return [NSUserDefaults standardUserDefaults];
}

@end
