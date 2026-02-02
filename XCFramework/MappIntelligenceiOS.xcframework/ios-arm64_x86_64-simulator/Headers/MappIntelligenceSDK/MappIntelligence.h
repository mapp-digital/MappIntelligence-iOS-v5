//
//  Webrekk.h
//  Webrekk
//
//  Created by Stefan Stevanovic on 1/3/20.
//  Copyright © 2020 Mapp Digital US, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "MIPageViewEvent.h"
#import "MIActionEvent.h"
#import "MIParams.h"
#import "MIParamType.h"
#import "MIMediaEvent.h"
#import "MIFormSubmitEvent.h"


@class MappIntelligence;

typedef NS_ENUM(NSInteger, logLevel) {
  all = 1,     // All logs of the above.
  debug = 2,   // The lowest priority that you would normally log, and purely
               // informational in nature.
  warning = 3, // Something is missing and might fail if not corrected
  error = 4,   // Something has failed.
  fault = 5,   // A failure in a key system.
  info = 6, // Informational logs for updating configuration or migrating from
            // older versions of the library.
  none = 7  // None of the logs.
};

typedef NS_ENUM(NSInteger, exceptionType) {
    noneOfExceptionTypes = 1,
    uncaught = 2,
    caught = 3,
    custom = 4,
    allExceptionTypes = 5,
    uncaught_and_custom = 6,
    uncaught_and_caught = 7,
    custom_and_caught = 8
};

@interface MappIntelligence : NSObject {
}

@property (nonatomic, readwrite) NSTimeInterval requestInterval;
@property (nonatomic, readwrite) logLevel logLevel;
@property (nonatomic, readwrite) BOOL batchSupportEnabled;
@property (nonatomic, readwrite) BOOL enableBackgroundSendout;
@property (nonatomic, readwrite) NSInteger batchSupportSize;
@property (nonatomic, readwrite) NSInteger requestPerQueue;
@property (nonatomic, readwrite) BOOL shouldMigrate;
@property (nonatomic, readwrite) BOOL anonymousTracking;
@property (nonatomic, readwrite) BOOL sendAppVersionInEveryRequest;

/// This options helps you to unifiy user from Mapp Intelligence SDK and Mapp Engage SDK if you are using both of them
@property (nonatomic, readwrite) BOOL enableUserMatching;

/**
 MappIntelligence instance
 @brief Method to get a singleton instance of MappIntelligence
 @code
 let mappInteligenceSingleton = MappIntelligence.shared()
 @endcode
 @return MappIntelligence an Instance Type of MappIntelligence.
 */
+ (nullable instancetype)shared;
+ (NSString *_Nonnull)version;
+ (NSString *_Nonnull)getUrl;
+ (NSString *_Nonnull)getId;


/// Method to set temporary session id, if anonimous tracking is turn on.
/// @param ID tempraryID which is wont to be set
- (void)setTemporarySessionId: (NSString*_Nonnull)ID;
/**
@brief Method to collect the name of the current UIViewController and track additional page information.
@param controller - current ui view controller.
@param event - page view event that can contain properties for page, session, ecommerce, action, advertisement and user
@code

@endcode
@return Error in case of a failure. Returns nil if no error was detected.
*/
- (NSError *_Nullable)trackPageWithViewController:(UIViewController *_Nonnull)controller pageViewEvent:(MIPageViewEvent*_Nullable) event;


/**
@brief Method which will track page event
@param event - page view event
@code
 let event = MIActionEvent(name: "TestAction")
 MappIntelligence.shared()?.trackEvent(event);
 @endcode
@return the error which may happen through process of tracking, if returns nil there is no error.
*/
- (NSError *_Nullable) trackPage:(MIPageViewEvent *_Nonnull) event;

/**
@brief Method which will track action event
@param event - action event
@code
 let event = MIActionEvent(name: "TestAction")
 MappIntelligence.shared()?.trackAction(event);
 @endcode
@return the error which may happen through process of tracking, if returns nil there is no error.
*/
- (NSError *_Nullable) trackAction:(MIActionEvent *_Nonnull) event;

/**
@brief Method which will track media event
@param event - media event
@code
let mediaProperties = MIMediaParameters("TestVideo", action: "view", postion: 12, duration: 120)
let mediaEvent = MIMediaEvent(pageName: "Test", parameters: mediaProperties)
MappIntelligence.shared()?.trackMedia(mediaEvent)
@endcode
@return the error which may happen through process of tracking, if returns nil there is no error.
 */
- (NSError *_Nullable) trackMedia:(MIMediaEvent *_Nonnull) event;


/**
@brief Method which will track campaign parameters from url
@param url - url object with campaign parameters
@param mediaCode - custom media code, if nil "wt_mc" is used as default
@code
 MappIntelligence.shared()?.trackUrl(userActivity.webpageURL, withMediaCode: nil)
@endcode
@return the error which may happen through process of tracking, if returns nil there is no error.
 */
- (NSError *_Nullable) trackUrl:(NSURL *_Nullable) url withMediaCode:(NSString *_Nullable) mediaCode;

/**
@brief Method which will track exception with name
@param name - custom name of excetpion which we want to track
@param message - approrpiate message for that exception
@code
 MappIntelligence.shared()?.trackException(withName: "test name of exeption", andWithMessage: "this is common exception when you are trying to get data")
@endcode
@return the error which may happen through process of tracking, if returns nil there is no error.
 */
