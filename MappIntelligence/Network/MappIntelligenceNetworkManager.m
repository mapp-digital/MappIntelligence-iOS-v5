//
//  MappIntelligenceNetworkManager.m
//  Webrekk
//
//  Created by Stefan Stevanovic on 1/3/20.
//  Copyright © 2020 Stefan Stevanovic. All rights reserved.
//

#import "MappIntelligenceNetworkManager.h"
#import "MappIntelligenceNetworkMetadata.h"
#import "MappIntelligenceLogger.h"

@interface MappIntelligenceNetworkManager ()

@property (nonatomic, strong) NSMutableDictionary *retryOperations;

@end

@implementation MappIntelligenceNetworkManager

#pragma mark - Initialization

+ (instancetype)shared
{
    static MappIntelligenceNetworkManager *shared = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shared = [[MappIntelligenceNetworkManager alloc] init];
    });
    
    return shared;
}

- (void)performNetworkOperation:(MappIntelligenceNetworkManagerOperationType)operation withData:(NSData *)dataArg andCompletionBlock:(MappIntelligenceNetworkManagerCompletionBlock)completionBlock
{
    if (dataArg) {
        
        NSMutableURLRequest *request = [self generateRequestForOperation:operation];
        
        [request setHTTPBody:dataArg];
        
        NSURLSession *session = [NSURLSession sharedSession];
        //NSLog(@"\nall headers from response:\n%@\n", [request allHeaderFields]);
        //NSLog(@"\nstatus code from response:%ld\n", (long)[request statusCode]);
        NSLog(@"%@",[[NSString alloc] initWithData:[request HTTPBody] encoding:NSASCIIStringEncoding]);
        
        NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
            
            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                
                
                // For quick debugging.
                NSString *strData = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
                NSLog(@"%@",strData);

                if ([response isKindOfClass:[NSHTTPURLResponse class]]) {

                    NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
                    
                    NSLog(@"\nall headers from response:\n%@\n", [httpResponse allHeaderFields]);
                    NSLog(@"\nstatus code from response:%ld\n", (long)[httpResponse statusCode]);
                    NSLog(@"%@",[[NSString alloc] initWithData:[request HTTPBody] encoding:NSASCIIStringEncoding]);

                }
                
                
                if (!error) {
                    
                    [self removeRetryOfOperation:operation];
                    
                    NSError *jsonError = nil;
                    id serverData = nil;
                    
                    if (data) {
                     
                        serverData = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&jsonError];
                        AppLog(@"Server Operation: %tu JSON respose: %@",operation, serverData);
                        //NSLog(@"Server Operation: %tu JSON respose: %@",operation, serverData);
                    }
                    
                    if (!jsonError) {
                        
                        NSError *requestError = nil;
                        NSDictionary *serverDictionary = (NSDictionary *)serverData;
                        MappIntelligenceNetworkMetadata *metadata= [[MappIntelligenceNetworkMetadata alloc] initWithKeyedValues:serverDictionary[@"metadata"]];
                        
                        if (!metadata.isSuccess) {
                            
                            requestError = [MappIntelligenceLogger errorWithType:kMappIntelligenceErrorTypeNetwork];
                            
                            AppLog(@"Network protocol error.\n Code: %tu\nMessage: %@", metadata.code, metadata.message);
                            [[MappIntelligenceLogger shared] logObj:[NSString stringWithFormat:@"Network protocol error with HTTP code: %tu", metadata.code] forDescription:kMappIntelligenceLogLevelDescriptionError];
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
        
        NSError *error = [MappIntelligenceLogger errorWithType:kMappIntelligenceErrorTypeNetwork];
        
        if (completionBlock) completionBlock(error, nil);
    }
}


- (NSDictionary *)performSynchronousNetworkOperation:(MappIntelligenceNetworkManagerOperationType)operation withData:(NSData *)data
{
    NSDictionary *responseDictionary = nil;
    
    if (data) {
        
        NSMutableURLRequest *request = [self generateRequestForOperation:operation];
        
        [request setHTTPBody:data];
        
        NSURLResponse *response = nil;
        NSError *error = nil;
        
        NSData *serverDataResponse = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];

        
        // For quick debugging.
         
        if ([response isKindOfClass:[NSHTTPURLResponse class]]) {

            NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;

            NSLog(@"\nSynchronous - all headers from response:\n%@\n", [httpResponse allHeaderFields]);
            NSLog(@"\nSynchronous - status code from response:%ld\n", (long)[httpResponse statusCode]);
            NSLog(@"%@",[[NSString alloc] initWithData:[request HTTPBody] encoding:NSASCIIStringEncoding]);
        }
        
        
        if (!error) {
            
            NSError *jsonError = nil;
            id serverData = [NSJSONSerialization JSONObjectWithData:serverDataResponse options:NSJSONReadingMutableContainers error:&jsonError];
            AppLog(@"Synchronous - Server Operation: %tu JSON respose: %@",operation, serverData);
            
            if (!jsonError) {
                
                NSDictionary *serverDictionary = (NSDictionary *)serverData;
                
                MappIntelligenceNetworkMetadata *metadata = [[MappIntelligenceNetworkMetadata alloc] initWithKeyedValues:serverDictionary[@"metadata"]];
                
                responseDictionary = serverDictionary[@"payload"];
                
                if (!metadata.isSuccess) {
                    
                    AppLog(@"Synchronous - Network protocol error.\n Code: %tu\nMessage: %@", metadata.code, metadata.message);
                    [[MappIntelligenceLogger shared] logObj:[NSString stringWithFormat:@"Network protocol error with HTTP code: %tu", metadata.code] forDescription:kMappIntelligenceLogLevelDescriptionError];
                    
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

- (NSMutableURLRequest *)generateRequestForOperation:(MappIntelligenceNetworkManagerOperationType)operation
{
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    
    NSString *url = @"";
    
    NSString *baseURL = nil;
    
    if (self.preferedURL) {
        
        baseURL = self.preferedURL;
        
    } else if (operation == kMappIntelligenceNetworkManagerOperationTypeReportPushClicked) {
        baseURL = @"https://charon-test.shortest-route.com/";
    } else {
        
        baseURL = [self baseURLStringPerEnvoirnment];
    }
    
    
    
//    if (operation == kMappIntelligenceNetworkManagerOperationTypeGeoGetRegions) {
//        baseURL = @"http://192.168.100.227:8887/rest/apps/1/1/geofences";
//        url = @"http://192.168.100.227:8887/rest/apps/1/1/geofences";
//    } else {
    
        NSString *endpoint = [self endPointByNetworkOperation:operation];
    
        url = [NSString stringWithFormat:@"%@%@", baseURL, endpoint];
    
        AppLog(@"URL for network operation: %@", url);
    //}
    
    [request setURL:[NSURL URLWithString:url]];
    
    [request setHTTPMethod:[self httpMethodForOperation:operation]];
    
    [request addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    [request addValue:self.sdkID forHTTPHeaderField:@"X_KEY"];
    
    return request;
}

- (NSURLRequest *)contentRequestForOperation:(MappIntelligenceNetworkManagerOperationType)operation withAppID:(NSString *)appID andUDID:(NSString *)udid
{
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setHTTPMethod:@"POST"];
    
    NSString *url = @"";
    
    NSString *baseURL = [self baseURLStringPerEnvoirnment];
    
    NSString *endpoint = @"";
    
    if (operation == kMappIntelligenceNetworkManagerOperationTypeFeedback) {
        
        endpoint = @"AppBoxWebClient/feedback/feedback.aspx";
        
        NSString *parameters = [NSString stringWithFormat:@"appID=%@&key=%@", appID, udid];
        
        [request setHTTPBody:[parameters dataUsingEncoding:NSUTF8StringEncoding]];
        
    } else if (operation == kMappIntelligenceNetworkManagerOperationTypeMoreApps) {
        
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
            
        case kMappIntelligenceNetworkManagerEnvironmentVirginia:
        {
            //url = @"https://saas.appoxee.com/";
            url = [self getServerAddress];
        }
            break;
        case kMappIntelligenceNetworkManagerEnvironmentQALatest:
        {
            url = @"http://latest.dev.appoxee.com/";
        }
            break;
        case kMappIntelligenceNetworkManagerEnvironmentQAStable:
        {
            url = @"http://stable.dev.appoxee.com/";
        }
            break;
        case kMappIntelligenceNetworkManagerEnvironmentQA2:
        {
            url = @"http://qa2.appoxee.com/";
        }
            break;
        case kMappIntelligenceNetworkManagerEnvironmentQA3:
        {
            url = @"http://qa3.appoxee.com/";
        }
            break;
        case kMappIntelligenceNetworkManagerEnvironmentFrankfurt:
        {
            //url = @"https://api.eu.appoxee.com/";
            //url = @"http://eu.dev.appoxee.com/";
            //url = @"https://charon-test.shortest-route.com/";
            url = [self getServerAddress];
            //url = @"http://192.168.43.107:8081/";
        }
            break;
        case kMappIntelligenceNetworkManagerEnvironmentQAFrankfurt:
        {
//            url = @"http://eu.dev.appoxee.com/";
            url = @"https://charon-test.shortest-route.com/";
        }
            break;
        case kMappIntelligenceNetworkManagerEnvironmentQAStaging:
        {
            url = @"http://staging.dev.appoxee.com/";
        }
            break;
        case kMappIntelligenceNetworkManagerEnvironmentQAIntegration:
        {
            url = @"http://qa.dev.appoxee.com/";
        }
            break;
    }
    
    return url;
}

- (NSString *)endPointByNetworkOperation:(MappIntelligenceNetworkManagerOperationType)operation
{
    NSString *endpoint = @"api/v3/device/";
//    if (operation == kMappIntelligenceNetworkManagerOperationTypeReportPushClicked) {
//        endpoint = @"api/push/event";
//    }
    return endpoint;
}

- (NSString *)getServerAddress
{
    NSString *serverAdress = @"https://charon-test.shortest-route.com/";
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
//        case TEST:
//            serverAdress = @"https://charon-test.shortest-route.com/";
//        default:
//            break;
//    }
    return serverAdress;
}

- (NSString *)httpMethodForOperation:(MappIntelligenceNetworkManagerOperationType)operation
{
    NSString *httpMethod = @"PUT";
    
    if (operation == kMappIntelligenceNetworkManagerOperationTypeReportPushClicked) {
        httpMethod = @"POST";
    }
    
    AppLog(@"HTTP method: %@", httpMethod);
    
    return httpMethod;
}

#pragma mark - Retry

- (BOOL)retryOperation:(MappIntelligenceNetworkManagerOperationType)operation withData:(NSData *)data andCompletionBlock:(MappIntelligenceNetworkManagerCompletionBlock)block
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

- (void)removeRetryOfOperation:(MappIntelligenceNetworkManagerOperationType)operation
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
