//
//  MIPageProperties.m
//  MappIntelligenceSDK
//
//  Created by Stefan Stevanovic on 17/07/2020.
//  Copyright © 2020 Mapp Digital US, LLC. All rights reserved.
//

#import "MIPageParameters.h"

#define key_details @"params"
#define key_groups @"categories"
#define key_internal_search @"searchTerm"

@implementation MIPageParameters

-(instancetype)initWithPageParams: (NSDictionary<NSNumber* ,NSString*>* _Nullable) parameters pageCategory: (NSMutableDictionary* _Nullable) category search: (NSString* _Nullable)internalSearch {
    self = [self init];
    if (self) {
        _details = parameters;
        _groups = category;
        _internalSearch = internalSearch;
    }
    return  self;
}

- (instancetype)initWithDictionary:(NSDictionary*)dictionary {
    self = [self init];
    if (self) {
        _details = dictionary[key_details];
        _groups = dictionary[key_groups];
        _internalSearch = dictionary[key_internal_search];
    }
    return  self;
}

- (NSMutableArray<NSURLQueryItem*>*)asQueryItems {
    NSMutableArray<NSURLQueryItem*>* items = [[NSMutableArray alloc] init];
    if (_details) {
        _details = [self filterCustomDict:_details];
        for(NSNumber* key in _details) {
            [items addObject:[[NSURLQueryItem alloc] initWithName:[NSString stringWithFormat:@"cp%@",key] value: _details[key]]];
        }
    }
    if (_groups) {
        for(NSString* key in _groups) {
            [items addObject:[[NSURLQueryItem alloc] initWithName:[NSString stringWithFormat:@"cg%@",key] value: _groups[key]]];
        }
    }
    if (_internalSearch) {
        [items addObject:[[NSURLQueryItem alloc] initWithName:@"is" value:_internalSearch]];
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
