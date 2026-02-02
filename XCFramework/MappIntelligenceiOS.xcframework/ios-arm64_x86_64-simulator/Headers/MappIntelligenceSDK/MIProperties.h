//
//  MIProperties.h
//  MappIntelligenceSDK
//
//  Created by Stefan Stevanovic on 2/12/20.
//  Copyright © 2020 Mapp Digital US, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, ConnectionType) {
  cellular_2G = 0,
  cellular_3G = 1,
  cellular_4G = 2,
  offline = 3,
  other = 4,
  wifi = 5
};

@interface MIProperties : NSObject

@property NSUUID *advertisingId;
@property BOOL advertisingTrackingEnabled;
@property ConnectionType connectionType;
@property NSString *everId;
@property BOOL isFirstEventAfterAppUpdate;
@property BOOL isFirstEventOfApp;
@property BOOL isFirstEventOfSession;
@property NSLocale *locale;
@property NSInteger requestQueueSize;
@property NSObject *screenSize;
@property NSInteger samplingRate;
@property NSTimeZone *timeZone;
@property NSDate *timestamp;
@property NSString *userAgent;
@property NSInteger adClearId;
@property UIInterfaceOrientation *interfaceOrientation;

- (instancetype)initWithEverID:(NSString *)eid
               andSamplingRate:(NSInteger)rate
                  withTimeZone:(NSTimeZone *)zone
                 withTimestamp:(NSDate *)stamp
                 withUserAgent:(NSString *)agent;
@end

NS_ASSUME_NONNULL_END
