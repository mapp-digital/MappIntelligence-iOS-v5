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

@interface MappIntelligence : NSObject {
}

@property (nonatomic, readwrite) NSTimeInterval requestInterval;
@property (nonatomic, readwrite) logLevel logLevel;
@property (nonatomic, readwrite) BOOL batchSupportEnabled;
@property (nonatomic, readwrite) NSInteger batchSupportSize;
@property (nonatomic, readwrite) NSInteger requestPerQueue;
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

#if !TARGET_OS_WATCH

/**
@brief Method to collect the name of the current UIViewController and track additional page information.
@param controller - current ui view controller.
@param event - page view event that can contain properties for page, session, ecommerce, action, advertisement and user
@code

@endcode
@return Error in case of a failure. Returns nil if no error was detected.
*/
- (NSError *_Nullable)trackPageWithViewController:(UIViewController *_Nonnull)controller pageViewEvent:(MIPageViewEvent*_Nullable) event;

#endif

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

@end
