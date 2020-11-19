//
//  MIActionEvent.m
//  MappIntelligenceSDK
//
//  Created by Miroljub Stoilkovic on 08/09/2020.
//  Copyright © 2020 Mapp Digital US, LLC. All rights reserved.
//

#import "MIActionEvent.h"

@implementation MIActionEvent

@synthesize pageName = _pageName;

-(instancetype)initWithName: (NSString *)name pageName: (NSString *)pageName actionProperties: (MIActionProperties*) actionProperties sessionProperties: (MISessionProperties *_Nullable)sessionProperties userProperties: (MIUserProperties *_Nullable) userProperties ecommerceProperties:(MIEcommerceProperties *_Nullable)ecommerceProperties  advertisementProperties: (AdvertisementProperties *_Nullable) advertisementProperties {
    self = [super init];
    _actionProperties = actionProperties;
    _sessionProperties = sessionProperties;
    _userProperties = userProperties;
    _ecommerceProperties = ecommerceProperties;
    _advertisementProperties = advertisementProperties;
    _pageName = pageName;
    _name = name;
    return self;
}

-(NSMutableArray<NSURLQueryItem*>*)asQueryItems {
    NSMutableArray<NSURLQueryItem*>* items = [[NSMutableArray alloc] init];
    if (_name) {
        [items addObject:[[NSURLQueryItem alloc] initWithName:@"ct" value:_name]];
    }
    items = [NSMutableArray arrayWithArray:[items arrayByAddingObjectsFromArray:[_actionProperties asQueryItems]]];
    return items;
}

@end
