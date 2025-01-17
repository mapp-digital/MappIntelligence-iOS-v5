//
//  MIUIFlowObserver.m
//  MappIntelligenceSDK
//
//  Created by Stefan Stevanovic on 3/11/20.
//  Copyright © 2020 Mapp Digital US, LLC. All rights reserved.
//

#import "MIUIFlowObserver.h"
#import "MIExceptionTracker.h"
#import "MappIntelligenceLogger.h"

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "APXRequestBuilder.h"
#import "APXNetworkManager.h"
#import "Reachability.h"

#define doesAppEnterInBackground @"enteredInBackground";

@interface MIUIFlowObserver ()

@property MIDefaultTracker *tracker;
@property MIExceptionTracker *exceptionTracker;
@property MappIntelligenceLogger *logger;
@property UIApplication *application;
@property NSUserDefaults* defaults;
@property NSObject *applicationDidBecomeActiveObserver;
@property NSObject *applicationWillEnterForegroundObserver;
@property NSObject *applicationWillResignActiveObserver;
@property NSObject *applicationWillTerminataObserver;
@property NSUserDefaults *sharedDefaults;
@property NSString* TIME_WHEN_APP_ENTERS_TO_BACKGROUND;
@property UIBackgroundTaskIdentifier backgroundIdentifier;
@property (nonatomic) Reachability *hostReachability;
@property (nonatomic) Reachability *internetReachability;

@end

@implementation MIUIFlowObserver

- (instancetype)initWith:(MIDefaultTracker *)tracker {
    self = [super init];
    _tracker = tracker;
    _logger = [MappIntelligenceLogger shared];
    [_tracker updateFirstSessionWith:[[UIApplication sharedApplication]
                                      applicationState]];
    self.TIME_WHEN_APP_ENTERS_TO_BACKGROUND = @"Background_Time";
    _sharedDefaults = [NSUserDefaults standardUserDefaults];
    
    return self;
}

- (void)showAlertView:(NSString*)message {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Title" message:message preferredStyle:UIAlertControllerStyleAlert];
    id rootViewController = [UIApplication sharedApplication].delegate.window.rootViewController;
    if([rootViewController isKindOfClass:[UINavigationController class]])
    {
        rootViewController = ((UINavigationController *)rootViewController).viewControllers.firstObject;
    }
    if([rootViewController isKindOfClass:[UITabBarController class]])
    {
        rootViewController = ((UITabBarController *)rootViewController).selectedViewController;
    }
    [rootViewController presentViewController:alertController animated:YES completion:nil];
}

- (void)getDeviceInfoForParameters:(NSArray *)parameters {
#define GET @"get"
#define DMC_USER_ID @"dmcUserId"
    MIRequestBuilder *builder = [MIRequestBuilder builder];
    [builder addRequestKeyedValues:@{GET : parameters} forRequestType:kAPXRequestKeyTypeGetCustomFields];
    NSData *serverData = [builder buildRequestAsJsonData];
    
    
    [[MINetworkManager shared] performNetworkOperation:kAPXNetworkManagerOperationTypeSetActions withData:serverData andCompletionBlock:^(NSError *error, id data) {
        
        if (!error) {
            NSDictionary *dataDictionary = (NSDictionary *)data;

            NSString *dmcUserId = dataDictionary[GET][DMC_USER_ID];
            //NSArray *dmcUserIdComponents = [dmcUserId componentsSeparatedByString:@";;;"];

            NSString *userId = nil;
            if (dmcUserId && ![dmcUserId isKindOfClass:[NSNull class]])
            userId = dmcUserId;
            
            if (userId && ![userId isKindOfClass:[NSNull class]])
                [[NSUserDefaults standardUserDefaults] setObject:userId forKey:DMC_USER_ID];
            [[NSUserDefaults standardUserDefaults] synchronize];
            

        } else {
            NSLog(@"error reported %@", error.description);
            NSLog(@"%@", [[MINetworkManager shared] sdkID]);
            NSLog(@"%@", [[MINetworkManager shared] preferedURL]);
            NSLog(@"%ld", (long)[[MINetworkManager shared] environment]);
        }
    }];
    
}

