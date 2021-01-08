//
//  MIMediaEvent.m
//  MappIntelligenceSDK
//
//  Created by Miroljub Stoilkovic on 28/12/2020.
//  Copyright © 2020 Mapp Digital US, LLC. All rights reserved.
//

#import "MIMediaEvent.h"

@implementation MIMediaEvent

@synthesize pageName = _pageName;

- (instancetype)initWithPageName:(NSString *)name properties: (MIMediaProperties *)properties {
    self = [super init];
    _pageName = name;
    _mediaProperties = properties;
    return self;
}

@end
