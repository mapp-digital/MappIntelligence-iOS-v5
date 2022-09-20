//
//  AdvertisementProperties.m
//  MappIntelligenceSDK
//
//  Created by Miroljub Stoilkovic on 28/10/2020.
//  Copyright © 2020 Mapp Digital US, LLC. All rights reserved.
//

#import "MICampaignParameters.h"

#define key_campaign_id @"campaignId"
#define key_action @"action"
#define key_media_code @"mediaCode"
#define key_once_per_session @"oncePerSession"
#define key_custom_parameters @"customParameters"

@implementation MICampaignParameters

- (instancetype)initWith: (NSString *) campaignId {
    self = [super init];
    _campaignId = campaignId;
    return self;
}

- (instancetype)initWithDictionary:(NSDictionary*)dictionary {
    self = [super init];
    _campaignId = dictionary[key_campaign_id];
    long actionIntValue = [[dictionary valueForKey:key_action] longValue];
    if (actionIntValue == 1) {
        _action = click;
    } else if  (actionIntValue == 2) {
        _action = view;
    }
    _mediaCode = dictionary[key_media_code];
    _oncePerSession = dictionary[key_once_per_session];
    _customParameters = dictionary[key_custom_parameters];
    return self;
}

- (NSMutableArray<NSURLQueryItem *> *)asQueryItems {
    NSMutableArray<NSURLQueryItem*>* items = [[NSMutableArray alloc] init];
    
    NSString *mediaCode = _mediaCode ? _mediaCode : @"wt_mc";
    if (_campaignId) {
        [items addObject:[[NSURLQueryItem alloc] initWithName:@"mc" value: [NSString stringWithFormat:@"%@%@%@",mediaCode, @"%3D",_campaignId] ]];
    } else {
        [items addObject:[[NSURLQueryItem alloc] initWithName:@"mc" value:mediaCode]];
    }
    
    if (_action) {
        NSString *actionString = [NSString stringWithFormat:@"%@", _action == click ? @"c": @"v"];
        [items addObject:[[NSURLQueryItem alloc] initWithName:@"mca" value: actionString]];
    } else {
        [items addObject:[[NSURLQueryItem alloc] initWithName:@"mca" value:@"c"]];

    }
    if (_customParameters) {
        _customParameters = [self filterCustomDict:_customParameters];
        for(NSNumber* key in _customParameters) {
            [items addObject:[[NSURLQueryItem alloc] initWithName:[NSString stringWithFormat:@"cc%@",key] value: _customParameters[key]]];
        }
    }
    return items;
}

- (NSDictionary<NSNumber* ,NSString*> *) filterCustomDict: (NSDictionary<NSNumber* ,NSString*> *) dict{
    NSMutableDictionary *result = [[NSMutableDictionary alloc] init];
    for (NSNumber *idx in dict) {
        if (idx.intValue > 0) {
            [result setObject:dict[idx] forKey:idx];
        }
    }
    return result;
}

- (id)copyWithZone:(NSZone *)zone {
    MICampaignParameters *adCopy = [[MICampaignParameters alloc] init];
    [adCopy setCampaignId:_campaignId];
    [adCopy setMediaCode:_mediaCode];
    [adCopy setAction:_action];
    [adCopy setCustomParameters:_customParameters];
    [adCopy setOncePerSession:_oncePerSession];
    NSError *error;
    if (@available(iOS 11.0, *)) {
        NSData *data = [NSKeyedArchiver archivedDataWithRootObject:adCopy requiringSecureCoding:YES error:&error];
        adCopy = [NSKeyedUnarchiver unarchivedObjectOfClasses:[[NSSet alloc] initWithArray:@[[MICampaignParameters.class class],[NSString class]]]  fromData:data error:&error];
    } else {
        // Fallback on earlier versions
        NSData *data = [NSKeyedArchiver archivedDataWithRootObject:adCopy requiringSecureCoding:NO error:NULL];
        adCopy = [NSKeyedUnarchiver unarchivedObjectOfClass:[MICampaignParameters class] fromData:data error:NULL];
    }
    return adCopy;
}
- (void)encodeWithCoder:(nonnull NSCoder *)coder {
    [coder encodeObject:self.campaignId forKey:key_campaign_id];
    [coder encodeObject:self.mediaCode forKey:key_media_code];
    [coder encodeInteger: self.action forKey:key_action];
    [coder encodeObject:self.customParameters forKey:key_custom_parameters];
    [coder encodeBool:self.oncePerSession forKey:key_once_per_session];
}

- (nullable instancetype)initWithCoder:(nonnull NSCoder *)coder {
    if (self = [super init]) {
        self.campaignId = [coder decodeObjectForKey:key_campaign_id];
        self.mediaCode = [coder decodeObjectForKey:key_media_code];
        self.action = [coder decodeIntegerForKey: key_action];
        NSSet *classes = [NSSet setWithObjects:NSArray.class, NSDictionary.class, NSNumber.class, NSString.class, nil];
        self.customParameters = [coder decodeObjectOfClasses:classes forKey:key_custom_parameters];
        self.oncePerSession = [coder decodeBoolForKey:key_once_per_session];
    }
    return self;
}

- (BOOL)isEqual:(id)other {
    if (other == self) {
        return YES;
    }
    MICampaignParameters *otherObj = (MICampaignParameters *)other;
    if(self.action == otherObj.action &&
       self.oncePerSession == otherObj.oncePerSession &&
       [self.campaignId isEqual:otherObj.campaignId] &&
       [self.customParameters isEqual: otherObj.customParameters] &&
       [self.mediaCode isEqual: otherObj.mediaCode]) {
        return YES;
    }
    return NO;
}

+ (BOOL)supportsSecureCoding {
    return YES;
}
@end
