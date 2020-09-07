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

- (NSMutableArray<NSURLQueryItem*>*)asQueryItemsFor:(TrackerRequest *)request {
    NSMutableArray<NSURLQueryItem*>* items = [[NSMutableArray alloc] init];
    if (_details) {
        for(NSString* key in _details) {
            NSString* value = @"";
            if ([_details[key] count] > 1) {
                value = [_details[key] componentsJoinedByString:@";"];
            } else {
                value = _details[key];
            }
            [items addObject:[[NSURLQueryItem alloc] initWithName:[NSString stringWithFormat:@"cp%@",key] value: value]];
        }
    }
    if (_groups) {
        for(NSString* key in _groups) {
            NSString* value = @"";
            if ([_groups[key] count] > 1) {
                value = [_groups[key] componentsJoinedByString:@";"];
            } else {
                value = _groups[key];
            }
            [items addObject:[[NSURLQueryItem alloc] initWithName:[NSString stringWithFormat:@"cg%@",key] value: value]];
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
