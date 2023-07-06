//
//  Request.m
//  MappIntelligenceSDK
//
//  Created by Stefan Stevanovic on 10/06/2020.
//  Copyright © 2020 Mapp Digital US, LLC. All rights reserved.
//

#import "MIDBRequest.h"
#import "MIRequestUrlBuilder.h"

#define key_id @"id"
#define key_domain @"track_domain"
#define key_ids @"track_ids"
#define key_status @"status"
#define key_date @"date"
#define key_parameters @"parameters"

@implementation MIDBRequest

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
            if(![item.name isEqual:NULL] && ![item.value isEqual:NULL])
                [self.parameters addObject:[[MIParameter alloc] initWithKeyedValues: @{@"name" : item.name, @"value" : item.value}]];
        }
        self.domain = domain;
        self.track_ids = trackids;
        self.status = ACTIVE;
    }
    [self print];
    return self;
}

#pragma mark - Helpers

- (void)setValuesForKeysWithDictionary:(NSDictionary *)keyedValues
{
    if (keyedValues) {
        
        self.uniqueId = @([keyedValues[key_id] integerValue]);
        self.domain = keyedValues[key_domain] ;
        self.track_ids = keyedValues[key_ids];
        switch ([keyedValues[key_status] integerValue]) {
            case 0:
                self.status = ACTIVE;
                break;
            case 1:
                self.status = SENT;
                break;
            case 2:
                self.status = FAILED;
                break;
            default:
                break;
        }
        NSString *dateString =  keyedValues[key_date];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        self.date = [dateFormatter dateFromString:dateString];
        //self.parameters = keyedValues[key_parameters];
    }
}

- (NSDictionary *)dictionaryWithValuesForKeys
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
    
    if (self.status >= ACTIVE && self.status <= FAILED) {
        keyedValues[key_status] = [NSNumber numberWithInt:(int)self.status] ;
    }
    
    if (self.parameters) {
        
        keyedValues[key_parameters] = self.parameters;
    }
    
    if (self.date) {
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        keyedValues[key_date] = [dateFormatter stringFromDate:self.date];
    }
    
    return keyedValues;
}

- (NSString*)print {
    NSString* request = [[NSString alloc] initWithFormat:@"ID: %@ and domain: %@ and ids: %@ and date: %@ and paramters: ", self.uniqueId, self.domain, self.track_ids, self.date];
    for(MIParameter* parameter in self.parameters) {
        request = [request stringByAppendingString:[parameter print]];
    }
    return request;
}

- (NSMutableArray<NSURLQueryItem *> *)convertParamtersWith: (BOOL)batch {
    NSMutableArray<NSURLQueryItem *> * array = [[NSMutableArray alloc] init];
    for (MIParameter* p in _parameters) {
        if (batch && ([p.name isEqualToString:@"eid"] || [p.name isEqualToString:@"X-WT-UA"] || [p.name isEqualToString:@"nc"])) {
            continue;
        }
        [array addObject:[[NSURLQueryItem alloc] initWithName:p.name value:p.value]];
    }
    return array;
}

- (NSURL *)urlForBatchSupprot: (BOOL)option {
    MIRequestUrlBuilder* builder = [[MIRequestUrlBuilder alloc] initWithUrl:[[NSURL alloc] initWithString:_domain] andWithId:_track_ids];
    return [builder createURLFromParametersWith:[self convertParamtersWith:option]];
}

- (BOOL)isEqualToRequest:(MIDBRequest *)request {
    return [self.uniqueId isEqualToNumber:request.uniqueId] &&
    [self.domain isEqualToString:request.domain] &&
    [self.track_ids isEqualToString:request.track_ids] &&
    [[NSNumber numberWithInt:(int)self.status] isEqualToNumber:[NSNumber numberWithInt:(int)request.status]] &&
    ( (self.parameters == nil && request.parameters == nil)? YES : [self.parameters isEqualToArray:request.parameters]) &&
    [self.date isEqualToDate:request.date];
}

- (BOOL)isEqual:(id)other
{
    if (other == self) {
        return YES;
    } else if (![other isKindOfClass:[MIDBRequest class]]) {
        return NO;
    } else {
        return [self isEqualToRequest:(MIDBRequest *)other];
    }
}

@end
