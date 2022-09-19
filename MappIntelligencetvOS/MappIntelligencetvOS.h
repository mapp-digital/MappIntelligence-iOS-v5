//
//  MappIntelligencetvOS.h
//  MappIntelligencetvOS
//
//  Created by Stefan Stevanovic on 4/24/20.
//  Copyright © 2020 Mapp Digital US, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "MIPageViewEvent.h"
#import "MIActionEvent.h"
#import "MIMediaEvent.h"
#import "MIParams.h"
#import "MIParamType.h"

typedef NS_ENUM(NSInteger, logTvOSLevel) {
  allTvOSLogs = 1,     // All logs of the above.
  debugTvOSLogs = 2,   // The lowest priority that you would normally log, and purely
               // informational in nature.
  warningTvOSLogs = 3, // Something is missing and might fail if not corrected
  errorTvOSLogs = 4,   // Something has failed.
  faultTvOSLogs = 5,   // A failure in a key system.
  infoTvOSLogs = 6, // Informational logs for updating configuration or migrating from
            // older versions of the library.
  noneOfTvOSLogs = 7  // None of the logs.
};

@interface MappIntelligencetvOS : NSObject


@property (nonatomic, readwrite) NSTimeInterval requestInterval;
@property (nonatomic, readwrite) logTvOSLevel logLevelTVOS;
@property (nonatomic, readwrite) BOOL batchSupportEnabled;
@property (nonatomic, readwrite) BOOL enableBackgroundSendout;
@property (nonatomic, readwrite) BOOL enableUserMatching;
@property (nonatomic, readwrite) NSInteger batchSupportSize;
@property (nonatomic, readwrite) NSInteger requestPerQueue;
@property (nonatomic, readwrite) BOOL shouldMigrate;
@property (nonatomic, readwrite) BOOL anonymousTracking;

/**
 MappIntelignece instance
 @brief Method for gets a singleton instance of MappInteligence.
 @code
 MappIntelligencetvOS *mappIntelligence = [MappIntelligencetvOS shared];
 @endcode
 @return MappIntelligence an Instance Type of MappIntelligence.
 */
+ (nullable instancetype)shared;
/**
@brief Method to initialize tracking. Please specify your track domain and trackID.
@param trackIDs - Array of your trackIDs. The information can be provided by your account manager.
@param trackDomain - String value of your track domain. The information can be provided by your account manager.
@code
MappIntelligencetvOS.shared()?.initWithConfiguration([12345678, 8783291721], onTrackdomain: "www.mappIntelligence-trackDomain.com")
@endcode
*/
- (void)initWithConfiguration:(NSArray *_Nonnull)trackIDs
                    onTrackdomain:(NSString *_Nonnull)trackDomain;


/**
@brief Method to collect the name of the current UIViewController and track additional page information.
@param controller - current ui view controller.
@param event - page view event that can contain properties for page, session, ecommerce, action, advertisement and user
@code

@endcode
@return Error in case of a failure. Returns nil if no error was detected.
*/
- (NSError *_Nullable)trackPageWithViewController:(UIViewController *_Nonnull)controller pageViewEvent:(MIPageViewEvent*_Nonnull) event;

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
@brief Method to reset the MappIntelligence singleton. This method will set the default empty values for trackID and track domain. Please ensure to provide new trackIDs and track domain.
@code
MappIntelligencetvOS.shared()?.reset()
@endcode
*/
- (void)reset;

/**
@brief Method to opt-in for tracking. This enables tracking.
@code
 MappIntelligencetvOS.shared()?.optIn()
@endcode
 */
-(void) optIn;


/**
@brief Method to opt-out of tracking. In case of opt-out, no data will be sent to Mapp Intelligence anymore.
@param value - If set to true, all track requests currently stored in the database will be sent to MappIntelligence. If set to false, opt-out of tracking will be executed immediately and remaining data in the database will be lost.
@code
 MappIntelligencetvOS.shared()?.optOut(with: false, andSendCurrentData: false)
@endcode
 */
- (void)optOutAndSendCurrentData:(BOOL) value;


/**
 @brief Method which will enable anonymous tracking and omit submitted parameters/tags array. Please note that using this option will negatively affect data quality.
 @param suppressParams - array list of parameters to ignore during anonimous tracking
 */
- (void) enableAnonymousTracking:(NSArray<NSString *> *_Nullable) suppressParams;


@end
