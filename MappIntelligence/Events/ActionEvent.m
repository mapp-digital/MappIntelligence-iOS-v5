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

-(instancetype)initWithPageName: (NSString *)name actionProperties: (ActionProperties*) actionProperties sessionProperties: (SessionProperties *_Nullable) sessionProperties {
    self = [super init];
    _actionProperties = actionProperties;
    _sessionProperties = sessionProperties;
    _pageName = name;
    return self;
}

@end
