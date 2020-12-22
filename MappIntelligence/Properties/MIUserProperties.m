//
//  MIUserProperties.m
//  MappIntelligenceSDK
//
//  Created by Miroljub Stoilkovic on 20/10/2020.
//  Copyright © 2020 Mapp Digital US, LLC. All rights reserved.
//

#import "MIUserProperties.h"


@implementation MIUserProperties

- (instancetype)initWithCustomProperties: (NSDictionary<NSNumber* ,NSString*>* _Nullable) properties {
    self = [super init];
    if (self) {
        _customProperties = properties;
    }
    return self;
}

- (NSMutableArray<NSURLQueryItem*>*)asQueryItems {
    NSMutableArray<NSURLQueryItem*>* items = [[NSMutableArray alloc] init];
    
    if (_customProperties) {
        _customProperties = [self filterCustomDict:_customProperties];
        for(NSNumber* key in _customProperties) {
            [items addObject:[[NSURLQueryItem alloc] initWithName:[NSString stringWithFormat:@"uc%@",key] value: _customProperties[key]]];
        }
    }
    
    if (_birthday.day && _birthday.month && _birthday.year) {
        items = [self removeObjectWith:@"uc707" from:items];
        [items addObject:[[NSURLQueryItem alloc] initWithName:@"uc707" value: [self getBirthday]]];
    }
    if (_city) {
        items = [self removeObjectWith:@"uc708" from:items];
        [items addObject:[[NSURLQueryItem alloc] initWithName:@"uc708" value:_city]];
    }
    if (_country) {
        items = [self removeObjectWith:@"uc709" from:items];
        [items addObject:[[NSURLQueryItem alloc] initWithName:@"uc709" value:_country]];
    }
    if (_emailAddress) {
        items = [self removeObjectWith:@"uc700" from:items];
        [items addObject:[[NSURLQueryItem alloc] initWithName:@"uc700" value:_emailAddress]];
    }
    if (_emailReceiverId) {
        items = [self removeObjectWith:@"uc701" from:items];
        [items addObject:[[NSURLQueryItem alloc] initWithName:@"uc701" value:_emailReceiverId]];
    }
    if (_firstName) {
        items = [self removeObjectWith:@"uc703" from:items];
        [items addObject:[[NSURLQueryItem alloc] initWithName:@"uc703" value:_firstName]];
    }
    if (_gender) {
        items = [self removeObjectWith:@"uc706" from:items];
        [items addObject:[[NSURLQueryItem alloc] initWithName:@"uc706" value: [NSString stringWithFormat:@"%ld", (long)_gender]]];
    }
    if (_customerId) {
        [items addObject:[[NSURLQueryItem alloc] initWithName:@"cd" value:_customerId]];
    }
    if (_lastName) {
        items = [self removeObjectWith:@"uc704" from:items];
        [items addObject:[[NSURLQueryItem alloc] initWithName:@"uc704" value:_lastName]];
    }
    if (_newsletterSubscribed) {
        items = [self removeObjectWith:@"uc702" from:items];
        [items addObject:[[NSURLQueryItem alloc] initWithName:@"uc702" value: (_newsletterSubscribed ? @"1" : @"2")]];
    }
    if (_phoneNumber) {
        items = [self removeObjectWith:@"uc705" from:items];
        [items addObject:[[NSURLQueryItem alloc] initWithName:@"uc705" value:_phoneNumber]];
    }
    if (_street) {
        items = [self removeObjectWith:@"uc711" from:items];
        [items addObject:[[NSURLQueryItem alloc] initWithName:@"uc711" value:_street]];
    }
    if (_streetNumber) {
        items = [self removeObjectWith:@"uc712" from:items];
        [items addObject:[[NSURLQueryItem alloc] initWithName:@"uc712" value:_streetNumber]];
    }
    if (_zipCode) {
        items = [self removeObjectWith:@"uc710" from:items];
        [items addObject:[[NSURLQueryItem alloc] initWithName:@"uc710" value:_zipCode]];
    }
    return items;
}

- (NSString *) getBirthday {
    if (_birthday.day && _birthday.month && _birthday.year) {
        return [NSString stringWithFormat:@"%4d%02d%02d", _birthday.year, _birthday.month, _birthday.day];
    }
    return @"";
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

- (NSMutableArray<NSURLQueryItem*>*) removeObjectWith:(NSString *) name from: (NSMutableArray<NSURLQueryItem*> *) items {
    NSURLQueryItem *itemToRemove = nil;
    for (NSURLQueryItem *item in items) {
        if (item.name == name) {
            itemToRemove = item;
        }
    }
    if (itemToRemove) {
        [items removeObject:itemToRemove];
    }
    return items;
}
@end
