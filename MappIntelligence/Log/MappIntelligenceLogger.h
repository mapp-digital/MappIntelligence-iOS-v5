//
//  MappIntelligenceLogger.h
//  Webrekk
//
//  Created by Vladan Randjelovic on 03/01/2020.
//  Copyright © 2020 Stefan Stevanovic. All rights reserved.
//
#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, MappIntelligenceLogLevelDescription) {
  kMappIntelligenceLogLevelDescriptionDebug = 1, // The lowest priority that you
                                                 // would normally log, and
                                                 // purely informational in
                                                 // nature.
  kMappIntelligenceLogLevelDescriptionWarning =
      2, // Something is missing and might fail if not corrected
  kMappIntelligenceLogLevelDescriptionError = 3, // Something has failed.
  kMappIntelligenceLogLevelDescriptionFault = 4, // A failure in a key system.
  kMappIntelligenceLogLevelDescriptionInfo = 5,  // Informational logs for
                                                 // updating configuration or
                                                // migrating from older versions
                                                // of the library.
  kMappIntelligenceLogLevelDescriptionAll = 6, // All logs of the above.
};
typedef NS_ENUM(NSInteger, MappIntelligenceErrorType) {
  kMappIntelligenceErrorTypeCaching = 1,
  kMappIntelligenceErrorTypeUnCaching = 2,
  kMappIntelligenceErrorTypeCachingObjectDoesNotExist = 3,
  kMappIntelligenceErrorTypeMissingArguments = 11,
  kMappIntelligenceErrorTypeBadArguments = 12,
  kMappIntelligenceErrorTypeNetwork = 20,
  kMappIntelligenceErrorTypeTagExists = 30,
  kMappIntelligenceErrorTypeTagDoesNotExists = 31,
  kMappIntelligenceErrorTypeTagUncompletedArguments = 32,
  kMappIntelligenceErrorTypeOptionNotAvailable = 40,
  kMappIntelligenceErrorTypeGeneralError = 50,
  kMappIntelligenceErrorTypeSilentPush = 60,
  kMappIntelligenceErrorTypeDMC = 70,
  kMappIntelligenceErrorTypeDMCUserDoesntExist = 71,
};

//#define INTERNAL_DEBUG // comment out to remove internal logs
#ifdef INTERNAL_DEBUG
#define AppLog(fmt, ...)                                                       \
  NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__,                 \
        ##__VA_ARGS__); // for Logging inside the SDK
#else
#define AppLog(...)
#endif

@interface MappIntelligenceLogger : NSObject

@property(nonatomic) MappIntelligenceLogLevelDescription
    logLevel; // defualt level is kMappIntelligenceLogLevelDescriptionDebug

+ (instancetype)shared;

- (NSString *)logObj:(id)obj
      forDescription:(MappIntelligenceLogLevelDescription)logDescription;

- (NSString *)logLevelFor:(MappIntelligenceLogLevelDescription)description;

+ (NSError *)errorWithType:(MappIntelligenceErrorType)errorType;

@end

#ifndef MappIntelligenceLogger_h
#define MappIntelligenceLogger_h

#endif /* MappIntelligenceLogger_h */
