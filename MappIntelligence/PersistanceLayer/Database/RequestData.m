//
//  RequestData.m
//  MappIntelligenceSDK
//
//  Created by Stefan Stevanovic on 10/06/2020.
//  Copyright © 2020 Mapp Digital US, LLC. All rights reserved.
//

#import "RequestData.h"
#import "TrackerRequest.h"
#import "DatabaseManager.h"

#define KEY_REGIONS @"regions"

@interface RequestData ()

@property (nonatomic, strong) NSMutableArray *requests; // of type Reques

@end

@implementation RequestData

#pragma mark - Initialization

- (instancetype)initWithKeyedValues:(NSDictionary * _Nullable)keyedValues
{
    self = [super init];
    
    if (self) {
        
        [self setValuesForKeysWithDictionary:keyedValues];
    }
    
    return self;
}

- (instancetype)initWithRequests:(NSArray *)requests
{
    self = [self initWithKeyedValues:nil];
    
    if (self) {
    
        self.requests = [requests mutableCopy];
    }

    return self;
}

#pragma mark - Helpers

- (void)setValuesForKeysWithDictionary:(NSDictionary *)keyedValues
{
    if (keyedValues) {
        
        NSArray *regions = keyedValues[KEY_REGIONS];
        
        for (NSDictionary *regionDictionary in regions) {
            
            Request *request = [[Request alloc] initWithKeyedValues:regionDictionary];
            
            [self.requests addObject:request];
        }
    }
}

- (NSDictionary *)dictionaryWithValuesForKeys:(NSArray *)keys
{
    NSMutableDictionary *keyedValues = [[NSMutableDictionary alloc] init];
    
    NSMutableArray *requestsDictionaries = [[NSMutableArray alloc] initWithCapacity:[self.regions count]];
    
    for (Request *request in self.requests) {
        
        [requestsDictionaries addObject:[request dictionaryWithValuesForKeys:nil]];
    }
    
    if ([requestsDictionaries count]) {
        
        keyedValues[KEY_REGIONS] = requestsDictionaries;
    }
    
    return keyedValues;
}

- (void)print {
    for (Request* request in self.requests) {
        [request print];
    }
}

- (void)sendAllRequests {
    for (Request* r in _requests) {
        TrackerRequest *request = [[TrackerRequest alloc] init];
        [request sendRequestWith:r.url andCompletition:^(NSError * _Nonnull error) {
            if(error) {
                //TODO: log error 
            } else {
                //remove request from DB
                [[DatabaseManager shared] deleteRequest:r.uniqueId.intValue];
            }
        }];
    }
}

#pragma mark - Getters

- (NSMutableArray *)regions
{
    if (!_requests) _requests = [[NSMutableArray alloc] init];
    return _requests;
}

@end
