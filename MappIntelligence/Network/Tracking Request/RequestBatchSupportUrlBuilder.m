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
#import "DatabaseManager.h"
#import "RequestData.h"
#import "TrackerRequest.h"
#import "MappIntelligenceLogger.h"

@interface RequestBatchSupportUrlBuilder ()

@property DatabaseManager* dbManager;
@property MappIntelligenceLogger* loger;

@end

@implementation RequestBatchSupportUrlBuilder


- (instancetype)init
{
    self = [super init];
    if (self) {
        //initialisation of base url
        _baseUrl = [[NSString alloc] initWithFormat:@"%@/%@/batch?eid=%@", [MappIntelligence getUrl], [MappIntelligence getId],  [[DefaultTracker sharedInstance] generateEverId]];
        _dbManager = [DatabaseManager shared];
        _loger = [MappIntelligenceLogger shared];
        
    }
    return self;
}

-(void)sendBatchForRequests {
    [_dbManager fetchAllRequestsWithCompletionHandler:^(NSError * _Nonnull error, id  _Nullable data) {
        RequestData* dt = (RequestData*)data;
        NSString* body = [self createBatchWith:dt];
        TrackerRequest *request = [[TrackerRequest alloc] init];
        [request sendRequestWith:[[NSURL alloc] initWithString:self->_baseUrl] andBody:body andCompletition:^(NSError * _Nonnull error) {
            if (!error) {;
                [self->_loger logObj: [[NSString alloc] initWithFormat:@"Batch request sent successfuly!"] forDescription: kMappIntelligenceLogLevelDescriptionDebug];
                [self->_dbManager removeRequestsDB:[self getRequestIDs:dt]];
            }
        }];
    }];
}

-(NSString*)createBatchWith:(RequestData*) data {
    NSMutableString* body = [[NSMutableString alloc] init];
    for (Request* req in data.requests) {
        [body appendString:@"wt?"];
        [body appendString: [[req url] query]];
        [body appendString:@"\n"];
    }
    return body;
}

-(NSArray* )getRequestIDs:(RequestData*) data {
    NSMutableArray* array = [[NSMutableArray alloc] init];
    for (Request* req in data.requests) {
        [array addObject:req.uniqueId];
    }
    return array;
}


@end
