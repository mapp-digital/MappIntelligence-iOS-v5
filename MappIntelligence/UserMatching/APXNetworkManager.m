//
//  APXNetworkManager.m
//  AppoxeeSDK
//
//  Created by Raz Elkayam on 3/2/15.
//  Copyright (c) 2015 Appoxee. All rights reserved.
//
#if !TARGET_OS_WATCH || !TARGET_OS_TV
#import "APXNetworkManager.h"
#import "APXNetworkMetadata.h"
#import "APXInappLogger.h"
#import "AppoxeeSDK.xcframework/ios-arm64_armv7/Headers/AppoxeeSDK.h"


#define KEY_CONFIG_APPOXEE_SDK @"sdk"
#define KEY_CONFIG_APPOXEE_JAMIE_URL @"jamie_url"
#define KEY_CONFIG_APPOXEE_APPLICATION_SDK_KEY @"sdk_key"

@interface NetworkManager ()

@property (nonatomic, strong) NSMutableDictionary *retryOperations;

@end

@implementation NetworkManager

#pragma mark - Initialization

+ (instancetype)shared
{
    static NetworkManager *shared = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shared = [[NetworkManager alloc] init];
    });
    
    return shared;
}

- (void)performNetworkOperation:(NetworkManagerOperationType)operation withData:(NSData *)dataArg andCompletionBlock:(APXNetworkManagerCompletionBlock)completionBlock
{
    if (dataArg) {
        
        NSMutableURLRequest *request = [self generateRequestForOperation:operation];
        
        [request setHTTPBody:dataArg];
        
        NSLog(@"Method: %@", [request HTTPMethod]);
        NSLog(@"URL: %@", [[request URL] description] );
        NSLog(@"Headers: %@", [request allHTTPHeaderFields]);
        NSLog(@"Body: %@", [[NSString alloc] initWithData:[request HTTPBody] encoding:NSUTF8StringEncoding]);
        
        NSURLSession *session = [NSURLSession sharedSession];
        
        NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
            
            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                
                
                 
                // For quick debugging.
                
                
                if ([response isKindOfClass:[NSHTTPURLResponse class]]) {
                    
                    NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
                    
                    NSLog(@"\nall headers from response:\n%@\n", [httpResponse allHeaderFields]);
                    NSLog(@"\nresponse from response:\n%@\n\n%@\n", data, [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
                    NSLog(@"\nstatus code from response:%ld\n", (long)[httpResponse statusCode]);
                }
                
                
                if (!error) {
                    
                    [self removeRetryOfOperation:operation];
                    
                    NSError *jsonError = nil;
                    id serverData = nil;
                    
                    if (data) {
                     
                        serverData = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&jsonError];
                        AppLog(@"Server Operation: %tu JSON respose: %@",operation, serverData);
                    }
                    
                    if (!jsonError) {
                        
                        NSError *requestError = nil;
                        NSDictionary *serverDictionary = (NSDictionary *)serverData;
                        
                        NetworkMetadata *metadata = [[NetworkMetadata alloc] initWithKeyedValues:serverDictionary[@"metadata"]];
                        
                        if (!metadata.isSuccess) {
                            
                            requestError = [APXInappLogger errorWithType:kAPXErrorTypeNetwork];
                            
                            AppLog(@"Network protocol error.\n Code: %tu\nMessage: %@", metadata.code, metadata.message);
                            [[APXInappLogger shared] logObj:[NSString stringWithFormat:@"Network protocol error with HTTP code: %tu", metadata.code] forDescription:kAPXLogLevelDescriptionError];
                        }
                        
                        if (completionBlock) {
                            
                            completionBlock(requestError, serverDictionary[@"payload"]);
                        }
                        
                    } else {
                        
                        AppLog(@"Received Error while parsing JSON:\n%@", jsonError);
                        if (completionBlock) completionBlock(jsonError, nil);
                    }
                    
                } else {
                    
                    AppLog(@"Network Communication Error: %@", error);
                    
                    BOOL willRetry = [self retryOperation:operation withData:dataArg andCompletionBlock:completionBlock];
                    
                    if (!willRetry) {
                     
                        if (completionBlock) completionBlock(error, nil);
                    }
                }            
            }];
        }];
        
        [dataTask resume];

    } else {
        
        AppLog(@"No data was supplied, aborting network operation: %tu", operation);
        
        NSError *error = [APXInappLogger errorWithType:kAPXErrorTypeNetwork];
        
        if (completionBlock) completionBlock(error, nil);
    }
}

