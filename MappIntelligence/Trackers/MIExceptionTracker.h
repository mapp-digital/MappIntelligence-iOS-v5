//
//  MIExceptionTracker.h
//  MappIntelligenceSDK
//
//  Created by Stefan Stevanovic on 27/08/2021.
//  Copyright © 2021 Mapp Digital US, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MIExceptionTracker : NSObject

@property (nonatomic) BOOL initialized;

+ (nullable instancetype)sharedInstance;

/** do exception tracking for info/warning message */
- (NSError*) trackInfoWithName: (NSString* _Nonnull) name andWithMessage: (NSString* _Nonnull) message;

/** do exception tracking for exception message */
- (void) trackException: (NSException* _Nonnull) exception;

/** do exception tracking for NSError message */
- (void) trackError: (NSError* _Nonnull) error;

- (instancetype) initializeExceptionTracking;


@end

NS_ASSUME_NONNULL_END
