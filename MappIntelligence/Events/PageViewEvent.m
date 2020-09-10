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

- (instancetype)initWithName:(NSString *)name andWithProperties:(PageProperties *)properties {
    self = [super init];
    _pageProperties = properties;
    _pageName = name;
    return self;
}

@end
