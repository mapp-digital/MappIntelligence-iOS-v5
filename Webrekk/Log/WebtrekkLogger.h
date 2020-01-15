//
//  WebtrekkLogger.h
//  Webrekk
//
//  Created by Vladan Randjelovic on 03/01/2020.
//  Copyright © 2020 Stefan Stevanovic. All rights reserved.
//
#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, WebtrekkLogLevelDescription) {
    kWebtrekkLogLevelDescriptionDebug = 1, // The lowest priority that you would normally log, and purely informational in nature.
    kWebtrekkLogLevelDescriptionWarning = 2, // Something is amiss and might fail if not corrected
    kWebtrekkLogLevelDescriptionError = 3, // Something has failed.
    kWebtrekkLogLevelDescriptionCritical = 4, // A failure in a key system.
    kWebtrekkLogLevelDescriptionEmergency = 5, // The highest priority, usually reserved for catastrophic failures and reboot notices.
};
typedef NS_ENUM(NSInteger, WebtrekkErrorType) {
    kWebtrekkErrorTypeCaching = 1,
    kWebtrekkErrorTypeUnCaching = 2,
    kWebtrekkErrorTypeCachingObjectDoesNotExist = 3,
    kWebtrekkErrorTypeMissingArguments = 11,
    kWebtrekkErrorTypeBadArguments = 12,
    kWebtrekkErrorTypeNetwork = 20,
    kWebtrekkErrorTypeTagExists = 30,
    kWebtrekkErrorTypeTagDoesNotExists = 31,
    kWebtrekkErrorTypeTagUncompletedArguments = 32,
    kWebtrekkErrorTypeOptionNotAvailable = 40,
    kWebtrekkErrorTypeGeneralError = 50,
    kWebtrekkErrorTypeSilentPush = 60,
    kWebtrekkErrorTypeDMC = 70,
    kWebtrekkErrorTypeDMCUserDoesntExist = 71,
};

//#define INTERNAL_DEBUG // comment out to remove internal logs
#ifdef INTERNAL_DEBUG
#define AppLog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__); // for Logging inside the SDK
#else
#define AppLog(...)
#endif

@interface WebtrekkLogger : NSObject

@property (nonatomic) WebtrekkLogLevelDescription logLevel; // defualt level is kWebtrekkLogLevelDescriptionDebug

+ (instancetype)shared;

- (NSString *)logObj:(id)obj forDescription:(WebtrekkLogLevelDescription)logDescription;

+ (NSError *)errorWithType:(WebtrekkErrorType)errorType;

@end

#ifndef WebtrekkLogger_h
#define WebtrekkLogger_h


#endif /* WebtrekkLogger_h */
