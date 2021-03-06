//
//  MappIntelligenceLogger.m
//  Webrekk
//
//  Created by Vladan Randjelovic on 03/01/2020.
//  Copyright © 2020 Mapp Digital US, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MappIntelligenceLogger.h"
#import "MappIntelligenceDefaultConfig.h"
@implementation MappIntelligenceLogger

#pragma mark - Initialization

- (id)init {
  self = [super init];

  if (self) {

    self.logLevel = kMappIntelligenceLogLevelDescriptionNone;
    _formatter = [[NSNumberFormatter alloc] init];
    [_formatter setFormatterBehavior:NSNumberFormatterBehavior10_4];
    [_formatter setNumberStyle:NSNumberFormatterDecimalStyle];
    [_formatter setGroupingSeparator:@""];
    [_formatter setDecimalSeparator:@"."];
  }

  return self;
}

+ (instancetype)shared {
  static MappIntelligenceLogger *sharedInstance = nil;

  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    sharedInstance = [[MappIntelligenceLogger alloc] init];
  });

  return sharedInstance;
}

#pragma mark - Logging

- (NSString *)logObj:(id)obj
      forDescription:(MappIntelligenceLogLevelDescription)logDescription {
  NSString *log = nil;

  if (self.logLevel == logDescription ||
      self.logLevel == kMappIntelligenceLogLevelDescriptionAll || logDescription == kMappIntelligenceLogLevelDescriptionFault) {

    log = [NSString stringWithFormat:@"%@ %@",
                                     [self logLevelDescription:logDescription],
                                     obj];

    NSLog(@"%@", log);
  }

  return log;
}

- (NSString *)logLevelFor:(MappIntelligenceLogLevelDescription)description {
  NSString *log = nil;
    if (self.logLevel == description ||
  self.logLevel == kMappIntelligenceLogLevelDescriptionAll) {
    log = [NSString
        stringWithFormat:@"%@", [self logLevelForDescription:description]];
  }
  return log;
}

#pragma mark - Log Level For Description

- (NSString *)logLevelForDescription:
    (MappIntelligenceLogLevelDescription)logDescription {
  NSString *logLevelForDescription = @"";

  switch (logDescription) {

  case kMappIntelligenceLogLevelDescriptionDebug:
    logLevelForDescription = @"Debug";
    break;
  case kMappIntelligenceLogLevelDescriptionWarning:
    logLevelForDescription = @"Warning";
    break;
  case kMappIntelligenceLogLevelDescriptionError:
    logLevelForDescription = @"Error";
    break;
  case kMappIntelligenceLogLevelDescriptionFault:
    logLevelForDescription = @"Fault";
    break;
  case kMappIntelligenceLogLevelDescriptionInfo:
    logLevelForDescription = @"Info";
    break;
  case kMappIntelligenceLogLevelDescriptionAll:
    logLevelForDescription = @"All";
    break;
  case kMappIntelligenceLogLevelDescriptionNone:
    logLevelForDescription = @"None";
    break;
  }

  return logLevelForDescription;
}

#pragma mark - Log Description

- (NSString *)logLevelDescription:
    (MappIntelligenceLogLevelDescription)logDescription {
  NSString *logLevelDescription = @"";

  switch (logDescription) {

  case kMappIntelligenceLogLevelDescriptionDebug:
    logLevelDescription = @"[MappIntelligence Debug]";
    break;
  case kMappIntelligenceLogLevelDescriptionWarning:
    logLevelDescription = @"[MappIntelligence Warning]";
    break;
  case kMappIntelligenceLogLevelDescriptionError:
    logLevelDescription = @"[MappIntelligence Error]";
    break;
  case kMappIntelligenceLogLevelDescriptionFault:
    logLevelDescription = @"[MappIntelligence Fault]";
    break;
  case kMappIntelligenceLogLevelDescriptionInfo:
    logLevelDescription = @"[MappIntelligence Info]";
    break;
  case kMappIntelligenceLogLevelDescriptionAll:
    logLevelDescription = @"[MappIntelligence All]";
    break;
  case kMappIntelligenceLogLevelDescriptionNone:
    logLevelDescription = @"";
    break;
  }

  return logLevelDescription;
}

//- (void)setLogLevel:(MappIntelligenceLogLevelDescription)logLevel {
//    NSLog(@"%@", [[NSString alloc] initWithFormat:@"Log level is changed to: %ld", (long)logLevel]);
//}

@end
