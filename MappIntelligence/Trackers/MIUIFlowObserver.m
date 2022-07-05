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
#import "APXRequestBuilder.h"
#import "APXNetworkManager.h"
#if TARGET_OS_WATCH
#import <WatchKit/WatchKit.h>
#else
#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#endif

#define doesAppEnterInBackground @"enteredInBackground";

@interface MIUIFlowObserver ()

@property MIDefaultTracker *tracker;
@property MIExceptionTracker *exceptionTracker;
@property MappIntelligenceLogger *logger;
#if !TARGET_OS_WATCH
@property UIApplication *application;
#endif
@property NSObject *applicationDidBecomeActiveObserver;
@property NSObject *applicationWillEnterForegroundObserver;
@property NSObject *applicationWillResignActiveObserver;
@property NSObject *applicationWillTerminataObserver;
@property NSUserDefaults *sharedDefaults;
@property NSString* TIME_WHEN_APP_ENTERS_TO_BACKGROUND;
#if !TARGET_OS_WATCH
@property UIBackgroundTaskIdentifier backgroundIdentifier;
#endif

@end

@implementation MIUIFlowObserver

- (instancetype)initWith:(MIDefaultTracker *)tracker {
    self = [super init];
    _tracker = tracker;
    _logger = [MappIntelligenceLogger shared];
    //to force new session only for TV, bacause notficataion for willenterforeground do not work on TVOS
#if TARGET_OS_TV
    [_tracker updateFirstSessionWith:[[UIApplication sharedApplication]
                                      applicationState]];
#endif
    self.TIME_WHEN_APP_ENTERS_TO_BACKGROUND = @"Background_Time";
    _sharedDefaults = [NSUserDefaults standardUserDefaults];
    
    return self;
}

- (void)getDeviceInfoForParameters:(NSArray *)parameters {
#define GET @"get"
#define DMC_USER_ID @"dmcUserId"

    RequestBuilder *builder = [RequestBuilder builder];
    [builder addRequestKeyedValues:@{GET : parameters} forRequestType:kAPXRequestKeyTypeGetCustomFields];
    NSData *serverData = [builder buildRequestAsJsonData];
    
    
    [[NetworkManager shared] performNetworkOperation:kAPXNetworkManagerOperationTypeSetActions withData:serverData andCompletionBlock:^(NSError *error, id data) {
        
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

            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[[NSUserDefaults standardUserDefaults] objectForKey:DMC_USER_ID] message:@"DMC_USER_ID" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
            

        } else {
            NSLog(@"error reported %@", error.description);
            NSLog(@"%@", [[NetworkManager shared] sdkID]);
            NSLog(@"%@", [[NetworkManager shared] preferedURL]);
            NSLog(@"%ld", (long)[[NetworkManager shared] environment]);
        }
    }];
}

- (void)fireRequest {
    
}

- (BOOL)setup {
  NSNotificationCenter *notificationCenter =
      [NSNotificationCenter defaultCenter];
#if !TARGET_OS_WATCH
    //Posted when the app becomes active.
    _applicationDidBecomeActiveObserver = [notificationCenter addObserverForName: UIApplicationDidBecomeActiveNotification object:NULL queue:NULL usingBlock:^(NSNotification * _Nonnull note) {
        [self didBecomeActive];
    }];
    //Posted shortly before an app leaves the background state on its way to becoming the active app.
    _applicationWillEnterForegroundObserver = [notificationCenter addObserverForName:UIApplicationWillEnterForegroundNotification object:NULL queue:NULL usingBlock:^(NSNotification * _Nonnull note) {
        [self willEnterForeground];
    }];
    //Posted when the app is no longer active and loses focus.
    _applicationWillResignActiveObserver = [notificationCenter addObserverForName:UIApplicationWillResignActiveNotification object:NULL queue:NULL usingBlock:^(NSNotification * _Nonnull note) {
        [self willResignActive];
    }];
    //terminate, not called always
    [notificationCenter addObserverForName:UIApplicationWillTerminateNotification object:NULL queue:NULL usingBlock:^(NSNotification * _Nonnull note) {
        //[self willResignActive];
    }];
    
    [notificationCenter addObserverForName:UIApplicationDidEnterBackgroundNotification object:NULL queue:NULL usingBlock:^(NSNotification * _Nonnull note) {
        [self willEnterBckground];
    }];
#else
    _applicationWillEnterForegroundObserver = [notificationCenter addObserverForName:@"UIApplicationWillEnterForegroundNotification" object:NULL queue:NULL usingBlock:^(NSNotification * _Nonnull note) {
        
        [self willEnterForeground];
    }];
    _applicationDidBecomeActiveObserver = [notificationCenter addObserverForName: @"UIApplicationDidBecomeActiveNotification" object:NULL queue:NULL usingBlock:^(NSNotification * _Nonnull note) {
        [self didBecomeActive];
    }];
    _applicationWillTerminataObserver = [notificationCenter addObserverForName:@"UIApplicationWillTerminateNotification" object:NULL queue:NULL usingBlock:^(NSNotification * _Nonnull note) {
        [self willTerminate];
    }];
    _applicationWillResignActiveObserver = [notificationCenter addObserverForName:@"UIApplicationWillResignActiveNotification" object:NULL queue:NULL usingBlock:^(NSNotification * _Nonnull note) {
        [self willResignActive];
    }];
#endif
  return YES;
}

-(void)didBecomeActive {
    
}

-(void)willEnterForeground {
    [self getDeviceInfoForParameters:@[@"dmcUserId"]];
    NSSetUncaughtExceptionHandler(&onUncaughtException);
    [self getExceptionFromFileAndSendItAsAnRequest];
#if !TARGET_OS_WATCH
  [_tracker updateFirstSessionWith:[[UIApplication sharedApplication]
                                       applicationState]];
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
    
#else
  [_tracker updateFirstSessionWith:WKApplicationStateActive];
#endif
}

-(void)willResignActive {
#if TARGET_OS_WATCH
    [_sharedDefaults setBool:YES forKey:@"enteredInBackground"];
    [_sharedDefaults synchronize];
#endif
	  [_tracker initHibernate];
}

-(void)willTerminate {
    
}

-(void)willEnterBckground {
    [_logger logObj:@"Enter background and send all requests." forDescription:kMappIntelligenceLogLevelDescriptionDebug];
    if (!_tracker.isBackgroundSendoutEnabled)
        return;
    [NSUserDefaults.standardUserDefaults setValue:[NSDate date] forKey:self.TIME_WHEN_APP_ENTERS_TO_BACKGROUND];
    [[NSUserDefaults standardUserDefaults] synchronize];
#if !TARGET_OS_WATCH
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
#endif
}

#pragma mark - Helper methods

void onUncaughtException(NSException* exception)
{
//save exception details
#if !TARGET_OS_WATCH
    NSString* exceptionText = [NSString stringWithFormat:@"%@,%@,%@,%@,%@", exception.name, exception.reason, exception.userInfo, exception.callStackReturnAddresses, exception.callStackSymbols];
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *filePath = [documentsDirectory stringByAppendingPathComponent:@"file.txt"];
    [exceptionText writeToFile:filePath atomically:TRUE encoding:NSUTF8StringEncoding error:NULL];
    NSLog(@"The exception is saved fully!");
#endif
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

@end

