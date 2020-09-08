//
//  ActionProperties.m
//  MappIntelligenceSDK
//
//  Created by Miroljub Stoilkovic on 08/09/2020.
//  Copyright © 2020 Mapp Digital US, LLC. All rights reserved.
//

#import "ActionProperties.h"

@implementation ActionProperties

- (instancetype)initWith:(NSString *)name andDetails:(NSMutableDictionary *)details {
    self = [self init];
    if (self) {
        _name = name;
        _details = details;
    }
    return  self;
}

- (NSMutableArray<NSURLQueryItem *> *)asQueryItemsFor:(TrackerRequest *)request {
    NSMutableArray<NSURLQueryItem*>* items = [[NSMutableArray alloc] init];
    if (_name) {
        [items addObject:[[NSURLQueryItem alloc] initWithName:@"ct" value:_name]];
    }
    
    if (_details) {
        for(NSString* key in _details) {
            [items addObject:[[NSURLQueryItem alloc] initWithName:[NSString stringWithFormat:@"ck%@",key] value: [_details[key] componentsJoinedByString:@";"]]];
        }
    }
    return items;
}

@end
