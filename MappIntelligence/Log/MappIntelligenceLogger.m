//
//  MappIntelligenceLogger.m
//  Webrekk
//
//  Created by Vladan Randjelovic on 03/01/2020.
//  Copyright © 2020 Stefan Stevanovic. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MappIntelligenceLogger.h"
@implementation MappIntelligenceLogger

#pragma mark - Initialization

- (id)init {
  self = [super init];

  if (self) {

    self.logLevel = kMappIntelligenceLogLevelDescriptionDebug;
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

  if (self.logLevel <= logDescription) {

    log = [NSString stringWithFormat:@"%@ %@",
                                     [self logLevelDescription:logDescription],
                                     obj];

    NSLog(@"%@", log);
  }

  return log;
}

- (NSString *)logLevelFor:(MappIntelligenceLogLevelDescription)description {
  NSString *log = nil;
  if (self.logLevel <= description) {
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
  }

  return logLevelDescription;
}

#pragma mark - Errors

+ (NSError *)errorWithType:(MappIntelligenceErrorType)errorType {
  NSString *domain = nil;
  NSInteger code = 0;
  NSMutableDictionary *userInfo = [[NSMutableDictionary alloc] init];

  switch (errorType) {
  case kMappIntelligenceErrorTypeCaching: {
    domain = @"MappIntelligence_PersistanceLayerDomain";
    code = errorType;
    userInfo[@"info"] = @"Failed caching object.";
  } break;
  case kMappIntelligenceErrorTypeUnCaching: {
    domain = @"MappIntelligence_PersistanceLayerDomain";
    code = errorType;
    userInfo[@"info"] = @"Failed loading object from cache.";
  } break;
  case kMappIntelligenceErrorTypeCachingObjectDoesNotExist: {
    domain = @"MappIntelligence_PersistanceLayerDomain";
    code = errorType;
    userInfo[@"info"] = @"Object does not exist.";
  } break;
  case kMappIntelligenceErrorTypeMissingArguments: {
    domain = @"MappIntelligence_GeneralError";
    code = errorType;
    userInfo[@"info"] = @"Missing arguments, can't continue.";
  } break;
  case kMappIntelligenceErrorTypeNetwork: {
    domain = @"MappIntelligence_NetworkError";
    code = errorType;
    userInfo[@"info"] = @"Missing arguments or bad Argumens.";
  } break;
  case kMappIntelligenceErrorTypeBadArguments: {
    domain = @"MappIntelligence_GeneralError";
    code = errorType;
    userInfo[@"info"] = @"Wrong or unformatted arguments, can't continue.";
  } break;
  case kMappIntelligenceErrorTypeTagExists: {
    domain = @"MappIntelligence_DataService";
    code = errorType;
    userInfo[@"info"] =
        @"Tag name already exist in device tags with desired boolean state.";
  } break;
  case kMappIntelligenceErrorTypeTagDoesNotExists: {
    domain = @"MappIntelligence_DataService";
    code = errorType;
    userInfo[@"info"] =
        @"Tag name doesn't exist in device tags, or in application tags.";
  } break;
  case kMappIntelligenceErrorTypeTagUncompletedArguments: {
    domain = @"MappIntelligence_DataService";
    code = errorType;
    userInfo[@"info"] = @"Missing arguments, or empry arguments.";
  } break;
  case kMappIntelligenceErrorTypeOptionNotAvailable: {
    domain = @"MappIntelligence_GeneralError";
    code = errorType;
    userInfo[@"info"] = @"Option is not available, please contact support.";
  } break;
  case kMappIntelligenceErrorTypeGeneralError: {
    domain = @"MappIntelligence_GeneralError";
    code = errorType;
    userInfo[@"info"] = @"General Error";
  } break;
  case kMappIntelligenceErrorTypeSilentPush: {
    domain = @"MappIntelligence_PushSender";
    code = errorType;
    userInfo[@"info"] =
        @"Push did not originate from MappIntelligence. Aborting actions.";
  } break;
  case kMappIntelligenceErrorTypeDMC: {
    domain = @"MappIntelligence_DMCError";
    code = errorType;
    userInfo[@"info"] = @"Error while polling user.";
  } break;
  case kMappIntelligenceErrorTypeDMCUserDoesntExist: {
    domain = @"MappIntelligence_DMCError";
    code = errorType;
    userInfo[@"info"] = @"User doesnt exists.";
  } break;
  }

  return [[NSError alloc] initWithDomain:domain code:code userInfo:userInfo];
}

@end
