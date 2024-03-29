//
//  APXRequestBuilder.m
//  AppoxeeSDK
//
//  Created by Raz Elkayam on 3/2/15.
//  Copyright (c) 2015 Appoxee. All rights reserved.
//
#import "APXRequestBuilder.h"
//#import "AppoxeeSDK.h"
#import "MIAPXIdentifier.h"

@interface MIRequestBuilder ()

@property (nonatomic, strong) NSString *key;
@property (nonatomic, strong) NSString *aliasValue;    /////
@property (nonatomic, strong, readwrite) MIUMRequest *request;

@end

@implementation MIRequestBuilder

- (id)init
{
    self = [super init];
    
    if (self) {
        self.key = [self deviceUniqueGlobaldentifier];
        
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

- (NSString *)deviceUniqueGlobaldentifier
{
#define defualts_key @"UDID_USER_DEFAULTS_KEY"
#define SECURE_UDID_DOMAIN @"com.appoxee.lib" // this value should not be changed.
#define SECURE_UDID_KEY @"com-appoxee-lib-key-ios-devices" // this value should not be changed.
    
    NSString *udid = nil;
    
    // Checking if SDK 3.x has stored a UDID value.
    NSString *oldUdid = [[NSUserDefaults standardUserDefaults] objectForKey:defualts_key];
    
    if (oldUdid) {
        
        udid = oldUdid;
        
    } else {
        
        udid = [MIAPXIdentifier UDIDForDomain:SECURE_UDID_DOMAIN usingKey:SECURE_UDID_KEY];
        
        [[NSUserDefaults standardUserDefaults] setObject:udid forKey:defualts_key];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    
    return udid;
}

#pragma mark - Initialization

+ (instancetype)shared
{
    static MIRequestBuilder *shared = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shared = [[MIRequestBuilder alloc] init];
    });
    
    return shared;
}

+ (instancetype)builder
{
    return [[MIRequestBuilder alloc] init];
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
        
        self.request = [[MIUMRequest alloc] init];
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
