//
//  AppoxeeManager.h
//  AppoxeeSDK
//
//  Created by Raz Elkayam on 12/25/14.
//  Copyright (c) 2014 Appoxee. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "APXPushNotification.h"
#import "APXRichMessage.h"
#import "APXClientDevice.h"

@class AppoxeeManager;

@protocol AppoxeeDelegate <NSObject>

@required
/**
 Provide Appoxee with an SDK ID.
 @brief Method will transfer SDK ID data to Appoxee Manager.
 @return NSString representation of the SDK ID.
 */
- (nonnull NSString *)AppoxeeDelegateAppSDKID DEPRECATED_MSG_ATTRIBUTE("using engageWithLaunchOptions:andDelegate:andSDKID: does not require implementing this method");

/**
 Provide Appoxee with an App Secret.
 @brief Method will transfer App Secret data to Appoxee Manager.
 @return NSString representation of the App Secret.
 */
- (nonnull NSString *)AppoxeeDelegateAppSecret DEPRECATED_MSG_ATTRIBUTE("using engageWithLaunchOptions:andDelegate:andSDKID: does not require implementing this method");

@optional
/**
 Delegate method for notifing when a Push Notification is recieved when the application is closed.
 @brief use this method to be alrted when a Push Notification initiates your application.
 @param userInfo an NSDictionary representation of a Push Notification
 */
- (void)appDidOpenFromPushNotification:(nonnull NSDictionary *)userInfo DEPRECATED_MSG_ATTRIBUTE("Use appoxeeManager:handledRemoteNotification:andIdentifer: instead.");

/**
 Delegate method for udpating application badge icon.
 @brief use this method to keep your application badge icon updated with the current notifications count.
 @param badgeNum An Int value with the amount of Notifications pending.
 @param hasNumberChanged A BOOL value indicating if the @c badgeNum has changed.
 */
- (void)AppoxeeNeedsToUpdateBadge:(int)badgeNum hasNumberChanged:(BOOL)hasNumberChanged DEPRECATED_MSG_ATTRIBUTE("Use appoxeeManager:handledRemoteNotification:andIdentifer: instead.");

// Deprecated delegate methods
- (void)appoxeeInteractivePushNotificationPressedWithCategory:(nonnull NSString*)category andPayload:(nonnull NSDictionary*)pushPayload DEPRECATED_MSG_ATTRIBUTE("No calls will be forwarded to this method. Use appoxeeManager:handledRemoteNotification:andIdentifer: instead.");
- (void)appoxeeInteractivePushButton1PressedWithCategory:(nonnull NSString*)category andPayload:(nonnull NSDictionary*)pushPayload DEPRECATED_MSG_ATTRIBUTE("No calls will be forwarded to this method. Use appoxeeManager:handledRemoteNotification:andIdentifer: instead.");
- (void)appoxeeInteractivePushButton2PressedWithCategory:(nonnull NSString*)category andPayload:(nonnull NSDictionary*)pushPayload DEPRECATED_MSG_ATTRIBUTE("No calls will be forwarded to this method. Use appoxeeManager:handledRemoteNotification:andIdentifer: instead.");
- (void)AppoxeeDelegateReciveAppoxeeClosed DEPRECATED_MSG_ATTRIBUTE("No calls will be forwarded to this method.");
- (void)AppoxeeDelegateReciveAppoxeeRequestFocus DEPRECATED_MSG_ATTRIBUTE("No calls will be forwarded to this method.");
- (BOOL)shouldAppoxeeRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation DEPRECATED_MSG_ATTRIBUTE("No calls will be forwarded to this method.");

@end

@interface AppoxeeManager : NSObject

+ (nullable instancetype)sharedManager;

#pragma mark - Appoxee Push Service Legacy

/**
 Method for initializaing Appoxee Manager.
 @brief Initialize Appoxee Manager with a Delegate and launchOptions.
 @see engageWithLaunchOptions:andDelegate:andSDKID:
 @param delegate A Delegate which implements AppoxeeDelegate protocol.
 @param options NSDictionay containing options for AppoxeeManager provided by the implementing developer.
 */
- (void)initManagerWithDelegate:(nullable id<AppoxeeDelegate>)delegate andOptions:(nullable NSDictionary *)options DEPRECATED_MSG_ATTRIBUTE("use engageWithLaunchOptions:andDelegate:andSDKID: instead.");

/**
 Method for parsing launchOptions by Appoxee Manager.
 @brief Parse launchOptions by Appoxee Manager.
 @see engageWithLaunchOptions:andDelegate:andSDKID:
 @param launchOptions NSDictionay containing launchOptions for AppoxeeManager provided by ApplicationDidLaunch method.
 */
