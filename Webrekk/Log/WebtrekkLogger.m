//
//  WebtrekkLogger.m
//  Webrekk
//
//  Created by Vladan Randjelovic on 03/01/2020.
//  Copyright © 2020 Stefan Stevanovic. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WebtrekkLogger.h"
@implementation WebtrekkLogger

#pragma mark - Initialization

- (id)init
{
    self = [super init];
    
    if (self) {
        
        self.logLevel = kWebtrekkLogLevelDescriptionDebug;
    }
    
    return self;
}

+ (instancetype)shared
{
    static WebtrekkLogger *sharedInstance = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[WebtrekkLogger alloc] init];
    });
    
    return sharedInstance;
}

#pragma mark - Logging

- (NSString *)logObj:(id)obj forDescription:(WebtrekkLogLevelDescription)logDescription
{
    NSString *log = nil;
    
    if (self.logLevel <= logDescription) {
        
        log = [NSString stringWithFormat:@"%@ %@", [self logLevelDescription:logDescription], obj];
        
        NSLog(@"%@", log);
    }
    
    return log;
}

#pragma mark - Log Description

- (NSString *)logLevelDescription:(WebtrekkLogLevelDescription)logDescription
{
    NSString *logLevelDescription = @"";
    
    switch (logDescription) {
            
        case kWebtrekkLogLevelDescriptionDebug:
            logLevelDescription = @"[Webtrekk Debug]";
            break;
        case kWebtrekkLogLevelDescriptionWarning:
            logLevelDescription = @"[Webtrekk Warning]";
            break;
        case kWebtrekkLogLevelDescriptionError:
            logLevelDescription = @"[Webtrekk Error]";
            break;
        case kWebtrekkLogLevelDescriptionCritical:
            logLevelDescription = @"[Webtrekk Critical]";
            break;
        case kWebtrekkLogLevelDescriptionEmergency:
            logLevelDescription = @"[Webtrekk Emergency]";
            break;
    }
    
    return logLevelDescription;
}

#pragma mark - Errors

+ (NSError *)errorWithType:(WebtrekkErrorType)errorType
{
    NSString *domain = nil;
    NSInteger code = 0;
    NSMutableDictionary *userInfo = [[NSMutableDictionary alloc] init];
    
    switch (errorType) {
        case kWebtrekkErrorTypeCaching:
        {
            domain = @"Webtrekk_PersistanceLayerDomain";
            code = errorType;
            userInfo[@"info"] = @"Failed caching object.";
        }
            break;
        case kWebtrekkErrorTypeUnCaching:
        {
            domain = @"Webtrekk_PersistanceLayerDomain";
            code = errorType;
            userInfo[@"info"] = @"Failed loading object from cache.";
        }
            break;
        case kWebtrekkErrorTypeCachingObjectDoesNotExist:
        {
            domain = @"Webtrekk_PersistanceLayerDomain";
            code = errorType;
            userInfo[@"info"] = @"Object does not exist.";
        }
            break;
        case kWebtrekkErrorTypeMissingArguments:
        {
            domain = @"Webtrekk_GeneralError";
            code = errorType;
            userInfo[@"info"] = @"Missing arguments, can't continue.";
        }
            break;
        case kWebtrekkErrorTypeNetwork:
        {
            domain = @"Webtrekk_NetworkError";
            code = errorType;
            userInfo[@"info"] = @"Missing arguments or bad Argumens.";
        }
            break;
        case kWebtrekkErrorTypeBadArguments:
        {
            domain = @"Webtrekk_GeneralError";
            code = errorType;
            userInfo[@"info"] = @"Wrong or unformatted arguments, can't continue.";
        }
            break;
        case kWebtrekkErrorTypeTagExists:
        {
            domain = @"Webtrekk_DataService";
            code = errorType;
            userInfo[@"info"] = @"Tag name already exist in device tags with desired boolean state.";
        }
            break;
        case kWebtrekkErrorTypeTagDoesNotExists:
        {
            domain = @"Webtrekk_DataService";
            code = errorType;
            userInfo[@"info"] = @"Tag name doesn't exist in device tags, or in application tags.";
        }
            break;
        case kWebtrekkErrorTypeTagUncompletedArguments:
        {
            domain = @"Webtrekk_DataService";
            code = errorType;
            userInfo[@"info"] = @"Missing arguments, or empry arguments.";
        }
            break;
        case kWebtrekkErrorTypeOptionNotAvailable:
        {
            domain = @"Webtrekk_GeneralError";
            code = errorType;
            userInfo[@"info"] = @"Option is not available, please contact support.";
        }
            break;
        case kWebtrekkErrorTypeGeneralError:
        {
            domain = @"Webtrekk_GeneralError";
            code = errorType;
            userInfo[@"info"] = @"General Error";
        }
            break;
        case kWebtrekkErrorTypeSilentPush:
        {
            domain = @"Webtrekk_PushSender";
            code = errorType;
            userInfo[@"info"] = @"Push did not originate from Webtrekk. Aborting actions.";
        }
            break;
        case kWebtrekkErrorTypeDMC:
        {
            domain = @"Webtrekk_DMCError";
            code = errorType;
            userInfo[@"info"] = @"Error while polling user.";
        }
            break;
        case kWebtrekkErrorTypeDMCUserDoesntExist:
        {
            domain = @"Webtrekk_DMCError";
            code = errorType;
            userInfo[@"info"] = @"User doesnt exists.";
        }
            break;
    }
    
    return [[NSError alloc] initWithDomain:domain code:code userInfo:userInfo];
}

@end
