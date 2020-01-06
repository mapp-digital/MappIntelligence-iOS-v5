//
//  WebtrekkRequestBuilder.m
//  Webrekk
//
//  Created by Stefan Stevanovic on 1/3/20.
//  Copyright © 2020 Stefan Stevanovic. All rights reserved.
//

#import "WebtrekkRequestBuilder.h"
#import "WebtrekkLogger.h"
#import "WebtrekkDataService.h"

@interface WebtrekkRequestBuilder ()

@property (nonatomic, strong) NSString *key;
@property (nonatomic, strong) NSString *aliasValue;
@property (nonatomic, strong) NSString *oldAliasValue;
@property (nonatomic, strong) NSString *customerID;
@property (nonatomic, strong) NSString *userID;
@property (nonatomic, strong) NSString *messageID;
@property (nonatomic, strong) NSString *sendOutID;
@property (nonatomic, strong, readwrite) WebtrekkRequest *request;
@property (nonatomic) WebtrekkRequestKeyType keyType;
@end

@implementation WebtrekkRequestBuilder

- (id)init
{
    self = [super init];
    
//    if (self) {
//
//        self.key = [WebtrekkDevice deviceUniqueGlobaldentifier];
//
//        self.aliasValue = [[WebtrekkDataService shared] alias];
//        self.oldAliasValue = [[WebtrekkDataService shared] oldAlias];
//
//    }
    
    return self;
}

#pragma mark - Initialization

+ (instancetype)shared
{
    static WebtrekkRequestBuilder *shared = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shared = [[WebtrekkRequestBuilder alloc] init];
    });
    
    return shared;
}

+ (instancetype)builder
{
    return [[WebtrekkRequestBuilder alloc] init];
}

#pragma mark - Methods

- (void)addRequestKeyedValues:(NSDictionary *)keyedValues forRequestType:(WebtrekkRequestKeyType)type
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
        
        self.request = [[WebtrekkRequest alloc] init];
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
            
            NSDictionary *requestKeyedValues = [[NSDictionary alloc] init]; //[[[WebtrekkNotificationService shared] pushStat] dictionary];
            
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
        
        if (_keyType == kWebtrekkRequestKeyTypeActionSet) {
            keyedValues[@"oldAlias"] = self.oldAliasValue;
        }
        keyedValues[@"key"] = self.key;
        keyedValues[@"alias"] = self.aliasValue;
    }
    
    return keyedValues;
}

@end