- (void)fireRequest {
    
}

- (BOOL)setup {
  NSNotificationCenter *notificationCenter =
      [NSNotificationCenter defaultCenter];
    //Posted when the app becomes active.
    _applicationDidBecomeActiveObserver = [notificationCenter addObserverForName: UIApplicationDidBecomeActiveNotification object:NULL queue:NULL usingBlock:^(NSNotification * _Nonnull note) {
        if (!([[UIApplication sharedApplication] applicationState] == UIApplicationStateActive)) {
            [self didBecomeActive];
        }
    }];
    
    //Posted when the app is no longer active and loses focus.
    _applicationWillResignActiveObserver = [notificationCenter addObserverForName:UIApplicationWillResignActiveNotification object:NULL queue:NULL usingBlock:^(NSNotification * _Nonnull note) {
        [self willResignActive];
    }];
    
    _applicationWillEnterForegroundObserver = [notificationCenter addObserverForName:UIApplicationWillEnterForegroundNotification object:NULL queue:NULL usingBlock:^(NSNotification * _Nonnull notification) {
        [self didBecomeActive];
    }];
    
    [notificationCenter addObserverForName:UIApplicationWillTerminateNotification object:NULL queue:NULL usingBlock:^(NSNotification * _Nonnull notification) {
        [self willTerminate];
    }];
    
    
    [notificationCenter addObserverForName:UIApplicationDidEnterBackgroundNotification object:NULL queue:NULL usingBlock:^(NSNotification * _Nonnull note) {
        [self willEnterBckground];
    }];

    self.internetReachability = [Reachability reachabilityForInternetConnection];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleNetworkChange:) name:kReachabilityChangedNotification object:nil];
    [self.internetReachability startNotifier];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 1 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        NetworkStatus remoteHostStatus = [self.internetReachability  currentReachabilityStatus];

        if(remoteHostStatus == NotReachable)
        {
            [[MappIntelligenceLogger shared] logObj:@"There is no Internet connection" forDescription:kMappIntelligenceLogLevelDescriptionDebug];
        }
        else if (remoteHostStatus == ReachableViaWiFi || remoteHostStatus == ReachableViaWWAN)
        {
            [[MappIntelligenceLogger shared] logObj:@"Internet connection is established" forDescription:kMappIntelligenceLogLevelDescriptionDebug];
            [self sendAllRequestFromDB];
        }
    });
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 1 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        if(self->_tracker.isItFlutter == YES) {
            [self didBecomeActive];
        }
    });

    return YES;
}

- (void) handleNetworkChange:(NSNotification *)notice
{

    NetworkStatus remoteHostStatus = [[Reachability reachabilityForInternetConnection] currentReachabilityStatus];

    if(remoteHostStatus == NotReachable) {
        [[MappIntelligenceLogger shared] logObj:@"There is no Internet connection" forDescription:kMappIntelligenceLogLevelDescriptionDebug];
    }
    else if (remoteHostStatus == ReachableViaWiFi || remoteHostStatus == ReachableViaWWAN)
    {
        [[MappIntelligenceLogger shared] logObj:@"Internet connection is established" forDescription:kMappIntelligenceLogLevelDescriptionDebug];
        [self didBecomeActive];
        [self sendAllRequestFromDB];
    }
}

- (void)sendAllRequestFromDB {
    if ([MappIntelligence shared].batchSupportEnabled == YES) {
        //TODO: add timeout to this methods
        [[MIDefaultTracker sharedInstance] sendBatchForRequestInBackground: NO withCompletionHandler:^(NSError * _Nullable error) {
            //error is already obtain at one level lower
        }];
    } else {
        [[MIDefaultTracker sharedInstance] sendRequestFromDatabaseWithCompletionHandler:^(NSError * _Nullable error) {
            //error is already obtain in one level lower
        }];
    }
}

