//
//  MIRequestUrlBuilder.m
//  MappIntelligenceSDK
//
//  Created by Stefan Stevanovic on 3/7/20.
//  Copyright © 2020 Mapp Digital US, LLC. All rights reserved.
//

#import "MIRequestUrlBuilder.h"
#import "MappIntelligenceLogger.h"
#import "MIProperties.h"
#import "MappIntelligence.h"
#import "MIURLSizeMonitor.h"
#import "MIDatabaseManager.h"
#import "MIPageViewEvent.h"
#import "MIActionEvent.h"
#import "MITrackingEvent.h"
#import "MIDeepLink.h"
#import "MIEnvironment.h"

#if TARGET_OS_WATCH
#import <WatchKit/WatchKit.h>
#endif

@interface MIRequestUrlBuilder ()

@property NSURL *baseUrl;
@property NSURL *serverUrl;
@property NSString *mappIntelligenceId;
@property MIURLSizeMonitor *sizeMonitor;
@property MappIntelligenceLogger *logger;
@property NSMutableArray *campaignsToIgnore;

- (NSURL *)buildBaseUrlwithServer:(NSURL *)serverUrl
                        andWithId:(NSString *)mappIntelligenceId;
- (NSString *)codeString:(NSString *)str;
- (NSURL *)createURLFromParametersWith:(NSArray<NSURLQueryItem *> *)parameters;

@end

@implementation MIRequestUrlBuilder

