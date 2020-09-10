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

- (instancetype)initWithPageName:(NSString *)name andActionProperties:(ActionProperties *)actionProperties {
    self = [super init];
    _actionProperties = actionProperties;
    _pageName = name;
    return self;
}

@end
