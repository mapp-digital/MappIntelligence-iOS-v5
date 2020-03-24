//
//  MappIntelligenceLogger.h
//  Webrekk
//
//  Created by Vladan Randjelovic on 03/01/2020.
//  Copyright © 2020 Stefan Stevanovic. All rights reserved.
//
#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, MappIntelligenceLogLevelDescription) {
  kMappIntelligenceLogLevelDescriptionAll = 1,   // All logs of the above.
  kMappIntelligenceLogLevelDescriptionDebug = 2, // The lowest priority that you
                                                 // would normally log, and
                                                 // purely informational in
                                                 // nature.
  kMappIntelligenceLogLevelDescriptionWarning =
      3, // Something is missing and might fail if not corrected
  kMappIntelligenceLogLevelDescriptionError = 4, // Something has failed.
  kMappIntelligenceLogLevelDescriptionFault = 5, // A failure in a key system.
  kMappIntelligenceLogLevelDescriptionInfo = 6,  // Informational logs for
                                                 // updating configuration or
  // migrating from older versions
  // of the library.
  kMappIntelligenceLogLevelDescriptionNone =
      7, // None of the logs will be displayed
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

@end

#ifndef MappIntelligenceLogger_h
#define MappIntelligenceLogger_h

#endif /* MappIntelligenceLogger_h */
