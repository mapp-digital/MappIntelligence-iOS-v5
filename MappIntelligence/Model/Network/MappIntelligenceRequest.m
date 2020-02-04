//
//  MappIntelligenceRequest.m
//  Webrekk
//
//  Created by Stefan Stevanovic on 1/3/20.
//  Copyright © 2020 Stefan Stevanovic. All rights reserved.
//

#import "MappIntelligenceRequest.h"
#import "MappIntelligenceLogger.h"
#import "MappIntelligenceDataService.h"

// MappIntelligence SDK
#define key_actions @"actions"
#define key_aliasValue @"alias"
#define key_register @"register"
#define key_applicationConfiguration @"app_conf"
#define key_reportPushOpen @"push_open"
#define key_reportPushDismissed @"push_dismissed"
#define key_reportRichPushOpen @"rich_open"
#define key_actions_setters @"set"
#define key_session_report @"activation"
#define key_richMessage @"messages"
#define key_applicationTags @"app_tags"
#define key_appliactionTagsUpdate @"tags"
#define key_customFields @"getCustomFields"
#define key_alias @"Alias"

// Geo Conf
#define key_geo_geo_conf @"geo_conf"
#define key_geo_get_regions @"get_regions"
#define key_geo_region_status @"region_status"
#define key_geo_update_geo_conf @"update_geo_conf"

@interface MappIntelligenceRequest ()

@property (nonatomic, strong) NSMutableDictionary *actions;
@property (nonatomic, strong) NSMutableDictionary *actionsSetters;
@property (nonatomic, strong) NSString *aliasValue;


@end

@implementation MappIntelligenceRequest

#pragma mark - Class Methods

- (void)addKeyedValues:(NSDictionary *)keyedValues forKeyType:(MappIntelligenceRequestKeyType)keyType
{
    NSString *key = [self keyForKeyType:keyType];
    
    AppLog(@"Adding keyedValues: %@, for key: %@", keyedValues, key);
    
    // special 'set' case.
    if ([key isEqualToString:key_actions_setters]) {
        
        for (NSString *key in [keyedValues allKeys]) {
            
            self.actionsSetters[key] = keyedValues[key];
        }
    }
//    [[MappIntelligenceDataService shared] getDeviceAliasWithCompletionHandler:^(NSError *error, id data) {
//        if (!error) {
//            if ([data isKindOfClass:[NSString class]]) {
//                self.aliasValue = data;
//                self.actions[key_aliasValue] = self.aliasValue;
//            }
//        }
//    }];
    
    if ([key isEqualToString:key_applicationTags]) {
        
        // special 'app_tags' case.
        [self.actions addEntriesFromDictionary:keyedValues];
        
    } else if ([key isEqualToString:key_customFields]) {
    
        // special custom fields case.
        [self.actions addEntriesFromDictionary:keyedValues];
        
    } else if ([key isEqualToString:key_alias]) {
        
        // special alias case.
        [self.actions addEntriesFromDictionary:keyedValues];
        
    } else {
        
        self.actions[key] = keyedValues;
    }
    
    AppLog(@"current request dictionary: %@", self.actions);
}

- (NSString *)keyForKeyType:(MappIntelligenceRequestKeyType)keyType
{
    NSString *key = nil;
    
    switch (keyType) {
            
        case kMappIntelligenceRequestKeyTypeRegister:
        {
           key = key_register;
        }
            break;
        case kMappIntelligenceRequestKeyTypeApplicationConfiguration:
        {
            key = key_applicationConfiguration;
        }
            break;
        case kMappIntelligenceRequestKeyTypeReportPushOpen:
        {
            key = key_reportPushOpen;
        }
            break;
        case kMappIntelligenceRequestKeyTypeReportPushDissmis:
        {
            key = key_reportPushDismissed;
        }
            break;
        case kMappIntelligenceRequestKeyTypeReportRichPushOpen:
        {
            key = key_reportRichPushOpen;
        }
            break;
        case kMappIntelligenceRequestKeyTypeActionSet:
        {
            key = key_actions_setters;
        }
            break;
        case kMappIntelligenceRequestKeyTypeSessionReport:
        {
            key = key_session_report;
        }
            break;
        case kMappIntelligenceRequestKeyTypeRichMessage:
        {
            key = key_richMessage;
        }
            break;
        case kMappIntelligenceRequestKeyTypeGetAppAndDeviceTags:
        {
            key = key_applicationTags;
        }
            break;
        case kMappIntelligenceRequestKeyTypeUpdateAppAndDeviceTags:
        {
            key = key_appliactionTagsUpdate;
        }
            break;
        case kMappIntelligenceRequestKeyTypeGetCustomFields:
        {
            key = key_customFields;
        }
            break;
        case kMappIntelligenceRequestKeyTypeGetAlias:
        {
            key = key_alias;
        }
            break;
        case kMappIntelligenceRequestKeyTypeGeoConfiguration:
        {
            key = key_geo_geo_conf;
        }
            break;
        case kMappIntelligenceRequestKeyTypeGeoGetAllRegions:
        {
            key = key_geo_get_regions;
        }
            break;
        case kMappIntelligenceRequestKeyTypeGeoReportCrossing:
        {
            key = key_geo_region_status;
        }
            break;
        case kMappIntelligenceRequestKeyTypeGeoUpdateGeoConf:
        {
            key = key_geo_update_geo_conf;
        }
            break;
    }
    
    return key;
}

- (NSDictionary *)dictionaryWithValuesForKeys:(NSArray *)keys
{
    NSMutableDictionary *keyedValues = [[NSMutableDictionary alloc] init];
    
    if (self.actions) {
        
        if ([[self.actionsSetters allKeys] count]) {
            
            self.actions[key_actions_setters] = self.actionsSetters;
        }
        
        keyedValues[key_actions] = self.actions;
    }
    
    return keyedValues;
}

#pragma mark - Getters

- (NSMutableDictionary *)actions
{
    if (!_actions) _actions = [[NSMutableDictionary alloc] init];
    return _actions;
}

- (NSMutableDictionary *)actionsSetters
{
    if (!_actionsSetters) _actionsSetters = [[NSMutableDictionary alloc] init];
    return _actionsSetters;
}

@end