- (void)managerParseLaunchOptions:(nullable NSDictionary *)launchOptions  DEPRECATED_MSG_ATTRIBUTE("use engageWithLaunchOptions:andDelegate:andSDKID: instead.");

#pragma mark - Push Handling Legacy

/**
 Method for notifing AppoxeeManager a remote Push Notification was received to the device.
 @brief Use this method to pass info to Appoxee Manager regarding incoming Push messages.
 @see receivedRemoteNotification:
 @param userInfo NSDictionary object containing user info with Push payload.
 @return YES, always returns YES.
 */
- (BOOL)didReceiveRemoteNotification:(nullable NSDictionary *)userInfo DEPRECATED_MSG_ATTRIBUTE("use receivedRemoteNotification: instead.");

/**
 Method for notifing AppoxeeManager a token was received.
 @brief Use this method for notifing AppoxeeManager a token was received.
 @see didRegisterForRemoteNotificationsWithDeviceToken:
 @param token NSData object containing user token.
 */
- (void)didRegisterForRemoteNotificationsWithDeviceToken:(nonnull NSData *)token DEPRECATED_MSG_ATTRIBUTE("use didRegisterForRemoteNotificationsWithDeviceToken: instead.");

/**
 Method for handling 'Push Actions'. Forward this call to Appoxee directly and call completionHandler(); if the returned value is NO, since Appoxee will not handle a complete custom action provided by the developer.
 @brief Implementation of this method enables ‘Push Actions’. Forward this call to Appoxee directly and call completionHandler(); if the returned value is NO, since Appoxee will not handle a complete custom action provided by the developer.
 @param identifier The identifier argument passed by the application delegate.
 @param userInfo The userInfo argument passed by the application delegate.
 @param completionHandler The completionHandler argument passed by the application delegate.
 @return YES, if Appoxee handled the action, else returns NO. If the returned value is NO, you will need to call completionHandler(); after you finish handling the Push action.
 */
- (BOOL)handleActionWithIdentifier:(nullable NSString *)identifier forRemoteNotification:(nonnull NSDictionary *)userInfo completionHandler:(void (^ _Nullable)())completionHandler DEPRECATED_MSG_ATTRIBUTE("use handleActionWithIdentifier:forRemoteNotification:completionHandler: instead.");

#pragma mark - Device API Legacy

/**
 Disable and re-enable Push Notifications on Appoxee dashboard.
 @brief Method will disable or re-enable Push Notification per device at Appoxee Dashboard.
 @see disablePushNotifications:withCompletionHandler:
 @param flag BOOL value indacating if should enable or disable.
 */
- (void)optOutPush:(BOOL)flag DEPRECATED_MSG_ATTRIBUTE("use disablePushNotifications:withCompletionHandler: instead.");

/**
 Get the current state of the push on Appoxee dashboard.
 @brief Method to get the current state of the push status on Appoxee dashboard.
 @return YES, if push is enabled, otherwise NO.
 */
- (BOOL)isPushEnabled DEPRECATED_MSG_ATTRIBUTE("use isPushEnabled: instead.");

/**
 Disable and re-enable Inbox.
 @brief Method will disable or re-enable Inbox.
 @param flag BOOL value indacating if should enable or disable sound.
 */
- (void)optOutInbox:(BOOL)flag DEPRECATED_MSG_ATTRIBUTE("use disableInbox:withCompletionHandler: instead.");

/**
 Get the current state of the Inbox on Appoxee dashboard.
 @brief Method to get the current state of the Inbox status on Appoxee dashboard.
 @return YES, if inbox is enabled, otherwise NO.
 */
- (BOOL)isInboxEnabled DEPRECATED_MSG_ATTRIBUTE("use isInboxEnabled: instead.");

#pragma mark - Alias Legacy

/**
 Set an alias to be identifies with a device.
 @brief Method will synchronously set an alias to be identifies with a device.
 @param alias An NSString object representing an alias.
 @return YES on success, NO on failure.
 */
- (BOOL)setDeviceAlias:(nullable NSString *)alias DEPRECATED_MSG_ATTRIBUTE("use setDeviceAlias:withCompletionHandler instead.");

/**
 Remove an alias from a device.
 @brief Method will synchronously remove an alias from a device.
 @return YES on success, NO on failure.
 */
- (BOOL)removeDeviceAlias DEPRECATED_MSG_ATTRIBUTE("use removeDeviceAliasWithCompletionHandler: instead.");

/**
 Get an alias for a device.
 @brief Method will synchronously get alias for a device.
 @return NSString instance of the device Alias.
 */
