//
//  MISessionProperties.m
//  MappIntelligenceSDK
//
//  Created by Miroljub Stoilkovic on 11/09/2020.
//  Copyright © 2020 Mapp Digital US, LLC. All rights reserved.
//

#import "MISessionParameters.h"

@implementation MISessionParameters

-(instancetype)initWithParameters: (NSDictionary<NSNumber* ,NSString*>* _Nullable) parameters {
    self = [self init];
    if (self) {
        _parameters = parameters;
    }
    return  self;
}

- (NSMutableArray<NSURLQueryItem *> *)asQueryItems {
    NSMutableArray<NSURLQueryItem*>* items = [[NSMutableArray alloc] init];
    if (_parameters) {
        _parameters = [self filterCustomDict:_parameters];
        for(NSNumber* key in _parameters) {
            [items addObject:[[NSURLQueryItem alloc] initWithName:[NSString stringWithFormat:@"cs%@",key] value: _parameters[key]]];
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
