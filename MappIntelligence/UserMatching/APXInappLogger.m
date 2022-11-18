//
//  APXInappLogger.m
//  AppoxeeInapp
//
//  Created by Raz Elkayam on 6/27/16.
//  Copyright © 2016 Teradata. All rights reserved.
//
#if !TARGET_OS_WATCH && !TARGET_OS_TV
#import "APXInappLogger.h"

@implementation APXInappLogger


#pragma mark - Initialization

- (id)init
{
    self = [super init];
    
    if (self) {
        
        self.logLevel = kAPXLogLevelDescriptionDebug;
    }
    
    return self;
}

+ (instancetype)shared
{
    static APXInappLogger *sharedInstance = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[APXInappLogger alloc] init];
    });
    
    return sharedInstance;
}


+ (void)logObj:(id)obj
{
    NSLog(@"%@", [NSString stringWithFormat:@"[AppoxeeInapp Debug] %@", obj]);
}

#pragma mark - Logging

- (NSString *)logObj:(id)obj forDescription:(APXLogLevelDescription)logDescription
{
    NSString *log = nil;
    
    if (self.logLevel <= logDescription) {
        
        log = [NSString stringWithFormat:@"%@ %@", [self logLevelDescription:logDescription], obj];
        
        NSLog(@"%@", log);
    }
    
    return log;
}

#pragma mark - Log Description

- (NSString *)logLevelDescription:(APXLogLevelDescription)logDescription
{
    NSString *logLevelDescription = @"";
    
    switch (logDescription) {
            
        case kAPXLogLevelDescriptionDebug:
            logLevelDescription = @"[Appoxee Debug]";
            break;
        case kAPXLogLevelDescriptionWarning:
            logLevelDescription = @"[Appoxee Warning]";
            break;
        case kAPXLogLevelDescriptionError:
            logLevelDescription = @"[Appoxee Error]";
            break;
        case kAPXLogLevelDescriptionCritical:
            logLevelDescription = @"[Appoxee Critical]";
            break;
        case kAPXLogLevelDescriptionEmergency:
            logLevelDescription = @"[Appoxee Emergency]";
            break;
    }
    
    return logLevelDescription;
}

#pragma mark - Errors

+ (NSError *)errorWithType:(APXErrorType)errorType
{
    NSString *domain = nil;
    NSInteger code = 0;
    NSMutableDictionary *userInfo = [[NSMutableDictionary alloc] init];
    
    switch (errorType) {
        case kAPXErrorTypeCaching:
        {
            domain = @"APX_PersistanceLayerDomain";
            code = errorType;
            userInfo[@"info"] = @"Failed caching object.";
        }
            break;
        case kAPXErrorTypeUnCaching:
        {
            domain = @"APX_PersistanceLayerDomain";
            code = errorType;
            userInfo[@"info"] = @"Failed loading object from cache.";
        }
            break;
        case kAPXErrorTypeCachingObjectDoesNotExist:
        {
            domain = @"APX_PersistanceLayerDomain";
            code = errorType;
            userInfo[@"info"] = @"Object does not exist.";
        }
            break;
        case kAPXErrorTypeMissingArguments:
        {
            domain = @"APX_GeneralError";
            code = errorType;
            userInfo[@"info"] = @"Missing arguments, can't continue.";
        }
            break;
        case kAPXErrorTypeNetwork:
        {
            domain = @"APX_NetworkError";
            code = errorType;
            userInfo[@"info"] = @"Missing arguments or bad Argumens.";
        }
            break;
        case kAPXErrorTypeBadArguments:
        {
            domain = @"APX_GeneralError";
            code = errorType;
            userInfo[@"info"] = @"Wrong or unformatted arguments, can't continue.";
        }
            break;
        case kAPXErrorTypeTagExists:
        {
            domain = @"APX_DataService";
            code = errorType;
            userInfo[@"info"] = @"Tag name already exist in device tags with desired boolean state.";
        }
            break;
        case kAPXErrorTypeTagDoesNotExists:
        {
            domain = @"APX_DataService";
            code = errorType;
            userInfo[@"info"] = @"Tag name doesn't exist in device tags, or in application tags.";
        }
            break;
        case kAPXErrorTypeTagUncompletedArguments:
        {
            domain = @"APX_DataService";
            code = errorType;
            userInfo[@"info"] = @"Missing arguments, or empry arguments.";
        }
            break;
        case kAPXErrorTypeOptionNotAvailable:
        {
            domain = @"APX_GeneralError";
            code = errorType;
            userInfo[@"info"] = @"Option is not available, please contact support.";
        }
            break;
        case kAPXErrorTypeGeneralError:
        {
            domain = @"APX_GeneralError";
            code = errorType;
            userInfo[@"info"] = @"General Error";
        }
            break;
        case kAPXErrorTypeSilentPush:
        {
            domain = @"APX_PushSender";
            code = errorType;
            userInfo[@"info"] = @"Push did not originate from Appoxee. Aborting actions.";
        }
            break;
        case kAPXErrorTypeDMC:
        {
            domain = @"APX_DMCError";
            code = errorType;
            userInfo[@"info"] = @"Error while polling user.";
        }
            break;
        case kAPXErrorTypeDMCUserDoesntExist:
        {
            domain = @"APX_DMCError";
            code = errorType;
            userInfo[@"info"] = @"User doesnt exists.";
        }
            break;
    }
    
    return [[NSError alloc] initWithDomain:domain code:code userInfo:userInfo];
}

@end
#endif
