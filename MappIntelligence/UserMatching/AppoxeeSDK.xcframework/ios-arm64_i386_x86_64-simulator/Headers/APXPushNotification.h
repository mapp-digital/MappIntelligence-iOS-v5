//
//  APXPushNotification.h
//  AppoxeeSDK
//
//  Created by Raz Elkayam on 3/8/15.
//  Copyright (c) 2015 Appoxee. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "APXPushNotificationAction.h"

@class UNNotificationResponse;
@class UNNotification;

@interface APXPushNotification : NSObject

/*!
 * The alert property of a push notification payload.
 */
@property (nonatomic, strong, readonly, nullable) NSString *alert;

/*!
 * The title property of a push notification payload.
 */
@property (nonatomic, strong, readonly, nullable) NSString *title;

/*!
 * The subtitle property of a push notification payload.
 */
@property (nonatomic, strong, readonly, nullable) NSString *subtitle;

/*!
 * The body property of a push notification payload.
 */
@property (nonatomic, strong, readonly, nullable) NSString *body;

/*!
 * The badge property of a push notification payload.
 */
@property (nonatomic, readonly) NSInteger badge;

/*!
 * The notification Appoxee unique ID.
 */
@property (nonatomic, readonly) NSInteger uniqueID;

/*!
 * The extra fields associated with the push notification payload.
 */
@property (nonatomic, strong, readonly, nullable) NSDictionary *extraFields;

/*!
 * Indicating if push launched the application
 */
@property (nonatomic, readonly) BOOL didLaunchApp;

/*!
 * Indicating if push was sent with a rich payload.
 */
@property (nonatomic, readonly) BOOL isRich;

/*!
 * Indicating if the push is silent.
 */
@property (nonatomic, readonly) BOOL isSilent;

/*!
 * Indicating if the push should fetch content in the background.
 */
@property (nonatomic, readonly) BOOL isTriggerUpdate;

/*!
 * The associated actions with the push payload.
 */
@property (nonatomic, strong, readonly, nullable) APXPushNotificationAction *pushAction;

/*!
 * Class initializer with NSDictionary as push payload.
 */
+ (nullable instancetype)notificationWithKeyedValues:(nullable NSDictionary *)keyedValues;

/*!
 * Class initializer with UNNotification as push payload.
 */
+ (nullable instancetype)notificationWithNotification:(nullable UNNotification *)notification;

/*!
 * Class initializer with UNNotificationResponse as push payload.
 */
+ (nullable instancetype)notificationWithNotificationResponse:(nullable UNNotificationResponse *)notificationResponse;

@end
