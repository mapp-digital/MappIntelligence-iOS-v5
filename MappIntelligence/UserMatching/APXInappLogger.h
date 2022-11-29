//
//  APXInappLogger.h
//  AppoxeeInapp
//
//  Created by Raz Elkayam on 6/27/16.
//  Copyright © 2016 Teradata. All rights reserved.
//
#if !TARGET_OS_WATCH && !TARGET_OS_TV

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, APXLogLevelDescription) {
    kAPXLogLevelDescriptionDebug = 1, // The lowest priority that you would normally log, and purely informational in nature.
    kAPXLogLevelDescriptionWarning = 2, // Something is amiss and might fail if not corrected
    kAPXLogLevelDescriptionError = 3, // Something has failed.
    kAPXLogLevelDescriptionCritical = 4, // A failure in a key system.
    kAPXLogLevelDescriptionEmergency = 5, // The highest priority, usually reserved for catastrophic failures and reboot notices.
};

typedef NS_ENUM(NSInteger, APXErrorType) {
    kAPXErrorTypeCaching = 1,
    kAPXErrorTypeUnCaching = 2,
    kAPXErrorTypeCachingObjectDoesNotExist = 3,
    kAPXErrorTypeMissingArguments = 11,
    kAPXErrorTypeBadArguments = 12,
    kAPXErrorTypeNetwork = 20,
    kAPXErrorTypeTagExists = 30,
    kAPXErrorTypeTagDoesNotExists = 31,
    kAPXErrorTypeTagUncompletedArguments = 32,
    kAPXErrorTypeOptionNotAvailable = 40,
    kAPXErrorTypeGeneralError = 50,
    kAPXErrorTypeSilentPush = 60,
    kAPXErrorTypeDMC = 70,
    kAPXErrorTypeDMCUserDoesntExist = 71,
};

//#define INAPP_INTERNAL_DEBUG // comment out to remove internal logs
#ifdef INAPP_INTERNAL_DEBUG
#define AppLog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__); // for Logging inside the SDK
#else
#define AppLog(...)
#endif

@interface APXInappLogger : NSObject

@property (nonatomic) APXLogLevelDescription logLevel; // defualt level is kAPXLogLevelDescriptionDebug

+ (instancetype)shared;
- (NSString *)logObj:(id)obj forDescription:(APXLogLevelDescription)logDescription;
+ (NSError *)errorWithType:(APXErrorType)errorType;
+ (void)logObj:(id)obj;

@end
#endif
