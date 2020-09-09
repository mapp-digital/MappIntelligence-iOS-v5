//
//  ActionEvent.m
//  MappIntelligenceSDK
//
//  Created by Miroljub Stoilkovic on 08/09/2020.
//  Copyright © 2020 Mapp Digital US, LLC. All rights reserved.
//

#import "ActionEvent.h"

@implementation ActionEvent

@synthesize pageName = _pageName;

- (instancetype)initWith:(ActionProperties *)actionProperties
       andPageProperties:(PageProperties *)pageProperties {
    self = [super init];
    _actionProperties = actionProperties;
    _pageProperties = pageProperties;
    _pageName = @"defaultName";
    return self;
}

@end