- (NSError *_Nullable) trackExceptionWithName:(NSString *_Nonnull) name andWithMessage:(NSString *_Nonnull) message;

/**
@brief Method which will track campaign parameters from url
@param error - which describes exception
@code
 MappIntelligence.shared()?.trackException(with: error)
@endcode
@return the error which may happen through process of tracking, if returns nil there is no error.
 */
- (NSError *_Nullable) trackExceptionWith:(NSError *_Nonnull) error;

/**
@brief Method to initialize tracking. Please specify your track domain and trackID.
@param trackIDs - Array of your trackIDs. The information can be provided by your account manager.
@param trackDomain - String value of your track domain. The information can be provided by your account manager.
@code
MappIntelligence.shared()?.initWithConfiguration([12345678, 8783291721], onTrackdomain: "www.mappIntelligence-trackDomain.com")
@endcode
*/
- (void)initWithConfiguration:(NSArray *_Nonnull)trackIDs
                    onTrackdomain:(NSString *_Nonnull)trackDomain;

/**
@brief Method to change current trackIDs and domain at runtime of application.
@param trackIDs - Array of your trackIDs. The information can be provided by your account manager.
@param trackDomain - String value of your track domain. The information can be provided by your account manager.
@code
MappIntelligence.shared()?.setIdsAndDomain([12345678, 8783291721], onTrackdomain: "www.mappIntelligence-trackDomain.com")
@endcode
*/
- (void)setIdsAndDomain:(NSArray *_Nonnull)trackIDs
                    onTrackdomain:(NSString *_Nonnull)trackDomain;

/**
@brief Method to initialize tracking. Please specify your track domain and trackID.
@param trackIDs - Array of your trackIDs. The information can be provided by your account manager.
@param trackDomain - String value of your track domain. The information can be provided by your account manager.
@param everID - Strings which represent ever ID, this method is commonly  used when customer redirects user from web app to the mobile so it can keep the same session.
@code
MappIntelligence.shared()?.initWithConfiguration([12345678, 8783291721], onTrackdomain: "www.mappIntelligence-trackDomain.com", andWithEverID: "537363826253")
@endcode
*/
- (void)initWithConfiguration:(NSArray *_Nonnull)trackIDs
                    onTrackdomain:(NSString *_Nonnull)trackDomain andWithEverID: (NSString *_Nonnull) everID;
/**
@brief Method to reset the MappIntelligence singleton. This method will set the default empty values for trackID and track domain. Please ensure to provide new trackIDs and track domain.
@code
MappIntelligence.shared()?.reset()
@endcode
*/
- (void)reset;

/**
@brief Method to opt-in for tracking. This enables tracking.
@code
MappIntelligence.shared()?.optIn()
@endcode
 */
-(void) optIn;


/**
@brief Method to opt-out of tracking. In case of opt-out, no data will be sent to Mapp Intelligence anymore.
@param value - If set to true, all track requests currently stored in the database will be sent to MappIntelligence. If set to false, opt-out of tracking will be executed immediately and remaining data in the database will be lost.
@code
MappIntelligence.shared()?.optOut(with: false, andSendCurrentData: false)
@endcode
 */
- (void)optOutAndSendCurrentData:(BOOL) value;

//testable methods
- (void) printAllRequestFromDatabase;
- (void) removeRequestFromDatabaseWithID: (int)ID;

/**
 @brief Method to opt-out of tracking. In case of opt-out, no data will be sent to Mapp Intelligence anymore.
 @param pageName - name of page/view being tracked
 @param trackingParams - dictionary with key/value pairs of parameters that are bveing tracked
 @return the error which may happen through process of tracking, if returns nil there is no error.
 */
- (NSError *_Nullable) trackCustomPage: (NSString *_Nonnull)pageName trackingParams: (NSDictionary<NSString *, NSString*> *_Nullable) trackingParams;

/**
 @brief Method which will track action event
 @param eventName - name of action event
 @param trackingParams - dictionary with key/value pairs of parameters that are bveing tracked
 @return the error which may happen through process of tracking, if returns nil there is no error.
 */
- (NSError *_Nullable) trackCustomEvent: (NSString *_Nonnull)eventName trackingParams: (NSDictionary<NSString *, NSString*> *_Nullable) trackingParams;

/**
 @brief Method which will track form submit/cancel
 @param formParams - form parameters that are bveing tracked
 @return the error which may happen through process of tracking, if returns nil there is no error.
 */
- (NSError *_Nullable) formTracking: (MIFormParameters *_Nonnull) formParams;

/**
 @brief Method which will enable anonymous tracking and omit submitted parameters/tags array. Please note that using this option will negatively affect data quality.
 @param suppressParams - array list of parameters to ignore during anonimous tracking
 */
- (void) enableAnonymousTracking:(NSArray<NSString *> *_Nullable) suppressParams;

/**
 @brief Method which will enable crash tracking with given exception level
 @param exceptionLogLevel - parameter which represent the excetpion types which can be logged
 */
- (void) enableCrashTracking:(exceptionType) exceptionLogLevel;

/**
 @brief Method which will return ever ID
 @return The string which represent ever ID
 */
- (NSString*_Nonnull) getEverId;

@end
