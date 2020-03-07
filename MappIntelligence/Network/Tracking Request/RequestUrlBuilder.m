//
//  RequestUrlBuilder.m
//  MappIntelligenceSDK
//
//  Created by Stefan Stevanovic on 3/7/20.
//  Copyright © 2020 Stefan Stevanovic. All rights reserved.
//

#import "RequestUrlBuilder.h"

@interface RequestUrlBuilder ()

@property NSURL* baseUrl;
@property NSURL* serverUrl;
@property NSString* mappIntelligenceId;

-(NSURL*)buildBaseUrlwithServer: (NSURL*) serverUrl andWithId: (NSString*) mappIntelligenceId;

@end

@implementation RequestUrlBuilder

- (instancetype)initWithUrl:(NSURL *)serverUrl andWithId:(NSString *)mappIntelligenceId {
    _serverUrl = serverUrl;
    _mappIntelligenceId = mappIntelligenceId;
    _baseUrl = [self buildBaseUrlwithServer:_serverUrl andWithId:_mappIntelligenceId];
    return self;
}

- (NSURL*)buildBaseUrlwithServer:(NSURL *)serverUrl andWithId:(NSString *)mappIntelligenceId {
    return [[serverUrl URLByAppendingPathComponent:mappIntelligenceId] URLByAppendingPathComponent:@"wt"];
}

@end
