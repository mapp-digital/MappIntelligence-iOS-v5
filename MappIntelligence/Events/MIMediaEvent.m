//
//  MIMediaEvent.m
//  MappIntelligenceSDK
//
//  Created by Miroljub Stoilkovic on 28/12/2020.
//  Copyright © 2020 Mapp Digital US, LLC. All rights reserved.
//

#import "MIMediaEvent.h"

@implementation MIMediaEvent

-(instancetype)initWith:(MIMediaProperties *)properties {
    self = [super init];
    _mediaProperties = properties;
    return self;
}

@end
