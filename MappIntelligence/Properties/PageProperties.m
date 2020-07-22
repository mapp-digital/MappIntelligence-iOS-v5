//
//  PageProperties.m
//  MappIntelligenceSDK
//
//  Created by Stefan Stevanovic on 17/07/2020.
//  Copyright © 2020 Mapp Digital US, LLC. All rights reserved.
//

#import "PageProperties.h"

@implementation PageProperties

-(instancetype)initWith:(NSMutableDictionary *)details andWithGroup:(NSMutableDictionary *)groups andWithSearch:(NSString *)internalSearch {
    self = [self init];
    if (self) {
        _details = details;
        _groups = groups;
        _internalSearch = internalSearch;
    }
    return  self;
}
//TODO: investigate do we need request
- (NSMutableArray<NSURLQueryItem*>*)asQueryItemsFor:(TrackerRequest *)request {
    NSMutableArray<NSURLQueryItem*>* items = [[NSMutableArray alloc] init];
    if (_details) {
        for(NSString* key in _details) {
            [items addObject:[[NSURLQueryItem alloc] initWithName:[NSString stringWithFormat:@"cp%@",key] value: _details[key]]];
        }
    }
    if (_groups) {
        for(NSString* key in _groups) {
            [items addObject:[[NSURLQueryItem alloc] initWithName:[NSString stringWithFormat:@"ct%@",key] value: _groups[key]]];
        }
    }
    if (_internalSearch) {
        [items addObject:[[NSURLQueryItem alloc] initWithName:@"is" value:_internalSearch]];
    }
    return items;
}

@end
