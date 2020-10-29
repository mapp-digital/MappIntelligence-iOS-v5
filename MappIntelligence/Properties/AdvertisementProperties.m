//
//  AdvertisementProperties.m
//  MappIntelligenceSDK
//
//  Created by Miroljub Stoilkovic on 28/10/2020.
//  Copyright © 2020 Mapp Digital US, LLC. All rights reserved.
//

#import "AdvertisementProperties.h"

@implementation AdvertisementProperties


- (NSMutableArray<NSURLQueryItem *> *)asQueryItems {
    NSMutableArray<NSURLQueryItem*>* items = [[NSMutableArray alloc] init];
    if (_campaignId) {
        [items addObject:[[NSURLQueryItem alloc] initWithName:@"mc" value:_campaignId ]];
    }
    
    if (_action) {
        [items addObject:[[NSURLQueryItem alloc] initWithName:@"mca" value:_action]];
    }
    if (_properties) {
        for(NSNumber* key in _properties) {
            [items addObject:[[NSURLQueryItem alloc] initWithName:[NSString stringWithFormat:@"cc%@",key] value: [_properties[key] componentsJoinedByString:@";"]]];
        }
    }
    return items;
}
@end
