//
//  SessionProperties.m
//  MappIntelligenceSDK
//
//  Created by Miroljub Stoilkovic on 11/09/2020.
//  Copyright © 2020 Mapp Digital US, LLC. All rights reserved.
//

#import "SessionProperties.h"

@implementation SessionProperties

-(instancetype)initWithProperties: (NSDictionary<NSNumber* ,NSArray<NSString*>*>* _Nullable) properties {
    self = [self init];
    if (self) {
        _properties = properties;
    }
    return  self;
}

- (NSMutableArray<NSURLQueryItem *> *)asQueryItemsFor:(TrackerRequest *)request {
    NSMutableArray<NSURLQueryItem*>* items = [[NSMutableArray alloc] init];
    if (_properties) {
        for(NSNumber* key in _properties) {
            [items addObject:[[NSURLQueryItem alloc] initWithName:[NSString stringWithFormat:@"cs%@",key] value: [_properties[key] componentsJoinedByString:@";"]]];
        }
    }
    return items;
}
@end