- (instancetype)init {
  self = [super init];
  if (self) {
    _logger = [MappIntelligenceLogger shared];
    _sizeMonitor = [[MIURLSizeMonitor alloc] init];
      _campaignsToIgnore = [[NSMutableArray alloc] init];
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

- (NSURL *)urlForRequest:(MITrackerRequest *)request withCustomData: (BOOL) custom{
    MITrackingEvent *event = [request event];
  NSString *pageNameOpt = [event pageName];
  NSURL *url;

  if (!pageNameOpt) {
    [_logger logObj:@"Tracking event must contain a page name: %@"
        forDescription:kMappIntelligenceLogLevelDescriptionError];
    return url;
  }

  MIProperties *properties = [request properties];
#if !TARGET_OS_WATCH
  CGFloat scale = [[UIScreen mainScreen] scale];
  NSString *screenSize = [[NSString alloc]
      initWithFormat:@"%.fx%.f",
                     [UIScreen mainScreen].bounds.size.width * scale,
                     [UIScreen mainScreen].bounds.size.height * scale];
#else
  CGFloat scale = [[WKInterfaceDevice currentDevice] screenScale];
  NSString *screenSize = [[NSString alloc]
      initWithFormat:@"%.fx%.f",
                     [[WKInterfaceDevice currentDevice] screenBounds]
                             .size.width *
                         scale,
                     [[WKInterfaceDevice currentDevice] screenBounds]
                             .size.height *
                         scale];
#endif
  NSString *libraryVersionOriginal = [MappIntelligence version];
  NSString *libraryVersionParced =
      [self codeString:[libraryVersionOriginal
                           stringByReplacingOccurrencesOfString:@"."
                                                     withString:@""]];
  _sizeMonitor = [[MIURLSizeMonitor alloc] init];

  // begin cycle
  NSMutableArray *parametrs = [[NSMutableArray alloc] init];
  [_sizeMonitor setCurrentRequestSize:1024]; // reserve for non product items
  NSString *pageName = [self codeString:pageNameOpt];

  [parametrs
      addObject:
          [NSURLQueryItem
              queryItemWithName:@"p"
                          value:[_sizeMonitor
                                    cutPParameterLegth:libraryVersionParced
                                              pageName:pageName
                                         andScreenSize:screenSize
                                          andTimeStamp:
                                              (properties.timestamp
                                                   .timeIntervalSince1970 *
                                               1000)]]];
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
  [parametrs
      addObject:[NSURLQueryItem
                    queryItemWithName:@"X-WT-IP"
                                value:[[NSString alloc]
                                          initWithFormat:@"%@",
                                                         event
                                                             .ipAddress]]];
  NSString *language = [[properties locale] objectForKey:NSLocaleLanguageCode];
  if (language) {
    [parametrs
        addObject:[NSURLQueryItem queryItemWithName:@"la" value:language]];
  }
    
    if (custom) {
        if ([event isKindOfClass:MIActionEvent.class]) {
            [parametrs addObjectsFromArray:[(MIActionEvent*)event asQueryItems]];
        }
        
        for(NSString *key in event.trackingParams) {
            [parametrs addObject:[NSURLQueryItem queryItemWithName:key value:event.trackingParams[key]]];
        }
    } else {
        if ([event isKindOfClass:MIPageViewEvent.class]) {
            MIPageProperties* prop = ((MIPageViewEvent*)event).pageProperties;
            [parametrs addObjectsFromArray:[prop asQueryItems]];
            MIPageViewEvent* pgEvent = ((MIPageViewEvent*)event);
            MISessionProperties *session = pgEvent.sessionProperties;
            [parametrs addObjectsFromArray:[session asQueryItems]];
            MIUserProperties *userProperties = pgEvent.userProperties;
            [parametrs addObjectsFromArray:[userProperties asQueryItems]];
            MIEcommerceProperties *ecommerceProperties = pgEvent.ecommerceProperties;
            [parametrs addObjectsFromArray:[ecommerceProperties asQueryItems]];
            
            MICampaignProperties *advertisementProperties = ((MIPageViewEvent*)event).campaignProperties;
            if (advertisementProperties && [self sendCampaignData:advertisementProperties]) {
                [parametrs addObjectsFromArray:[advertisementProperties asQueryItems]];
            } else {
                MICampaignProperties *saved = [MIDeepLink loadCampaign];
                if (saved) {
                    [parametrs addObjectsFromArray:[saved asQueryItems]];
                    [MIDeepLink deleteCampaign];
                }
            }
        } else if ([event isKindOfClass:MIActionEvent.class]) {
            [parametrs addObjectsFromArray:[(MIActionEvent*)event asQueryItems]];
            MISessionProperties *session = ((MIActionEvent*)event).sessionProperties;
            [parametrs addObjectsFromArray:[session asQueryItems]];
            MIUserProperties *userProperties = ((MIActionEvent*)event).userProperties;
            [parametrs addObjectsFromArray:[userProperties asQueryItems]];
            MIEcommerceProperties *ecommerceProperties = ((MIActionEvent*)event).ecommerceProperties;
            [parametrs addObjectsFromArray:[ecommerceProperties asQueryItems]];
            MICampaignProperties *advertisementProperties = ((MIActionEvent*)event).campaignProperties;
            if ([self sendCampaignData:advertisementProperties]) {
                [parametrs addObjectsFromArray:[advertisementProperties asQueryItems]];
            }
        } else if ([event isKindOfClass:MIMediaEvent.class]) {
            MISessionProperties *session = ((MIMediaEvent*)event).sessionProperties;
            [parametrs addObjectsFromArray:[session asQueryItems]];
            MIActionProperties *actionProperties = ((MIMediaEvent*)event).actionProperties;
            [parametrs addObjectsFromArray:[actionProperties asQueryItems]];
            MIEcommerceProperties *ecommerceProperties = ((MIMediaEvent*)event).ecommerceProperties;
            [parametrs addObjectsFromArray:[ecommerceProperties asQueryItems]];
        }
    }
    
    if (properties.isFirstEventOfSession) {
        if (MIEnvironment.appVersion) {
            [parametrs addObject:[NSURLQueryItem queryItemWithName:@"cs804" value: MIEnvironment.appVersion]];
        }
        [parametrs addObject:[NSURLQueryItem queryItemWithName:@"cs805" value: MIEnvironment.buildVersion]];
        [parametrs addObject:[NSURLQueryItem queryItemWithName:@"cs821" value: properties.isFirstEventOfApp ? @"1": @"0"]];
    }
    [parametrs addObject:[NSURLQueryItem queryItemWithName:@"eor" value:@"1"]];
    [_sizeMonitor setCurrentRequestSize:[_sizeMonitor currentRequestSize] +
                                       5]; // add for end of the request
    
  url = [self createURLFromParametersWith:parametrs];
  _dbRequest = [[MIRequest alloc] initWithParamters:parametrs
                                        andDomain:[MappIntelligence getUrl]
                                      andTrackIds:_mappIntelligenceId];
  return url;
}

- (NSURL *)createURLFromParametersWith:(NSArray<NSURLQueryItem *> *)parameters {
    if (!_baseUrl) {
        [_logger logObj:@"BaseUrl not set"
            forDescription:kMappIntelligenceLogLevelDescriptionError];
        return NULL;
    }
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

-(BOOL) sendCampaignData: (MICampaignProperties *) campaignProperties {
    if(campaignProperties.oncePerSession) {
        MICampaignProperties *c = [campaignProperties copy];
        if(![_campaignsToIgnore containsObject:c]) {
            [_campaignsToIgnore addObject: c];
            return YES;
        } else {
            return NO;
        }
    }
    return YES;
}
//
//-(void) parseCampaignFrom: (NSDictionary *) trackingParams {
//    MICampaignProperties *campaign = [[MICampaignProperties alloc] init];
//    for (NSString *key in trackingParams) {
//        if ([[key substringToIndex:2] isEqualToString:@"mc"]) {
//            
//        }
//    }
//    
//}

@end
