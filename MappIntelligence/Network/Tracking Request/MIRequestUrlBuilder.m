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
#import "MIMediaEvent.h"
#import "MIDefaultTracker.h"

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
#define DMC_USER_ID @"dmcUserId"
#define EMAIL_RECEIVER_ID @"emailReceiverIdUserDefaults"
    MITrackingEvent *event = [request event];
  NSString *pageNameOpt = [event pageName];
  NSURL *url;

  if (!pageNameOpt && ![event isKindOfClass:MIFormSubmitEvent.class]) {
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
  NSString *libraryVersionOriginal = [[MappIntelligence version] substringToIndex:5];
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
    if(properties.everId) {
        [parametrs addObject:[NSURLQueryItem queryItemWithName:@"eid"
                                                         value:properties.everId]];
    }
    if(![[MIDefaultTracker sharedInstance] anonymousTracking]) {
        if ([[NSUserDefaults standardUserDefaults] objectForKey:EMAIL_RECEIVER_ID]) {
            [parametrs addObject:[NSURLQueryItem queryItemWithName:@"uc701"
                                                             value:[[NSUserDefaults standardUserDefaults] objectForKey:EMAIL_RECEIVER_ID]]];
        } else if([[NSUserDefaults standardUserDefaults] objectForKey:DMC_USER_ID] && [[MIDefaultTracker sharedInstance] isUserMatchingEnabled]) {
            [parametrs addObject:[NSURLQueryItem queryItemWithName:@"uc701"
                                                             value:[[NSUserDefaults standardUserDefaults] objectForKey:DMC_USER_ID]]];
        }
    }
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
    [parametrs addObject:[NSURLQueryItem queryItemWithName:@"cs801" value:[[MIDefaultTracker sharedInstance] version]]];
    [parametrs addObject:[NSURLQueryItem queryItemWithName:@"cs802" value:[[MIDefaultTracker sharedInstance] platform]]];
    if([[MIDefaultTracker sharedInstance] anonymousTracking]) {
        [parametrs addObject:[NSURLQueryItem queryItemWithName:@"pf" value:[[[MIDefaultTracker sharedInstance] usageStatistics] getUserStatisticsValue]]];
        [[[MIDefaultTracker sharedInstance] usageStatistics] printUserStatistics];
        if ([[MIDefaultTracker sharedInstance] temporaryID]) {
            [parametrs addObject:[NSURLQueryItem queryItemWithName:@"fpv" value:[[MIDefaultTracker sharedInstance] temporaryID]]];
        }
    }

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
            MIPageParameters* prop = ((MIPageViewEvent*)event).pageParameters;
            [parametrs addObjectsFromArray:[prop asQueryItems]];
            MIPageViewEvent* pgEvent = ((MIPageViewEvent*)event);
            MISessionParameters *session = pgEvent.sessionParameters;
            [parametrs addObjectsFromArray:[session asQueryItems]];
            MIUserCategories *userCategories = pgEvent.userCategories;
            if(userCategories) {
                parametrs = [self removeDmcUserId:parametrs and:[userCategories asQueryItems]];
            }
            [parametrs addObjectsFromArray:[userCategories asQueryItems]];
            MIEcommerceParameters *ecommerceParameters = pgEvent.ecommerceParameters;
            [parametrs addObjectsFromArray:[ecommerceParameters asQueryItems]];
            
            MICampaignParameters *advertisementProperties = ((MIPageViewEvent*)event).campaignParameters;
            if (advertisementProperties && [self sendCampaignData:advertisementProperties]) {
                [parametrs addObjectsFromArray:[advertisementProperties asQueryItems]];
            } else {
                MICampaignParameters *saved = [MIDeepLink loadCampaign];
                if (saved) {
                    [parametrs addObjectsFromArray:[saved asQueryItems]];
                    [MIDeepLink deleteCampaign];
                }
            }
        } else if ([event isKindOfClass:MIActionEvent.class]) {
            [parametrs addObjectsFromArray:[(MIActionEvent*)event asQueryItems]];
            MISessionParameters *session = ((MIActionEvent*)event).sessionParameters;
            [parametrs addObjectsFromArray:[session asQueryItems]];
            MIUserCategories *userCategories = ((MIActionEvent*)event).userCategories;
            parametrs = [self removeDmcUserId:parametrs and:[userCategories asQueryItems]];
            [parametrs addObjectsFromArray:[userCategories asQueryItems]];
            MIEcommerceParameters *ecommerceParameters = ((MIActionEvent*)event).ecommerceParameters;
            [parametrs addObjectsFromArray:[ecommerceParameters asQueryItems]];
            MICampaignParameters *advertisementProperties = ((MIActionEvent*)event).campaignParameters;
            if ([self sendCampaignData:advertisementProperties]) {
                [parametrs addObjectsFromArray:[advertisementProperties asQueryItems]];
            }
        } else if ([event isKindOfClass:MIMediaEvent.class]) {
            MIMediaParameters *media = ((MIMediaEvent*)event).mediaParameters;
            [parametrs addObjectsFromArray:[media asQueryItems]];
            MISessionParameters *session = ((MIMediaEvent*)event).sessionParameters;
            [parametrs addObjectsFromArray:[session asQueryItems]];
            MIEventParameters *eventParameters = ((MIMediaEvent*)event).eventParameters;
            [parametrs addObjectsFromArray:[eventParameters asQueryItems]];
            MIEcommerceParameters *ecommerceProperties = ((MIMediaEvent*)event).ecommerceParameters;
            [parametrs addObjectsFromArray:[ecommerceProperties asQueryItems]];
        } else if ([event isKindOfClass:MIFormSubmitEvent.class]) {
            [parametrs addObjectsFromArray:[((MIFormSubmitEvent*)event).formParameters asQueryItems]];
        }
    }
    
    if ([[MappIntelligence shared] sendAppVersionInEveryRequest]) {
        if (MIEnvironment.appVersion) {
            [parametrs addObject:[NSURLQueryItem queryItemWithName:@"cs804" value: MIEnvironment.appVersion]];
        }
    } else if (properties.isFirstEventOfSession) {
        if (MIEnvironment.appVersion) {
            [parametrs addObject:[NSURLQueryItem queryItemWithName:@"cs804" value: MIEnvironment.appVersion]];
        }
    }
    
    if (properties.isFirstEventOfSession) {
        [parametrs addObject:[NSURLQueryItem queryItemWithName:@"cs805" value: MIEnvironment.buildVersion]];
        [parametrs addObject:[NSURLQueryItem queryItemWithName:@"cs821" value: properties.isFirstEventOfApp ? @"1": @"0"]];
    }
    
    //process anonimous tracking
    if ([[MIDefaultTracker sharedInstance] anonymousTracking]) {
        parametrs = [self getAnonimousParams:parametrs];
    }
    
    [parametrs addObject:[NSURLQueryItem queryItemWithName:@"eor" value:@"1"]];
    
    [_sizeMonitor setCurrentRequestSize:[_sizeMonitor currentRequestSize] +
                                       5]; // add for end of the request
  
    url = [self createURLFromParametersWith:parametrs];
  _dbRequest = [[MIDBRequest alloc] initWithParamters:parametrs
                                        andDomain:[MappIntelligence getUrl]
                                      andTrackIds:[MappIntelligence getId]];
  return url;
}

