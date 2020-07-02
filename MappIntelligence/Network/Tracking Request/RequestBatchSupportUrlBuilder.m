//
//  RequestBatchSupportUrlBuilder.m
//  MappIntelligenceSDK
//
//  Created by Stefan Stevanovic on 02/07/2020.
//  Copyright © 2020 Mapp Digital US, LLC. All rights reserved.
//

#import "RequestBatchSupportUrlBuilder.h"
#import "MappIntelligence.h"
#import "DefaultTracker.h"

@implementation RequestBatchSupportUrlBuilder


- (instancetype)init
{
    self = [super init];
    if (self) {
        //initialisation of base url
        _baseUrl = [[NSString alloc] initWithFormat:@"%@/%@/batch?eid=%@", [MappIntelligence getUrl], [MappIntelligence getId],  [[DefaultTracker sharedInstance] generateEverId]];
        
    }
    return self;
}

-(NSString*)createBody {
    return @"";
}
@end
