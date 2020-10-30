//
//  PageViewEvent.m
//  MappIntelligenceSDK
//
//  Created by Stefan Stevanovic on 3/6/20.
//  Copyright © 2020 Mapp Digital US, LLC. All rights reserved.
//

#import "PageViewEvent.h"

@implementation PageViewEvent

@synthesize pageName = _pageName;

- (instancetype)initWithName:(NSString *)name pageProperties:(PageProperties *)pageProperties {
    self = [super init];
    _pageProperties = pageProperties;
    _pageName = name;
    return self;
}

- (instancetype)initWithName:(NSString *)name pageProperties:(PageProperties *)pageProperties sessionProperties: (SessionProperties *_Nullable) sessionProperties userProperties: (UserProperties *_Nullable) userProperties ecommerceProperties:(EcommerceProperties * _Nullable)ecommerceProperties {
    self = [super init];
    _pageProperties = pageProperties;
    _sessionProperties = sessionProperties;
    _userProperties = userProperties;
    _ecommerceProperties = ecommerceProperties;
    _pageName = name;
    return self;
}

@end
