//
//  DefaultTracker.m
//  MappIntelligenceSDK
//
//  Created by Vladan Randjelovic on 11/02/2020.
//  Copyright © 2020 Stefan Stevanovic. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DefaultTracker.h"

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

+ (NSString *)generateEverId {
    
    NSString* tmpEverId = [[DefaultTracker sharedDefaults] stringForKey:everId];
    if ( !tmpEverId) {
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

+(NSUserDefaults *)sharedDefaults {
    return [NSUserDefaults standardUserDefaults];
}

@end
