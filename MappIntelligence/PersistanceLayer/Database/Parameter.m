//
//  Parameter.m
//  MappIntelligenceSDK
//
//  Created by Stefan Stevanovic on 10/06/2020.
//  Copyright © 2020 Mapp Digital US, LLC. All rights reserved.
//

#import "Parameter.h"

#define key_id @"id"
#define key_name @"name"
#define key_value @"value"
#define key_request_id @"request_table_id"


@implementation Parameter

#pragma mark - Initialization

- (instancetype)initWithKeyedValues:(NSDictionary *)keyedValues
{
    self = [super init];
    
    if (self) {
        
        [self setValuesForKeysWithDictionary:keyedValues];
    }
    
    return self;
}

#pragma mark - Helpers

- (void)setValuesForKeysWithDictionary:(NSDictionary *)keyedValues
{
    if (keyedValues) {
        
        if(keyedValues[key_id]) {
            self.uniqueId = @([keyedValues[key_id] integerValue]);
        }
        self.name = keyedValues[key_name];
        self.value = keyedValues[key_value];
        if (keyedValues[key_request_id]) {
            self.request_uniqueId = @([keyedValues[key_request_id] integerValue]);
        }
    }
}

- (NSDictionary *)dictionaryWithValuesForKeys:(NSArray *)keys
{
    NSMutableDictionary *keyedValues = [[NSMutableDictionary alloc] init];
    
    if (self.uniqueId) {
        
        keyedValues[key_id] = self.uniqueId;
    }
    
    if (self.name) {
        
        keyedValues[key_name] = self.name;
    }
    
    if (self.value) {
        
        keyedValues[key_value] = self.value;
    }
    
    if (self.request_uniqueId) {
        
        keyedValues[key_request_id] = self.request_uniqueId;
    }
    
    return keyedValues;
}

- (NSString*)print {
    return [[NSString alloc] initWithFormat:@"\n\n name: %@, value: %@", self.name, self.value];
}
@end
