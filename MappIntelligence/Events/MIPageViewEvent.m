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

- (instancetype)initWithName:(NSString *)name {
    self = [super init];
    _pageName = name;
    return self;
}

@end