- (NSDictionary *)performSynchronousNetworkOperation:(NetworkManagerOperationType)operation withData:(NSData *)data
{
    NSDictionary *responseDictionary = nil;
    
    if (data) {
        
        NSMutableURLRequest *request = [self generateRequestForOperation:operation];
        
        [request setHTTPBody:data];
        
        NSURLResponse *response = nil;
        NSError *error = nil;
        
        NSData *serverDataResponse = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
        
        // For quick debugging.
         
//        if ([response isKindOfClass:[NSHTTPURLResponse class]]) {
//            
//            NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
//            
//            AppLog(@"\nSynchronous - all headers from response:\n%@\n", [httpResponse allHeaderFields]);
//            AppLog(@"\nSynchronous - status code from response:%ld\n", (long)[httpResponse statusCode]);
//        }
        
        
        if (!error) {
            
            NSError *jsonError = nil;
            id serverData = [NSJSONSerialization JSONObjectWithData:serverDataResponse options:NSJSONReadingMutableContainers error:&jsonError];
            AppLog(@"Synchronous - Server Operation: %tu JSON respose: %@",operation, serverData);
            
            if (!jsonError) {
                
                NSDictionary *serverDictionary = (NSDictionary *)serverData;
                
                NetworkMetadata *metadata = [[NetworkMetadata alloc] initWithKeyedValues:serverDictionary[@"metadata"]];
                
                responseDictionary = serverDictionary[@"payload"];
                
                if (!metadata.isSuccess) {
                    
                    AppLog(@"Synchronous - Network protocol error.\n Code: %tu\nMessage: %@", metadata.code, metadata.message);
                    [[APXInappLogger shared] logObj:[NSString stringWithFormat:@"Network protocol error with HTTP code: %tu", metadata.code] forDescription:kAPXLogLevelDescriptionError];
                    
                    responseDictionary = nil;
                }
            
            } else {
                
                AppLog(@"Synchronous - Received Error while parsing JSON:\n%@", jsonError);
            }
            
        } else {
            
            AppLog(@"Synchronous - Network Communication Error: %@", error);
        }
        
    } else {
        
        AppLog(@"No data was supplied, aborting network operation: %tu", operation);
    }

    return responseDictionary;
}

#pragma mark - Request

- (NSMutableURLRequest *)generateRequestForOperation:(NetworkManagerOperationType)operation
{
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    
    NSString *url = @"";
    
    NSString *baseURL = nil;
    
    if (self.preferedURL) {
        
        baseURL = self.preferedURL;
        
    } else {
     
        baseURL = [self baseURLStringPerEnvoirnment];
    }
    
    NSString *endpoint = [self endPointByNetworkOperation:operation];
    
    url = [NSString stringWithFormat:@"%@%@", baseURL, endpoint];
    
    AppLog(@"URL for network operation: %@", url);
    
    [request setURL:[NSURL URLWithString:url]];
    
    [request setHTTPMethod:[self httpMethodForOperation:operation]];
    
    [request addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    //read from plist
    NSDictionary *appoxeeConfiguration = [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"AppoxeeConfig" ofType:@"plist"]];
    id obj = appoxeeConfiguration[KEY_CONFIG_APPOXEE_SDK][KEY_CONFIG_APPOXEE_APPLICATION_SDK_KEY];
    
    NSString *sdkKey = nil;
    
    if ([obj isKindOfClass:[NSString class]]) {
        
        [APXInappLogger logObj: @"Loading application sdk key."];
        
        sdkKey = (NSString *)obj;
        
        [APXInappLogger logObj: [NSString stringWithFormat:@"Application sdk key: %@", sdkKey]];
        
        [[NetworkManager shared] setSdkID:sdkKey];
        
    }
    
    [request addValue:self.sdkID forHTTPHeaderField:@"X_KEY"];
    
    return request;
}

- (NSURLRequest *)contentRequestForOperation:(NetworkManagerOperationType)operation withAppID:(NSString *)appID andUDID:(NSString *)udid
{
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setHTTPMethod:@"POST"];
    
    NSString *url = @"";
    
    NSString *baseURL = [self baseURLStringPerEnvoirnment];
    
    NSString *endpoint = @"";
    
    if (operation == kAPXNetworkManagerOperationTypeFeedback) {
        
        endpoint = @"AppBoxWebClient/feedback/feedback.aspx";
        
        NSString *parameters = [NSString stringWithFormat:@"appID=%@&key=%@", appID, udid];
        
        [request setHTTPBody:[parameters dataUsingEncoding:NSUTF8StringEncoding]];
        
    } else if (operation == kAPXNetworkManagerOperationTypeMoreApps) {
        
        endpoint = [NSString stringWithFormat:@"MoreApps/%@", appID];
    }
    
    url = [NSString stringWithFormat:@"%@%@", baseURL, endpoint];
    
    [request setURL:[NSURL URLWithString:url]];
    
    return request;
}

