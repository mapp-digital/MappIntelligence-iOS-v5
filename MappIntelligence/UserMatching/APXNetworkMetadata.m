//
//  APXNetworkMetadata.m
//  AppoxeeSDK
//
//  Created by Raz Elkayam on 3/4/15.
//  Copyright (c) 2015 Appoxee. All rights reserved.
//
#import "APXNetworkMetadata.h"

@implementation MINetworkMetadata

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
        if (keyedValues[@"error"] == nil) {
            self.succes = false;
        } else {
            self.succes = ![keyedValues[@"error"] boolValue];
        }
        self.message = keyedValues[@"message"];
    }
}

@end
