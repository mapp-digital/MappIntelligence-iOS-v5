//
//  AdvertisementProperties.m
//  MappIntelligenceSDK
//
//  Created by Miroljub Stoilkovic on 28/10/2020.
//  Copyright © 2020 Mapp Digital US, LLC. All rights reserved.
//

#import "AdvertisementProperties.h"

@implementation AdvertisementProperties

- (instancetype)initWith: (NSString *) campaignId {
    self = [super init];
    _campaignId = campaignId;
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
        NSString *actionString = [NSString stringWithFormat:@"%@", _action == 0 ? @"c": @"v"];
        [items addObject:[[NSURLQueryItem alloc] initWithName:@"mca" value: actionString]];
    } else {
        [items addObject:[[NSURLQueryItem alloc] initWithName:@"mca" value:@"c"]];

    }
    if (_customProperties) {
        for(NSNumber* key in _customProperties) {
            [items addObject:[[NSURLQueryItem alloc] initWithName:[NSString stringWithFormat:@"cc%@",key] value: [_customProperties[key] componentsJoinedByString:@";"]]];
        }
    }
    return items;
}
@end
