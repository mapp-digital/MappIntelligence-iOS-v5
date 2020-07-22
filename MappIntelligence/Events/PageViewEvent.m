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

- (instancetype)initWith:(PageProperties *)properties {
    self = [super init];
    _pageProperties = properties;
    _pageName = @"defaultName";
    return self;
}
@end
