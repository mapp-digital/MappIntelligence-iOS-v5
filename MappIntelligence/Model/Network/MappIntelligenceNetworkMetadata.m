//
//  MappIntelligenceNetworkMetadata.m
//  Webrekk
//
//  Created by Stefan Stevanovic on 1/3/20.
//  Copyright © 2020 Stefan Stevanovic. All rights reserved.
//

#import "MappIntelligenceNetworkMetadata.h"

@implementation MappIntelligenceNetworkMetadata

- (id)initWithKeyedValues:(NSDictionary *)keyedValues
{
    self = [super init];
    
    if (self) {
        
        [self setValuesForKeysWithDictionary:keyedValues];
    }
    
    return self;
}

- (void)setValuesForKeysWithDictionary:(NSDictionary *)keyedValues
{
    if (keyedValues) {
        
        self.code = [keyedValues[@"code"] integerValue];
        self.succes = ![keyedValues[@"error"] boolValue];
        self.message = keyedValues[@"message"];
    }
}

@end
