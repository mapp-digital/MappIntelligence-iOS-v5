//
//  MappIntelligenceRequestBuilder.m
//  Webrekk
//
//  Created by Stefan Stevanovic on 1/3/20.
//  Copyright © 2020 Stefan Stevanovic. All rights reserved.
//

#import "MappIntelligenceRequestBuilder.h"
#import "MappIntelligenceDataService.h"
#import "MappIntelligenceLogger.h"

@interface MappIntelligenceRequestBuilder ()

@property (nonatomic, strong) NSString *key;
@property (nonatomic, strong) NSString *aliasValue;
@property (nonatomic, strong) NSString *oldAliasValue;
@property (nonatomic, strong) NSString *customerID;
@property (nonatomic, strong) NSString *userID;
@property (nonatomic, strong) NSString *messageID;
@property (nonatomic, strong) NSString *sendOutID;
@property (nonatomic, strong, readwrite) MappIntelligenceRequest *request;
@property (nonatomic) MappIntelligenceRequestKeyType keyType;
@end

@implementation MappIntelligenceRequestBuilder

- (id)init
{
    self = [super init];
    
//    if (self) {
//
//        self.key = [MappIntelligenceDevice deviceUniqueGlobaldentifier];
//
//        self.aliasValue = [[MappIntelligenceDataService shared] alias];
//        self.oldAliasValue = [[MappIntelligenceDataService shared] oldAlias];
//
//    }
    
    return self;
}

#pragma mark - Initialization

+ (instancetype)shared
{
    static MappIntelligenceRequestBuilder *shared = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shared = [[MappIntelligenceRequestBuilder alloc] init];
    });
    
    return shared;
}

+ (instancetype)builder
{
    return [[MappIntelligenceRequestBuilder alloc] init];
}

#pragma mark - Methods

- (void)addRequestKeyedValues:(NSDictionary *)keyedValues forRequestType:(MappIntelligenceRequestKeyType)type
{
    if (keyedValues) {
        self.keyType = type;
        AppLog(@"Adding values for type: %tu", type);
        
        [self initializeRequest];
        
        [self.request addKeyedValues:keyedValues forKeyType:type];
    }
}

- (void)initializeRequest
{
    if (!self.request) {
        
        self.request = [[MappIntelligenceRequest alloc] init];
    }
}

- (NSData *)buildRequestAsJsonData
{
    NSData *data = nil;
    
    if (self.request) {
        
        NSDictionary *requestKeyedValues = [self dictionaryWithValuesForKeys:@[]];
        
        self.request = nil;
        
        NSError *error;
        
        data = [NSJSONSerialization dataWithJSONObject:requestKeyedValues options:NSJSONWritingPrettyPrinted error:&error];
        
        if (error) AppLog(@"Error while converting request keyed values to JSON object.\nerror: %@", error);
        
        AppLog(@"Request created as JSON:\n%@", [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
    }
    
    return data;
}

- (NSData *)buildRequestForPushOpenAsJsonData
{
     NSData *data = nil;
    
    [self initializeRequest];
        
        if (self.request) {
            
            NSDictionary *requestKeyedValues = [[NSDictionary alloc] init]; //[[[MappIntelligenceNotificationService shared] pushStat] dictionary];
            
            self.request = nil;
            
            NSError *error;
            
            data = [NSJSONSerialization dataWithJSONObject:requestKeyedValues options:NSJSONWritingPrettyPrinted error:&error];
            
            if (error) AppLog(@"Error while converting request keyed values to JSON object.\nerror: %@", error);
            
            AppLog(@"Request created as JSON:\n%@", [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
        }
        
        return data;
    }

- (NSDictionary *)dictionaryWithValuesForKeys:(NSArray *)keys
{
    NSMutableDictionary *keyedValues = [[NSMutableDictionary alloc] initWithDictionary:[self.request dictionaryWithValuesForKeys:@[]]];
    
    if (self.key) {
        
        if (_keyType == kMappIntelligenceRequestKeyTypeActionSet) {
            keyedValues[@"oldAlias"] = self.oldAliasValue;
        }
        keyedValues[@"key"] = self.key;
        keyedValues[@"alias"] = self.aliasValue;
    }
    
    return keyedValues;
}

@end
