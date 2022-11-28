//
//  APXNetworkMetadata.m
//  AppoxeeSDK
//
//  Created by Raz Elkayam on 3/4/15.
//  Copyright (c) 2015 Appoxee. All rights reserved.
//
#if !TARGET_OS_WATCH || !TARGET_OS_TV
#import "APXNetworkMetadata.h"

@implementation NetworkMetadata

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
#endif
