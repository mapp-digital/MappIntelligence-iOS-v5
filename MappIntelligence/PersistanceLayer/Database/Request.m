//
//  Request.m
//  MappIntelligenceSDK
//
//  Created by Stefan Stevanovic on 10/06/2020.
//  Copyright © 2020 Mapp Digital US, LLC. All rights reserved.
//

#import "Request.h"

#define key_id @"id"
#define key_domain @"track_domain"
#define key_ids @"track_ids"
#define key_status @"status"
#define key_parameters @"parameters"

@implementation Request

#pragma mark - Initialization

- (instancetype)initWithKeyedValues:(NSDictionary *)keyedValues
{
    self = [super init];
    
    if (self) {
        
        [self setValuesForKeysWithDictionary:keyedValues];
    }
    
    return self;
}

- (instancetype)initWithParamters:(NSArray<NSURLQueryItem *> *)parameters andDomain: (NSString*) domain andTrackIds: (NSString*) trackids {
    self = [super init];
    
    if (self) {
        self.parameters = [[NSMutableArray alloc] init];
        for (NSURLQueryItem* item in parameters) {
            [self.parameters addObject:[[Parameter alloc] initWithKeyedValues: @{@"name" : item.name, @"value" : item.value}]];
        }
        self.domain = domain;
        self.track_ids = trackids;
        self.status = [[NSNumber alloc] initWithInt:0];
    }
    
    return self;
}

#pragma mark - Helpers

- (void)setValuesForKeysWithDictionary:(NSDictionary *)keyedValues
{
    if (keyedValues) {
        
        self.uniqueId = @([keyedValues[key_id] integerValue]);
        self.domain = [keyedValues[key_domain] stringValue];
        self.track_ids = [keyedValues[key_ids] stringValue];
        self.status = @([keyedValues[key_status] integerValue]);
        self.parameters = keyedValues[key_parameters];
    }
}

- (NSDictionary *)dictionaryWithValuesForKeys:(NSArray * _Nullable)keys
{
    NSMutableDictionary *keyedValues = [[NSMutableDictionary alloc] init];
    
    if (self.uniqueId) {
        
        keyedValues[key_id] = self.uniqueId;
    }
    
    if (self.domain) {
        
        keyedValues[key_domain] = self.domain;
    }
    
    if (self.track_ids) {
        
        keyedValues[key_ids] = self.track_ids;
    }
    
    if (self.status) {
        keyedValues[key_status] = self.status;
    }
    
    if (self.parameters) {
        
        keyedValues[key_parameters] = self.parameters;
    }
    
    return keyedValues;
}
@end