- (nullable NSString *)getDeviceAlias DEPRECATED_MSG_ATTRIBUTE("use getDeviceAliasWithCompletionHandler: instead.");

/**
 Clear cached value of an alias.
 @brief Method will clear cached value of an alias.
 */
- (void)clearAliasCache DEPRECATED_MSG_ATTRIBUTE("use clearAliasCacheWithCompletionHandler: instead.");

#pragma mark - Device Tags Legacy

/**
 Get the device tags from Appoxee's servers
 @brief Method synchronously gets the device tags from Appoxee's servers.
 @attention method is deprecated.
 @return NSArray containing strings with device tags values.
 */
- (nullable NSArray *)getDeviceTags DEPRECATED_MSG_ATTRIBUTE("use fetchDeviceTags: instead.");

/**
 Get the applicatoin tags from Appoxee's servers
 @brief Method synchronously gets the application tags from Appoxee's servers.
 @attention method is deprecated.
 @return NSArray containing strings with application tags values.
 */
- (nullable NSArray *)getTagList DEPRECATED_MSG_ATTRIBUTE("use fetchApplicationTags: instead.");

/**
 Add tags to the device and removes tags from device.
 @brief Method adds and remove tags to / from the device, while syncing with Appoxee Servers.
 @param tagsToAdd NSArray containing a list of NSString tags.
 @param tagsToRemove NSArray containing a list of NSString tags.
 @return YES on success, NO on faliure
 */
- (BOOL)addTagsToDevice:(nullable NSArray *)tagsToAdd andRemove:(nullable NSArray *)tagsToRemove DEPRECATED_MSG_ATTRIBUTE("use addTagsToDevice:andRemove:withCompletionHandler: instead.");

/**
 Add tags to the device.
 @brief Method adds tags to the device, while syncing with Appoxee Servers.
 @param tags NSArray containing a list of NSString tags.
 @return YES on success, NO on faliure
 */
- (BOOL)addTagsToDevice:(nullable NSArray *)tags DEPRECATED_MSG_ATTRIBUTE("use addTagsToDevice:withCompletionHandler: instead.");

/**
 Remove tags from the device.
 @brief Method remove tags from the device, while syncing with Appoxee Servers.
 @param tags NSArray containing a list of NSString tags.
 @return YES on success, NO on faliure
 */
- (BOOL)removeTagsFromDevice:(nullable NSArray*)tags DEPRECATED_MSG_ATTRIBUTE("use removeTagsFromDevice:withCompletionHandler: instead.");

/**
 Clear device tags cached on device.
 @brief Method will clear device tags cache.
 */
- (void)clearTagsCache DEPRECATED_MSG_ATTRIBUTE("use clearTagsCacheWithCompletionhandler: instead.");

#pragma mark - Custom Fields Legacy

/**
 Set key-value data with a value of an NSDate to Appoxee Servers.
 @brief Method sets a key-value pair with a value of NDSate to Appoxee Servers.
 @param datesDict NSMutableDictionary with an NSDate as a value.
 @return YES on success, NO on faliure.
 */
- (BOOL)setDateFields:(nullable NSMutableDictionary *)datesDict DEPRECATED_MSG_ATTRIBUTE("use setDateField:withCompletionHandler: instead.");

/**
 Set key-value data with a value of an NSNumber to Appoxee Servers.
 @brief Method sets a key-value pair with a value of NSNumber to Appoxee Servers.
 @param numericValuesDict NSMutableDictionary with an NSNumber as a value.
 @return YES on success, NO on faliure.
 */
- (BOOL)setNumericFields:(nullable NSMutableDictionary *)numericValuesDict DEPRECATED_MSG_ATTRIBUTE("use setNumericField:withCompletionHandler: instead.");

/**
 Increment an exitsing numeric key-value data with value of an NSNumber to Appoxee Servers.
 @brief Method increments an exitsing numeric key-value data with value of an NSNumber to Appoxee Servers.
 @param numericValuesDict NSMutableDictionary with an NSNumber as a value.
 @return YES on success, NO on faliure.
 */
- (BOOL)incNumericFields:(nullable NSMutableDictionary *)numericValuesDict DEPRECATED_MSG_ATTRIBUTE("use incrementNumericField:withCompletionHandler: instead.");

/**
 Set key-value data with a value of an NSString to Appoxee Servers.
 @brief Method sets a key-value pair with a value of NSString to Appoxee Servers.
 @param stringValuesDict NSMutableDictionary with an NSString as a value.
 @return YES on success, NO on faliure.
 */
