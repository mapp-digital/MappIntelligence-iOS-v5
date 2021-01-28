//
//  MappIntelligenceWatchOS.h
//  MappIntelligenceWatchOS
//
//  Created by Stefan Stevanovic on 3/24/20.
//  Copyright © 2020 Mapp Digital US, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MIPageViewEvent.h"
#import "MIActionEvent.h"
#import "MIParams.h"
#import "MIParamType.h"

typedef NS_ENUM(NSInteger, logWatchOSLevel) {
  allWatchOSLogs = 1,     // All logs of the above.
  debugWatchOSLogs = 2,   // The lowest priority that you would normally log, and purely
               // informational in nature.
  warningWatchOSLogs = 3, // Something is missing and might fail if not corrected
  errorWatchOSLogs = 4,   // Something has failed.
  faultWatchOSLogs = 5,   // A failure in a key system.
  infoWatchOSLogs = 6, // Informational logs for updating configuration or migrating from
            // older versions of the library.
  noneOfWatchOSLogs = 7  // None of the logs.
};
@interface MappIntelligenceWatchOS : NSObject

@property (nonatomic, readwrite) NSTimeInterval requestInterval;
@property (nonatomic, readwrite) logWatchOSLevel logLevelWatchOS;
@property (nonatomic, readwrite) BOOL batchSupportEnabled;
@property (nonatomic, readwrite) NSInteger batchSupportSize;
@property (nonatomic, readwrite) NSInteger requestPerQueue;

/**
 MappIntelignece instance
 @brief Method to get a singleton instance of MappIntelligence
 @code
 MappIntelligenceWatchOS *mappIntelligenceWatchOS = [MappIntelligenceWatchOS shared];
 @endcode
 @return MappIntelligence an Instance Type of MappIntelligence.
 */
+ (nullable instancetype)shared;

/**
@brief Method to initialize tracking. Please specify your track domain and trackID.
@param trackIDs - Array of your trackIDs. The information can be provided by your account manager.
@param trackDomain - String value of your track domain. The information can be provided by your account manager.
@code
MappIntelligenceWatchOS.shared()?.initWithConfiguration([12345678, 8783291721], onTrackdomain: "www.mappIntelligence-trackDomain.com")
@endcode
*/
- (void)initWithConfiguration:(NSArray *_Nonnull)trackIDs
                    onTrackdomain:(NSString *_Nonnull)trackDomain;

/**
@brief Method which will track page event
@param event - page view event
@code
 let event = MIActionEvent(name: "TestAction")
 MappIntelligenceWatchOS.shared()?.trackEvent(event);
 @endcode
@return the error which may happen through process of tracking, if returns nil there is no error.
*/
- (NSError *_Nullable) trackPage:(MIPageViewEvent *_Nonnull) event;

/**
@brief Method which will track action event
@param event - action event
@code
 let event = MIActionEvent(name: "TestAction")
 MappIntelligenceWatchOS.shared()?.trackAction(event);
 @endcode
@return the error which may happen through process of tracking, if returns nil there is no error.
*/
- (NSError *_Nullable) trackAction:(MIActionEvent *_Nonnull) event;
/**
@brief Method to reset the MappIntelligence singleton. This method will set the default empty values for trackID and track domain. Please ensure to provide new trackIDs and track domain.
@code
MappIntelligenceWatchOS.shared()?.reset()
@endcode
*/
- (void)reset;

/**
@brief Method to opt-in for tracking. This enables tracking.
@code
 MappIntelligenceWatchOS.shared()?.optIn()
@endcode
 */
-(void) optIn;


/**
@brief Method to opt-out of tracking. In case of opt-out, no data will be sent to Mapp Intelligence anymore.
@param value - If set to true, all track requests currently stored in the database will be sent to MappIntelligence. If set to false, opt-out of tracking will be executed immediately and remaining data in the database will be lost.
@code
 MappIntelligenceWatchOS.shared()?.optOut(with: false, andSendCurrentData: false)
@endcode
 */
- (void)optOutAndSendCurrentData:(BOOL) value;

@end
