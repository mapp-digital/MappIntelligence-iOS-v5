//
//  MIExceptionTracker.m
//  MappIntelligenceSDK
//
//  Created by Stefan Stevanovic on 27/08/2021.
//  Copyright © 2021 Mapp Digital US, LLC. All rights reserved.
//

#import "MIExceptionTracker.h"
#import "MappIntelligenceLogger.h"
#import "MIActionEvent.h"
#import "MIDefaultTracker.h"

typedef void SignalHanlder(NSException *exception);

@interface MIExceptionTracker ()
@property SignalHanlder* previousSignalHandlers;
@property (nonatomic, strong) MIDefaultTracker* tracker;
#if !TARGET_OS_WATCH
@property NSArray<id>* signals;
#endif
@property (nonatomic, strong) MappIntelligenceLogger* logger;
@end

@implementation MIExceptionTracker
@synthesize initialized = _initialized;

+ (nullable instancetype)sharedInstance {

  static MIExceptionTracker *shared = nil;
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    shared = [[MIExceptionTracker alloc] init];
  });
  return shared;
}

-(id)init {
     if (self = [super init])  {
#if !TARGET_OS_WATCH
         _signals = @[@SIGABRT, @SIGILL, @SIGSEGV, @SIGFPE, @SIGBUS, @SIGPIPE, @SIGTRAP];
#endif
         _logger = [MappIntelligenceLogger shared];
         _tracker = [MIDefaultTracker sharedInstance];
       self.initialized = NO;
     }
     return self;
}

- (instancetype)initializeExceptionTracking {
    if (self.initialized) {
        return self;
    }
    
    [self installUncaughtExceptionHandler];
    self.initialized = YES;
    return self;
}

- (void) installUncaughtExceptionHandler {
    _previousSignalHandlers = NSGetUncaughtExceptionHandler();
    [_logger logObj:@"exception tracking has been initialized" forDescription:kMappIntelligenceLogLevelDescriptionInfo];
}

-(BOOL) checkIfInitialized {
    if (!self.initialized) {
        [_logger logObj:@"MappIntelligence exception tracking isn't initialited" forDescription:kMappIntelligenceLogLevelDescriptionInfo];
    }
    return self.initialized;
}

- (NSError*) trackInfoWithName:(NSString *)name andWithMessage:(NSString *)message {
    if (![self checkIfInitialized]) {
        return [NSError errorWithDomain:@"com.mapp.mappIntelligence" code:900 userInfo:@{@"Error reason": @"MappIntelligence exception tracking isn't initialited"}];
    }
    ///satisfyToLevel
    
    //define details
    MIActionEvent* actionEvent = [[MIActionEvent alloc] initWithName:@"webtrekk_ignore"];
    NSMutableDictionary* parameters = [[NSMutableDictionary alloc] init];
    if (name) {
        [parameters setObject:name forKey:[NSNumber numberWithInt:911]];
    }
    if (message) {
        [parameters setObject:message forKey:[NSNumber numberWithInt:912]];
    }
    MIEventParameters* actionProperties = [[MIEventParameters alloc] initWithParameters:parameters];
    actionEvent.eventParameters = actionProperties;
    
    return [_tracker trackWithCustomEvent:actionEvent];
    /*

     var details: [Int: TrackingValue] = [:]

     details[910] = .constant(String(logLevel.rawValue))

     if let name = name as String?, !name.isEmpty {
         details[911] = .constant(name)
     }
     if let message = message as String?, !message.isEmpty {
         details[912] = .constant(message)
     }
     if let stack = stack as String?, !stack.isEmpty {
         details[913] = .constant(stack)
     }
     if let userInfo = userInfo as String?, !userInfo.isEmpty {
         details[916] = .constant(userInfo)
     }
     if let stackReturnAddress = stackReturnAddress as String?, !stackReturnAddress.isEmpty {
         details[917] = .constant(stackReturnAddress)
     }
     let action = ActionEvent(actionProperties: ActionProperties(name: "webtrekk_ignore", details: details),
                              pageProperties: PageProperties(name: nil))

     webtrekk.enqueueRequestForEvent(action, type: .exceptionTracking)
     */
    
}

- (void)trackException:(NSException *)exception {
    
}

- (void)trackError:(NSError *)error {
    
}

@end