- (BOOL)setStringFields:(nullable NSMutableDictionary *)stringValuesDict DEPRECATED_MSG_ATTRIBUTE("use setStringField:withCompletionHandler: instead.");

/**
 Get a custom field by it's key.
 @brief Method will synchronously get a custom field by it's key.
 @param key NSString object with the value of a previously provided key, in a key-value pair.
 @return NSString containing the value of the key.
 */
- (nullable NSString *)getCustomFieldByKey:(nullable NSString *)key DEPRECATED_MSG_ATTRIBUTE("use fetchCustomFieldByKey:withCompletionHandler: instead.");

#pragma mark - Device Info Legacy

/**
 Get the iDevice OS name.
 @brief Method will get the iDevice OS name.
 @return NSString representin OS name.
 */
- (nullable NSString *)getDeviceOsName DEPRECATED_MSG_ATTRIBUTE("use deviceInformationwithCompletionHandler: instead.");

/**
 Get the iDevice OS number.
 @brief Method will get the iDevice OS number.
 @return NSString representin OS number.
 */
- (nullable NSString *)getDeviceOsNumber DEPRECATED_MSG_ATTRIBUTE("use deviceInformationwithCompletionHandler: instead.");

/**
 Get the iDevice hardware type.
 @brief Method will get the iDevice hardware type.
 @return NSString representin hardware type.
 */
- (nullable NSString *)getHardwareType DEPRECATED_MSG_ATTRIBUTE("use deviceInformationwithCompletionHandler: instead.");

/**
 Get the iDevice country.
 @brief Method will get the iDevice country.
 @return NSString representin country.
 */
- (nullable NSString *)getDeviceCountry DEPRECATED_MSG_ATTRIBUTE("use deviceInformationwithCompletionHandler: instead.");

/**
 Get the iDevice application ID.
 @brief Method will get the iDevice application ID.
 @return NSString representin application ID.
 */
- (nullable NSString *)getApplicationID DEPRECATED_MSG_ATTRIBUTE("use deviceInformationwithCompletionHandler: instead.");

/**
 Get the iDevice application vendor identifier.
 @brief Method will get the iDevice vendor identifier.
 @return NSString representin vendor identifier.
 */
- (nullable NSString *)getDeviceUniqueID DEPRECATED_MSG_ATTRIBUTE("use deviceInformationwithCompletionHandler: instead.");

#pragma mark - Inbox API Legacy

/**
 Delete an Inbox Message.
 @brief Method will delete an Inbox Message.
 @attention original object was AppoxeeMessage, now object is APXRichMessage
 @param appoxeeMessage An APXRichMessage instance.
 */
- (void)deleteAppoxeeMessage:(nullable id)appoxeeMessage DEPRECATED_MSG_ATTRIBUTE("use deleteRichMessage:withHandler: instead.");

/**
 Get Inbox Messages.
 @brief Method will get Inbox Messages.
 @return NSArray with APXRichMessage instances.
 */
- (nullable NSArray *)getInboxMessages DEPRECATED_MSG_ATTRIBUTE("use getRichMessagesWithHandler: or refreshDataWithCompletionHandler: instead.");

#pragma mark - Other Legacy

/* 
 * All methods below are deprecated.
 * Methods which return an instance, will always return nil.
 * Methods which return a BOOL, will always return NO.
 * Method which return an int, will always return 0.
 */
