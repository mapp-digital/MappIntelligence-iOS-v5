//
//  MIPageViewEvent.m
//  MappIntelligenceSDK
//
//  Created by Stefan Stevanovic on 3/6/20.
//  Copyright © 2020 Mapp Digital US, LLC. All rights reserved.
//

#import "MIPageViewEvent.h"

@implementation MIPageViewEvent

@synthesize pageName = _pageName;

- (instancetype)initWithName:(NSString *)name pageProperties:(MIPageProperties *)pageProperties {
    self = [super init];
    _pageProperties = pageProperties;
    _pageName = name;
    return self;
}

- (instancetype)initWithName:(NSString *)name pageProperties:(MIPageProperties *)pageProperties sessionProperties: (MISessionProperties *_Nullable) sessionProperties userProperties: (MIUserProperties *_Nullable) userProperties ecommerceProperties:(MIEcommerceProperties * _Nullable)ecommerceProperties advertisementProperties: (AdvertisementProperties *_Nullable) advertisementProperties{
    self = [super init];
    _pageProperties = pageProperties;
    _sessionProperties = sessionProperties;
    _userProperties = userProperties;
    _ecommerceProperties = ecommerceProperties;
    _advertisementProperties = advertisementProperties;
    _pageName = name;
    return self;
}

@end
