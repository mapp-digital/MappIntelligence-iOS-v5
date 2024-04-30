//
//  MIRequestData.m
//  MappIntelligenceSDK
//
//  Created by Stefan Stevanovic on 10/06/2020.
//  Copyright © 2020 Mapp Digital US, LLC. All rights reserved.
//

#import "MIRequestData.h"
#import "MITrackerRequest.h"
#import "MappIntelligenceLogger.h"
#import "MIDatabaseManager.h"

#define KEY_REQUESTS @"requests"

@interface MIRequestData ()

@property (nonatomic, strong) NSMutableArray *requests; // of type Reques
@property (nonatomic, strong) MappIntelligenceLogger* logger;

@end

@implementation MIRequestData

#pragma mark - Initialization

- (instancetype)initWithKeyedValues:(NSDictionary * _Nullable)keyedValues
{
    self = [super init];
    
    if (self) {
        
        [self setValuesForKeysWithDictionary:keyedValues];
        _logger = [MappIntelligenceLogger shared];
    }
    
    return self;
}

- (instancetype)initWithRequests:(NSArray *)requests
{
    self = [self initWithKeyedValues:nil];
    
    if (self) {
    
        self.requests = [requests mutableCopy];
        _logger = [MappIntelligenceLogger shared];
    }

    return self;
}

#pragma mark - Helpers

- (void)setValuesForKeysWithDictionary:(NSDictionary *)keyedValues
{
    if (keyedValues) {
        self.requests = [[NSMutableArray alloc] init];
        NSArray *regions = keyedValues[KEY_REQUESTS];
        
        for (NSDictionary *regionDictionary in regions) {
            
            MIDBRequest *request = [[MIDBRequest alloc] initWithKeyedValues:regionDictionary];
            
            [self.requests addObject:request];
        }
    }
}

- (NSDictionary *)dictionaryWithValues
{
    NSMutableDictionary *keyedValues = [[NSMutableDictionary alloc] init];
    
    NSMutableArray *requestsDictionaries = [[NSMutableArray alloc] initWithCapacity:[self.regions count]];
    
    for (MIDBRequest *request in self.requests) {
        
        [requestsDictionaries addObject:[request dictionaryWithValuesForKeys]];
    }
    
    if ([requestsDictionaries count]) {
        
        keyedValues[KEY_REQUESTS] = requestsDictionaries;
    }
    
    return keyedValues;
}

- (NSString*)print {
    NSMutableString* requests = [[NSMutableString alloc] initWithString:@""];
    for (MIDBRequest* request in self.requests) {
        [requests appendString:[request print]];
    }
    return requests;
}

- (void)sendAllRequestsWithCompletitionHandler:(void (^)(NSError* ))completionHandler {
    for (MIDBRequest* r in _requests) {
        if([[r parameters] count] == 0)
            continue;
        MITrackerRequest *request = [MITrackerRequest shared];
        [request sendRequestWith: [r urlForBatchSupprot:NO] andCompletition:^(NSError * _Nonnull error) {
            if(error) {
                [self->_logger logObj:error forDescription:kMappIntelligenceLogLevelDescriptionDebug];
                [[MIDatabaseManager shared] updateStatusOfRequestWithId: (int)[r.uniqueId integerValue] andStatus:FAILED];
                completionHandler(error);
            } else {
                //remove request from DB
                [[MIDatabaseManager shared] deleteRequest:r.uniqueId.intValue];
                completionHandler(nil);
            }
        }];
    }
    if (_requests.count == 0) {
        completionHandler(nil);
    }}

#pragma mark - Getters

- (NSMutableArray *)regions
{
    if (!_requests) _requests = [[NSMutableArray alloc] init];
    return _requests;
}

@end