- (void)disableFeedbackAndMoreApps:(BOOL)shouldDisable DEPRECATED_ATTRIBUTE;
- (nullable NSString *)getServerV3URL DEPRECATED_ATTRIBUTE;
- (nullable NSString *)getGateKeeperURL DEPRECATED_ATTRIBUTE;
- (nullable NSString *)getServerV2URL DEPRECATED_ATTRIBUTE;
- (nullable NSString *)getMoreAppsURL DEPRECATED_ATTRIBUTE;
- (nullable NSString *)getFeedbackURL DEPRECATED_ATTRIBUTE;
- (nullable NSString *)getDeviceDefURL DEPRECATED_ATTRIBUTE;
- (nullable NSString *)getDeviceAdsURL DEPRECATED_ATTRIBUTE;
- (nullable NSArray *)setAttributeWithDict:(nullable NSMutableDictionary *)param andKey:(nullable NSString*)keyParam DEPRECATED_ATTRIBUTE;
- (nullable NSString *)getAttribute:(nullable NSString *)param DEPRECATED_ATTRIBUTE;
- (void)configureAppoxeeForLocale:(nullable NSString *)theLocale DEPRECATED_ATTRIBUTE;
- (void)optOutQuietTime DEPRECATED_ATTRIBUTE;
- (void)SplashScreen DEPRECATED_ATTRIBUTE;
- (void)optOutBadge:(BOOL)flag DEPRECATED_ATTRIBUTE;
- (void)optOutSound:(BOOL)flag DEPRECATED_ATTRIBUTE;
- (UIRemoteNotificationType)getNotificationStatus DEPRECATED_ATTRIBUTE;
- (void)setQuietTime:(nullable NSString *)startTimeParam endTime:(nullable NSString *)endTimeParam DEPRECATED_ATTRIBUTE;
- (nullable NSString *) getSplashScreen DEPRECATED_ATTRIBUTE;
- (nullable NSString *) getPoweredByImageLink DEPRECATED_ATTRIBUTE;
- (nullable NSString *)getQuietTimeStart DEPRECATED_ATTRIBUTE;
- (nullable NSString *)getQuietTimeEnd DEPRECATED_ATTRIBUTE;
- (void)setSoundEnabled:(BOOL)enabled DEPRECATED_ATTRIBUTE;
- (void)setBadgeEnabled:(BOOL)enabled DEPRECATED_ATTRIBUTE;
- (BOOL)isCoppaShown DEPRECATED_ATTRIBUTE;
- (BOOL)isSoundEnabled DEPRECATED_ATTRIBUTE;
- (BOOL)isBadgeEnabled DEPRECATED_ATTRIBUTE;
- (int)getDeviceActivations DEPRECATED_ATTRIBUTE;
- (nullable NSDecimalNumber *) getInAppPayment DEPRECATED_ATTRIBUTE;
- (int)getNumProductsPurchased DEPRECATED_ATTRIBUTE;
- (BOOL)increaseInAppPayment:(nullable NSDecimalNumber *)payment andNumPurchased:(nullable NSDecimalNumber *)numPurchased DEPRECATED_ATTRIBUTE;
- (BOOL)increaseNumProductPurchased:(nullable NSDecimalNumber *)payment DEPRECATED_ATTRIBUTE;
- (int)getInboxFlag DEPRECATED_ATTRIBUTE;
- (int)getCustomInboxFlag DEPRECATED_ATTRIBUTE;
- (int)getFeedbackFlag DEPRECATED_ATTRIBUTE;
- (int)getMoreAppsFlag DEPRECATED_ATTRIBUTE;
- (void)openAppoxeeMessage:(nullable id)appoxeeMessage DEPRECATED_ATTRIBUTE;
- (void)addBadgeToView:(nullable UIView *)badgeView badgeText:(nullable NSString *)badgeText badgeLocation:(CGPoint)badgeLocation DEPRECATED_ATTRIBUTE;
- (void)addBadgeToView:(nullable UIView *)badgeView badgeText:(nullable NSString *)badgeText badgeLocation:(CGPoint)badgeLocation shouldFlashBadge:(BOOL)shouldFlashBadge DEPRECATED_ATTRIBUTE;
- (void)addBadgeToView:(nullable UIView *)badgeView badgeText:(nullable NSString *)badgeText badgeLocation:(CGPoint)badgeLocation shouldFlashBadge:(BOOL)shouldFlashBadge withFontSize:(float)fontSize DEPRECATED_ATTRIBUTE;
- (void)show DEPRECATED_ATTRIBUTE;
- (BOOL)showMoreAppsViewController DEPRECATED_ATTRIBUTE;
- (BOOL)showFeedbackViewController DEPRECATED_ATTRIBUTE;
- (void)showMoreAppsOnInbox:(BOOL)show DEPRECATED_ATTRIBUTE;
- (void)showFeedbackOnInbox:(BOOL)show DEPRECATED_ATTRIBUTE;
- (nullable UIViewController *)getAppoxeeViewController DEPRECATED_ATTRIBUTE;
- (nullable UIViewController *)getAppoxeeMoreAppsViewController DEPRECATED_ATTRIBUTE;
- (nullable UIViewController *)getAppoxeeFeedbackViewController DEPRECATED_ATTRIBUTE;
- (void)recalculateUnreadMessagesBadge DEPRECATED_ATTRIBUTE;
- (void)setUsingCustomInbox:(BOOL)isCustom DEPRECATED_ATTRIBUTE;
- (BOOL)getUsingCustomInboxFlag DEPRECATED_ATTRIBUTE;
- (void)showCustomInbox:(BOOL)show DEPRECATED_ATTRIBUTE;
+ (void)automaticallyClearNotifications:(BOOL)automatically DEPRECATED_ATTRIBUTE;
+ (BOOL)isNotificationsClearedAutomatically DEPRECATED_ATTRIBUTE;

@end