-(BOOL)containsEmailReceiverId:(NSArray<NSURLQueryItem *> *)parameters {
    for (NSURLQueryItem* key in parameters) {
        if( [key.name  isEqual: @"uc701"]) {
            [[NSUserDefaults standardUserDefaults] setObject:key.value forKey:EMAIL_RECEIVER_ID];
            [[NSUserDefaults standardUserDefaults] synchronize];
            return YES;
        }
    }
    return NO;
}

-(NSMutableArray<NSURLQueryItem *> *)removeDmcUserId:(NSMutableArray<NSURLQueryItem *> *) parameters and:(NSArray<NSURLQueryItem *> *) newParameters {
    
    if([self containsEmailReceiverId:newParameters] && [[NSUserDefaults standardUserDefaults] objectForKey:DMC_USER_ID] && [[MIDefaultTracker sharedInstance] isUserMatchingEnabled] ) {
        NSMutableArray<NSURLQueryItem *> *reversedCalEvents = [parameters mutableCopy];
        [reversedCalEvents removeObject:[NSURLQueryItem queryItemWithName:@"uc701"
                                                                    value:[[NSUserDefaults standardUserDefaults] objectForKey:DMC_USER_ID]]];
        return reversedCalEvents;
    }
    return [parameters mutableCopy];
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

    NSString* codeChar = @"$', /:?@=&+()!;";
  NSCharacterSet *cValue = [NSCharacterSet URLQueryAllowedCharacterSet];
    NSMutableCharacterSet *csValue = [cValue mutableCopy];
    
    for (NSInteger charIdx=0; charIdx<codeChar.length; charIdx++) {
        unichar ch = [codeChar characterAtIndex:charIdx];
        [csValue removeCharactersInString:[NSString stringWithFormat:@"%C", ch]];
    }

    return [str stringByAddingPercentEncodingWithAllowedCharacters:csValue];
}

-(BOOL) sendCampaignData: (MICampaignParameters *) campaignProperties {
    if(campaignProperties.oncePerSession) {
        MICampaignParameters *c = [campaignProperties copy];
        if(![_campaignsToIgnore containsObject:c]) {
            if(_campaignsToIgnore.count < 100) {
                [_campaignsToIgnore addObject: c];
            }
            return YES;
        } else {
            return NO;
        }
    }
    return YES;
}

-(NSMutableArray *) getAnonimousParams: (NSMutableArray *) params {
    NSMutableArray *anonimParams = [[NSMutableArray alloc] init];
    NSArray *suppressed = [[MIDefaultTracker sharedInstance] suppressedParameters];
    for (NSURLQueryItem *item in params) {
        if (![suppressed containsObject: item.name] && ![item.name isEqualToString:@"eid"]) {
            [anonimParams addObject:item];
        }
    }
    [anonimParams addObject:[NSURLQueryItem queryItemWithName:@"nc" value:@"1"]];
    return anonimParams;
}
@end


@implementation NSString(Replacing)

- (NSString *)stringByReplacingCharactersInSet:(NSCharacterSet *)charSet withString:(NSString *)aString {
    NSMutableString *s = [NSMutableString stringWithCapacity:self.length];
    for (NSUInteger i = 0; i < self.length; ++i) {
        unichar c = [self characterAtIndex:i];
        if (![charSet characterIsMember:c]) {
            [s appendFormat:@"%C", c];
        } else {
            [s appendString:aString];
        }
    }
    return s;
}


@end