- (NSString *)baseURLStringPerEnvoirnment
{
    NSString *url = nil;
    
    switch (self.environment) {
            
        case kAPXNetworkManagerEnvironmentVirginia:
        {
            //url = @"https://saas.appoxee.com/";
            url = [self getServerAddress];
        }
            break;
        case kAPXNetworkManagerEnvironmentQALatest:
        {
            url = @"http://latest.dev.appoxee.com/";
        }
            break;
        case kAPXNetworkManagerEnvironmentQAStable:
        {
            url = @"http://stable.dev.appoxee.com/";
        }
            break;
        case kAPXNetworkManagerEnvironmentQA2:
        {
            url = @"http://qa2.appoxee.com/";
        }
            break;
        case kAPXNetworkManagerEnvironmentQA3:
        {
            url = @"http://qa3.appoxee.com/";
        }
            break;
        case kAPXNetworkManagerEnvironmentFrankfurt:
        {
            //url = @"https://api.eu.appoxee.com/";
            url = [self getServerAddress];
            //url = @"http://eu.dev.appoxee.com/";
        }
            break;
        case kAPXNetworkManagerEnvironmentQAFrankfurt:
        {
            url = @"http://eu.dev.appoxee.com/";
        }
            break;
        case kAPXNetworkManagerEnvironmentQAStaging:
        {
            url = @"http://staging.dev.appoxee.com/";
        }
            break;
        case kAPXNetworkManagerEnvironmentQAIntegration:
        {
            url = @"http://qa.dev.appoxee.com/";
        }
        case kAPXNetworkManagerCustomURLNishant:
        {
            url = @"http://10.6.14.87:8081/";
        }
        case kAPXNetworkManagerEnvironmentFrankfurtSanity:
        {
            url = @"https://sanity.eu.appoxee.com/";
        }
            break;
    }
    
    return url;
}

- (NSString *)getServerAddress
{
    NSString *serverAdress = @"https://charon-test.shortest-route.com/";
    
    NSDictionary *appoxeeConfiguration = [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"AppoxeeConfig" ofType:@"plist"]];
    id obj = appoxeeConfiguration[KEY_CONFIG_APPOXEE_SDK][KEY_CONFIG_APPOXEE_JAMIE_URL];
    
    NSString *jamieURL = nil;
    
    if ([obj isKindOfClass:[NSString class]]) {
        
        [APXInappLogger logObj: @"Loading application sdk key."];
        
        jamieURL = (NSString *)obj;
        
        [APXInappLogger logObj: [NSString stringWithFormat:@"Application sdk key: %@", jamieURL]];
        
        serverAdress = [@"https://" stringByAppendingString: [jamieURL stringByAppendingString: @"/charon/"] ];
        
    }
    
    
//    switch ([[Appoxee shared] server]) {
//        case L3:
//            serverAdress = @"https://jamie.g.shortest-route.com/charon/";
//            break;
//        case EMC:
//            serverAdress = @"https://jamie.h.shortest-route.com/charon/";
//            break;
//        case EMC_US:
//            serverAdress = @"https://jamie.c.shortest-route.com/charon/";
//            break;
//        case CROC:
//            serverAdress = @"https://jamie.m.shortest-route.com/charon/";
//            break;
//        case TEST:
//            serverAdress = @"https://charon-test.shortest-route.com/";
//            break;
//        case TEST55:
//            serverAdress = @"https://charon-qa.shortest-route.com/";
//            break;
//        default:
//            break;
//    }
    return serverAdress;
}

- (NSString *)endPointByNetworkOperation:(NetworkManagerOperationType)operation
{
    NSString *endpoint = @"api/v3/device/";
    
    return endpoint;
}

- (NSString *)httpMethodForOperation:(NetworkManagerOperationType)operation
{
    NSString *httpMethod = @"PUT";
    
    AppLog(@"HTTP method: %@", httpMethod);
    
    return httpMethod;
}

#pragma mark - Retry

- (BOOL)retryOperation:(NetworkManagerOperationType)operation withData:(NSData *)data andCompletionBlock:(APXNetworkManagerCompletionBlock)block
{
    BOOL retrying = YES;
    
    NSString *retryKey = [NSString stringWithFormat:@"retryKey_%tu", operation];
    NSNumber *retryCount = self.retryOperations[retryKey];
    
    if (retryCount) {
        
        retryCount = @(([retryCount integerValue] + 1));        
        self.retryOperations[retryKey] = retryCount;
        
    } else {
        
        retryCount = @(1);
        self.retryOperations[retryKey] = retryCount;
    }
    
    if ([retryCount integerValue] <= 3) {
        
        AppLog(@"Retrying network operation: %tu. Retry count: %tu", operation, [retryCount integerValue]);
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(([retryCount integerValue] * [retryCount integerValue]) * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            [self performNetworkOperation:operation withData:data andCompletionBlock:block];
        });
        
    } else {
        
        AppLog(@"Aborting retry, retry count exceeds allowed retry amount.");
        
        [self.retryOperations removeObjectForKey:retryKey];
        
        retrying = NO;
    }
    
    return retrying;
}

- (void)removeRetryOfOperation:(NetworkManagerOperationType)operation
{
    NSString *retryKey = [NSString stringWithFormat:@"%tu", operation];
    [self.retryOperations removeObjectForKey:retryKey];
}

#pragma mark - Lazy Instantiation

- (NSMutableDictionary *)retryOperations
{
    if (!_retryOperations) _retryOperations = [[NSMutableDictionary alloc] init];
    return _retryOperations;
}

@end
#endif
