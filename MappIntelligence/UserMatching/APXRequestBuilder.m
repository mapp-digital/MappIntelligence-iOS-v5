//
//  APXRequestBuilder.m
//  AppoxeeSDK
//
//  Created by Raz Elkayam on 3/2/15.
//  Copyright (c) 2015 Appoxee. All rights reserved.
//
#if !TARGET_OS_WATCH &&  !TARGET_OS_TV
#import "APXRequestBuilder.h"
#import "AppoxeeSDK.h"

@interface RequestBuilder ()

@property (nonatomic, strong) NSString *key;
@property (nonatomic, strong) NSString *aliasValue;    /////
@property (nonatomic, strong, readwrite) Request *request;

@end

@implementation RequestBuilder

- (id)init
{
    self = [super init];
    
    if (self) {
        
        APXClientDevice *device = [[Appoxee shared] deviceInfo];
        
        self.key = device.udid;
        
//        [[Appoxee shared] getDeviceAliasWithCompletionHandler:^(NSError * _Nullable appoxeeError, id  _Nullable data) {
//            if (!appoxeeError) {
//                if ([data isKindOfClass:[NSString class]]) {
//                    self.aliasValue = data;
//                }
//            }
//        }];
    }
    
    return self;
}

#pragma mark - Initialization

+ (instancetype)shared
{
    static RequestBuilder *shared = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shared = [[RequestBuilder alloc] init];
    });
    
    return shared;
}

+ (instancetype)builder
{
    return [[RequestBuilder alloc] init];
}

#pragma mark - Methods

- (void)addRequestKeyedValues:(NSDictionary *)keyedValues forRequestType:(RequestKeyType)type
{
    if (keyedValues) {
        
        //AppLog(@"Adding values for type: %tu", type);
        
        [self initializeRequest];
        
        [self.request addKeyedValues:keyedValues forKeyType:type];
    }
}

- (void)initializeRequest
{
    if (!self.request) {
        
        self.request = [[Request alloc] init];
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
        
//        if (error) AppLog(@"Error while converting request keyed values to JSON object.\nerror: %@", error);
//        
//        AppLog(@"Request created as JSON:\n%@", [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
    }
    
    return data;
}

- (NSDictionary *)dictionaryWithValuesForKeys:(NSArray *)keys
{
    NSMutableDictionary *keyedValues = [[NSMutableDictionary alloc] initWithDictionary:[self.request dictionaryWithValuesForKeys:@[]]];
    
    if (self.key || self.aliasValue) {
        
        keyedValues[@"key"] = self.key;
        
        keyedValues[@"alias"] = self.aliasValue;
    }

    return keyedValues;
}

@end
#endif
