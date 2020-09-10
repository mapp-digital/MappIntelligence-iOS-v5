//
//  PageProperties.m
//  MappIntelligenceSDK
//
//  Created by Stefan Stevanovic on 17/07/2020.
//  Copyright © 2020 Mapp Digital US, LLC. All rights reserved.
//

#import "PageProperties.h"

@implementation PageProperties

-(instancetype)initWithPageParams: (NSMutableDictionary* _Nullable) parameters andWithPageCategory: (NSMutableDictionary* _Nullable) category andWithSearch: (NSString* _Nullable)internalSearch {
    self = [self init];
    if (self) {
        _details = parameters;
        _groups = category;
        _internalSearch = internalSearch;
    }
    return  self;
}

- (NSMutableArray<NSURLQueryItem*>*)asQueryItemsFor:(TrackerRequest *)request {
    NSMutableArray<NSURLQueryItem*>* items = [[NSMutableArray alloc] init];
    if (_details) {
        for(NSString* key in _details) {
            [items addObject:[[NSURLQueryItem alloc] initWithName:[NSString stringWithFormat:@"cp%@",key] value: [_details[key] componentsJoinedByString:@";"]]];
        }
    }
    if (_groups) {
        for(NSString* key in _groups) {
            [items addObject:[[NSURLQueryItem alloc] initWithName:[NSString stringWithFormat:@"cg%@",key] value: [_groups[key] componentsJoinedByString:@";"]]];
        }
    }
    if (_internalSearch) {
//        NSString* value = @"";
//        if ([_internalSearch count] > 1) {
//            value = [_internalSearch componentsJoinedByString:@";"];
//        } else {
//            value = _internalSearch;
//        }
        [items addObject:[[NSURLQueryItem alloc] initWithName:@"is" value:_internalSearch]];
    }
    return items;
}

@end
