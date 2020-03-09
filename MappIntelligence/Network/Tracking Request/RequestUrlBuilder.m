//
//  RequestUrlBuilder.m
//  MappIntelligenceSDK
//
//  Created by Stefan Stevanovic on 3/7/20.
//  Copyright © 2020 Stefan Stevanovic. All rights reserved.
//

#import "RequestUrlBuilder.h"
#import "MappIntelligenceLogger.h"
#import "Properties.h"
#import "MappIntelligence.h"
#import "URLSizeMonitor.h"

@interface RequestUrlBuilder ()

@property NSURL *baseUrl;
@property NSURL *serverUrl;
@property NSString *mappIntelligenceId;
@property MappIntelligenceLogger *logger;

- (NSURL *)buildBaseUrlwithServer:(NSURL *)serverUrl
                        andWithId:(NSString *)mappIntelligenceId;
- (NSString *)codeString:(NSString *)str;
- (NSURL *)createURLFromParametersWith:(NSArray<NSURLQueryItem *> *)parameters;

@end

@implementation RequestUrlBuilder

- (instancetype)init {
  self = [super init];
  if (self) {
    _logger = [[MappIntelligenceLogger alloc] init];
  }
  return self;
}

- (instancetype)initWithUrl:(NSURL *)serverUrl
                  andWithId:(NSString *)mappIntelligenceId {
  self = [self init];
  _serverUrl = serverUrl;
  _mappIntelligenceId = mappIntelligenceId;
  _baseUrl =
      [self buildBaseUrlwithServer:_serverUrl andWithId:_mappIntelligenceId];
  return self;
}

- (NSURL *)buildBaseUrlwithServer:(NSURL *)serverUrl
                        andWithId:(NSString *)mappIntelligenceId {
  NSURL *tmpUrl = [serverUrl
      URLByAppendingPathComponent:[[NSString alloc]
                                      initWithFormat:@"%@",
                                                     mappIntelligenceId]];
  return [tmpUrl URLByAppendingPathComponent:@"wt"];
}

- (NSURL *)urlForRequest:(TrackerRequest *)request {
  TrackingEvent *event = [request event];
  NSString *pageNameOpt = [event pageName];
  NSURL *url;

  if (!pageNameOpt) {
    [_logger logObj:@"Tracking event must contain a page name: %@"
        forDescription:kMappIntelligenceLogLevelDescriptionError];
    return url;
  }

  Properties *properties = [request properties];
  NSString *screenSize = [[NSString alloc]
      initWithFormat:@"%fx%f", [UIScreen mainScreen].bounds.size.width,
                     [UIScreen mainScreen].bounds.size.height];
  NSString *libraryVersionOriginal = [MappIntelligence version];
  NSString *libraryVersionParced =
      [self codeString:[libraryVersionOriginal
                           stringByReplacingOccurrencesOfString:@"."
                                                     withString:@""]];
  URLSizeMonitor *sizeMonitor = [[URLSizeMonitor alloc] init];

  // begin cycle
  NSMutableArray *parametrs = [[NSMutableArray alloc] init];
  [sizeMonitor setCurrentRequestSize:1024]; // reserve for non product items
  NSString *pageName = [self codeString:pageNameOpt];

  [parametrs
      addObject:[NSURLQueryItem
                    queryItemWithName:@"p"
                                value:[[NSString alloc]
                                          initWithFormat:
                                              @"%@,%@,0,%@,32,0,%f,0,0,0",
                                              libraryVersionParced, pageName,
                                              screenSize,
                                              properties.timestamp
                                                      .timeIntervalSince1970 *
                                                  1000]]];
  [parametrs addObject:[NSURLQueryItem queryItemWithName:@"eid"
                                                   value:properties.everId]];
  [parametrs
      addObject:[NSURLQueryItem
                    queryItemWithName:@"fns"
                                value:properties.isFirstEventOfSession ? @"1"
                                                                       : @"0"]];
  [parametrs
      addObject:[NSURLQueryItem
                    queryItemWithName:@"one"
                                value:properties.isFirstEventOfApp ? @"1"
                                                                   : @"0"]];

  [parametrs
      addObject:[NSURLQueryItem
                    queryItemWithName:@"X-WT-UA"
                                value:[[NSString alloc]
                                          initWithFormat:@"%@",
                                                         properties
                                                             .userAgent]]];
  NSString *language = [[properties locale] objectForKey:NSLocaleLanguageCode];
  if (language) {
    [parametrs
        addObject:[NSURLQueryItem queryItemWithName:@"la" value:language]];
  }
  [parametrs addObject:[NSURLQueryItem queryItemWithName:@"eor" value:@"1"]];
  [sizeMonitor setCurrentRequestSize:[sizeMonitor currentRequestSize] +
                                     5]; // add for end of the request

  url = [self createURLFromParametersWith:parametrs];
  return url;
}

- (NSURL *)createURLFromParametersWith:(NSArray<NSURLQueryItem *> *)parameters {
  NSURLComponents *urlComponents = [[NSURLComponents alloc] initWithURL:_baseUrl
                                                resolvingAgainstBaseURL:YES];
  if (!urlComponents) {
    [_logger logObj:[[NSString alloc]
                        initWithFormat:@"Could not parse baseUrl: %@", _baseUrl]
        forDescription:kMappIntelligenceLogLevelDescriptionError];
    return NULL;
  }

  [urlComponents
      setPercentEncodedQuery:
          [self applyQueryItemsWithAlternativeURLEncodingWith:parameters
                                             andForComponents:urlComponents]];
  if (!urlComponents.URL) {
    [_logger logObj:[[NSString alloc]
                        initWithFormat:@"Cannot build URL from components: %@",
                                       _baseUrl]
        forDescription:kMappIntelligenceLogLevelDescriptionError];
    return NULL;
  }
  return urlComponents.URL;
}

- (NSString *)applyQueryItemsWithAlternativeURLEncodingWith:
                  (NSArray<NSURLQueryItem *> *)parameters
                                           andForComponents:
                                               (NSURLComponents *)components {
  NSMutableArray<NSString *> *componentsArray = [[NSMutableArray alloc] init];
  for (NSURLQueryItem *object in parameters) {
    NSString *value = [object value];
    if (![[object name] isEqual:@"p"]) {
      value = [self codeString:[object value]];
    }
    [componentsArray
        addObject:[[NSString alloc]
                      initWithFormat:@"%@=%@", [self codeString:[object name]],
                                     value]];
  }
  if ([components percentEncodedQuery] != nil) {
    [components
        setPercentEncodedQuery:
            [[NSString alloc]
                initWithFormat:@"%@&%@", [components percentEncodedQuery],
                               [componentsArray
                                   componentsJoinedByString:@"&"]]];
  } else {
    [components
        setPercentEncodedQuery:[componentsArray componentsJoinedByString:@"&"]];
  }

  return [components percentEncodedQuery];
}

- (NSString *)codeString:(NSString *)str {

  // NSString* codeChar = @"$',/:?@=&+";
  NSCharacterSet *csValue = [NSCharacterSet URLQueryAllowedCharacterSet];

  //    NSUInteger len = [codeChar length];
  //    unichar buffer[len+1];
  //    [str getCharacters:buffer range:NSMakeRange(0, len)];
  //
  //    for(int i = 0; i < len; i++) {
  //        [csValue stringByReplacingOccurrencesOfString:[buffer[i]
  //        unicodeScalar] withString:<#(nonnull NSString *)#>];
  //    }

  return [str stringByAddingPercentEncodingWithAllowedCharacters:csValue];
}

@end
