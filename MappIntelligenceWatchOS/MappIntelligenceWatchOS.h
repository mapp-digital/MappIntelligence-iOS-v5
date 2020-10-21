//
//  MappIntelligenceWatchOS.h
//  MappIntelligenceWatchOS
//
//  Created by Stefan Stevanovic on 3/24/20.
//  Copyright © 2020 Mapp Digital US, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PageProperties.h"
#import "SessionProperties.h"
#import "ActionProperties.h"
#import "UserProperties.h"

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
@brief Method to track additional page information.
@param name - custom page name.
@param pageProperties - pageProperties can contain details, groups and seach term.
@code
 let customName = "the custom name of page"
 let params:NSMutableDictionary = [20: ["cp20Override", "cp21Override", "cp22Override"]]
 let categories:NSMutableDictionary = [10: ["test"]]
 let searchTerm = "testSearchTerm"
 
 MappIntelligenceWatchOS.shared()?.trackPage(withName: customName, andWith: PageProperties(pageParams: params, andWithPageCategory: categories, andWithSearch: searchTerm))
@endcode
@return Error that can happen while tracking. Returns nil if no error was detected.
*/
- (NSError *_Nullable)trackPageWithName: (NSString *_Nonnull) name pageProperties:(PageProperties  *_Nullable)pageProperties sessionProperties: (SessionProperties *_Nullable) sessionProperties userProperties: (UserProperties *_Nullable) userProperties ;

/**
@brief Method which will track action event created from action properties and session properties.
@param name - custom event name
@param actionProperties - action properties for one event, each property can have multiple values
@param sessionProperties - session properties for one event, each property can have multiple values
@code
 let actionProperties = ActionProperties(properties:  [20:["ck20Override","ck21Override"]])
 let sessionProperties = SessionProperties(properties: [10: ["sessionpar1"]])
 MappIntelligenceWatchOS.shared()?.trackCustomEvent(withName: "TestAction", actionProperties: actionProperties, sessionProperties: sessionProperties)
 @endcode
@return the error which may happen through process of tracking, if returns nil there is no error.
*/
- (NSError *_Nullable) trackCustomEventWithName:(NSString *_Nonnull) name  actionProperties: (ActionProperties *_Nullable) actionProperties sessionProperties: (SessionProperties *_Nullable) sessionProperties userProperties: (UserProperties *_Nullable) userProperties ;


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
