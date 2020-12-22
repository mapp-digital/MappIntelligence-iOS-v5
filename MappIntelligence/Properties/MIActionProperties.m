//
//  MIActionProperties.m
//  MappIntelligenceSDK
//
//  Created by Miroljub Stoilkovic on 08/09/2020.
//  Copyright © 2020 Mapp Digital US, LLC. All rights reserved.
//

#import "MIActionProperties.h"

@implementation MIActionProperties

-(instancetype)initWithProperties: (NSDictionary<NSNumber* ,NSString*>* _Nullable) properties {
    self = [self init];
    if (self) {
        _properties = properties;
    }
    return  self;
}

- (NSMutableArray<NSURLQueryItem *> *)asQueryItems {
    NSMutableArray<NSURLQueryItem*>* items = [[NSMutableArray alloc] init];
    if (_properties) {
        _properties = [self filterCustomDict:_properties];
        for(NSNumber* key in _properties) {
            [items addObject:[[NSURLQueryItem alloc] initWithName:[NSString stringWithFormat:@"ck%@",key] value: _properties[key]]];
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
@end