-(void)didBecomeActive {
    [_logger logObj:@"Did become active." forDescription:kMappIntelligenceLogLevelDescriptionDebug];
    
    if([_tracker isUserMatchingEnabled]) {
        [self getDeviceInfoForParameters:@[@"dmcUserId"]];
    }
    NSSetUncaughtExceptionHandler(&onUncaughtException);
    [self getExceptionFromFileAndSendItAsAnRequest];
    if (!_tracker.isBackgroundSendoutEnabled)
        return;
    self.backgroundIdentifier = (unsigned long)[[NSUserDefaults standardUserDefaults] integerForKey:@"backgroundIdentifier"];
    if (self.backgroundIdentifier == UIBackgroundTaskInvalid) {
        [self->_tracker removeAllRequestsFromDBWithCompletionHandler:^(NSError * _Nullable error) {
            if (error) {
                NSLog(@"the requests are not deleted!!!");
            }
        }];
    }
    [[UIApplication sharedApplication] endBackgroundTask: self.backgroundIdentifier];
    self.backgroundIdentifier = UIBackgroundTaskInvalid;
    
    //remove all request if app is enough time in background to send all requests
    NSDate* dateWhenAppIsBackFromBackground =  (NSDate*) [NSUserDefaults.standardUserDefaults objectForKey:self.TIME_WHEN_APP_ENTERS_TO_BACKGROUND];
    if (dateWhenAppIsBackFromBackground) {
        NSDateComponents *components;
        NSInteger seconds;

        components = [[NSCalendar currentCalendar] components: NSCalendarUnitSecond
                fromDate: dateWhenAppIsBackFromBackground toDate: [NSDate date] options: 0];
        seconds = [components second];
        if (seconds > 30) {
            [self->_tracker removeAllRequestsFromDBWithCompletionHandler:^(NSError * _Nullable error) {
                if (error) {
                    NSLog(@"the requests are not deleted!!!");
                }
            }];
        }
    }
    [self checkFNS];
    
    
}

-(void)willEnterForeground {

//        [_tracker updateFirstSessionWith:[[UIApplication sharedApplication] applicationState]];

}

-(void)willResignActive {
    if (!([[UIApplication sharedApplication] applicationState] == UIApplicationStateActive)) {
        [_tracker initHibernate];
        [_tracker updateFirstSessionWith:[[UIApplication sharedApplication] applicationState]];
    }
}

-(void)willTerminate {
    NSNumber *number = @1;
   [[NSUserDefaults standardUserDefaults] setObject: number forKey:@"FirstOpen"];
   [[NSUserDefaults standardUserDefaults] synchronize];
    [_tracker updateFirstSessionWith:[[UIApplication sharedApplication] applicationState]];
}

-(void)willEnterBckground {
    if(_tracker.isItFlutter != YES) {
        NSNumber *number = @2;
       [[NSUserDefaults standardUserDefaults] setObject: number forKey:@"FirstOpen"];
       [[NSUserDefaults standardUserDefaults] synchronize];
    }
    [_logger logObj:@"Enter background and send all requests." forDescription:kMappIntelligenceLogLevelDescriptionDebug];
    if (!_tracker.isBackgroundSendoutEnabled)
        return;
    [NSUserDefaults.standardUserDefaults setValue:[NSDate date] forKey:self.TIME_WHEN_APP_ENTERS_TO_BACKGROUND];
    [[NSUserDefaults standardUserDefaults] synchronize];
    self.backgroundIdentifier = [[UIApplication sharedApplication] beginBackgroundTaskWithName:@"com.mapp.background" expirationHandler:^{
        [self->_tracker sendBatchForRequestInBackground: YES withCompletionHandler:^(NSError * _Nullable error) {
            if (error) {
                [self->_logger logObj:@"The requests in background are not sent!!!." forDescription:kMappIntelligenceLogLevelDescriptionDebug];
            }
            
            [[UIApplication sharedApplication] endBackgroundTask:self.backgroundIdentifier];
            self.backgroundIdentifier = UIBackgroundTaskInvalid;
            [[NSUserDefaults standardUserDefaults] setInteger:self.backgroundIdentifier forKey:@"backgroundIdentifier"];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }];
        [[UIApplication sharedApplication] endBackgroundTask:self.backgroundIdentifier];
        self.backgroundIdentifier = UIBackgroundTaskInvalid;
        [[NSUserDefaults standardUserDefaults] setInteger:self.backgroundIdentifier forKey:@"backgroundIdentifier"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }];
    [[NSUserDefaults standardUserDefaults] setInteger:self.backgroundIdentifier forKey:@"backgroundIdentifier"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

#pragma mark - Helper methods

void onUncaughtException(NSException* exception)
{
//save exception details
    NSString* exceptionText = [NSString stringWithFormat:@"%@,%@,%@,%@,%@", exception.name, exception.reason, exception.userInfo, exception.callStackReturnAddresses, exception.callStackSymbols];
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *filePath = [documentsDirectory stringByAppendingPathComponent:@"file.txt"];
    [exceptionText writeToFile:filePath atomically:TRUE encoding:NSUTF8StringEncoding error:NULL];
    NSLog(@"The exception is saved fully!");
}

-(void) getExceptionFromFileAndSendItAsAnRequest {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *filePath = [documentsDirectory stringByAppendingPathComponent:@"file.txt"];
    NSString* exceptionString = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:NULL];
    if (exceptionString) {
        //send the exception like an request
        NSArray* exceptionElements = [exceptionString componentsSeparatedByString:@","];
        if ([exceptionElements count] == 5)
            [[MIExceptionTracker sharedInstance] trackExceptionWithName:exceptionElements[0] andReason:exceptionElements[1] andUserInfo:exceptionElements[2] andCallStackReturnAddress:exceptionElements[3] andCallStackSymbols:exceptionElements[4]];
        //remove the file
        if ([self removeTextFileWhereExceptionIsSaved]) {
            [_logger logObj:@"The uncaught request is successfully sent to server." forDescription:kMappIntelligenceLogLevelDescriptionDebug];
        }
    }
}

-(BOOL)removeTextFileWhereExceptionIsSaved {
    // get reference with path and filename
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *filePath = [documentsDirectory stringByAppendingPathComponent:@"file.txt"];
    // now delete the file
    return [[NSFileManager defaultManager]removeItemAtPath:filePath error:nil];
}

-(void)checkFNS {
    NSNumber *savedNo = [[NSUserDefaults standardUserDefaults] objectForKey:@"FirstOpen"];
    ;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 1 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        NSLog(@"Is this flutter: %@", self->_tracker.isItFlutter != YES ? @"NO" : @"YES");
    });
    
    if (savedNo != NULL) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 1 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
            NSLog(@"Is this flutter: %@", self->_tracker.isItFlutter != YES ? @"NO" : @"YES");
            if (self->_tracker.isItFlutter == YES && [savedNo  isEqual: @1]) {
                
                [self->_tracker updateFirstSessionWith:UIApplicationStateInactive];
                NSNumber *number = @2;
                [[NSUserDefaults standardUserDefaults] setObject: number forKey:@"FirstOpen"];
                [[NSUserDefaults standardUserDefaults] synchronize];
            }
        });
        if ([savedNo  isEqual: @1]) {
//            [_tracker updateFirstSessionWith:[[UIApplication sharedApplication] applicationState]];
            //UIApplicationStateInactive
            [_tracker updateFirstSessionWith:UIApplicationStateInactive];
        }
    }
}

@end

