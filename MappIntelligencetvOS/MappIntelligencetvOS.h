//
//  MappIntelligencetvOS.h
//  MappIntelligencetvOS
//
//  Created by Stefan Stevanovic on 4/24/20.
//  Copyright © 2020 Mapp Digital US, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "PageProperties.h"
#import "SessionProperties.h"
#import "ActionProperties.h"
#import "UserProperties.h"
#import "EcommerceProperties.h"
#import "AdvertisementProperties.h"

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
@property (nonatomic, readwrite) NSInteger batchSupportSize;
@property (nonatomic, readwrite) NSInteger requestPerQueue;

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
@param pageProperties - properties can contain parameters, categories and search terms.
@param sessionProperties - contains properties for session, each property can have multiple values
@param userProperties - customer related data

@code
 let params:[NSNumber:[String]] = [20: ["cp20Override", "cp21Override", "cp22Override"]]
 let categories:NSMutableDictionary = [10: ["test"]]
 let searchTerm = "testSearchTerm"
 let sessionProperties = SessionProperties(witProperties: [10: ["sessionpar1"]])
 let userProperties = UserProperties(customProperties:[20:["Test"]])

 MappIntelligencetvOS.shared()?.trackPage(with: self, pageProperties: PageProperties(pageParams: params, andWithPageCategory: categories, andWithSearch: searchTerm), sessionProperties: sessionProperties, userProperties: userProperties)
@endcode
@return Error in case of a failure. Returns nil if no error was detected.
*/
- (NSError *_Nullable)trackPageWithViewController:(UIViewController *_Nonnull)controller pageProperties:(PageProperties  *_Nullable)pageProperties sessionProperties:(SessionProperties *_Nullable) sessionProperties userProperties: (UserProperties *_Nullable) userProperties ecommerceProperties: (EcommerceProperties *_Nullable) ecommerceProperties  advertisementProperties: (AdvertisementProperties *_Nullable) advertisemementProperties;

/**
@brief Method to track additional page information.
@param name - custom page name.
@param pageProperties - properties can contain details, groups and seach term.
@param sessionProperties - contains properties for session, each property can have multiple values
@param userProperties - customer related data

@code
 let customName = "the custom name of page"
 let params:[NSNumber:[String]] = [20: ["cp20Override", "cp21Override", "cp22Override"]]
 let categories:NSMutableDictionary = [10: ["test"]]
 let searchTerm = "testSearchTerm"
 let sessionProperties = SessionProperties(witProperties: [10: ["sessionpar1"]])
 let userProperties = UserProperties(customProperties:[20:["Test"]])
 let ecommerceProperties = EcommerceProperties()
 MappIntelligencetvOS.shared()?.trackPage(withName: customName, pageProperties: PageProperties(pageParams: params, andWithPageCategory: categories, andWithSearch: searchTerm), sessionProperties: sessionProperties, userProperties: userProperties ecommerceProperties: ecommerceProperties)
@endcode
@return Error that can happen while tracking. Returns nil if no error was detected.
*/
- (NSError *_Nullable)trackPageWithName: (NSString *_Nonnull) name pageProperties:(PageProperties  *_Nullable)pageProperties sessionProperties: (SessionProperties *_Nullable) sessionProperties userProperties: (UserProperties *_Nullable) userProperties ecommerceProperties: (EcommerceProperties *_Nullable) ecommerceProperties  advertisementProperties: (AdvertisementProperties *_Nullable) advertisemementProperties;

/**
@brief Method which will track action event created from action properties and session properties.
@param name - custom event name
@param actionProperties - action properties for one event, each property can have multiple values
@param sessionProperties - session properties for one event, each property can have multiple values
@param userProperties - customer related data

@code
 let actionProperties = ActionProperties(properties:  [20:["ck20Override","ck21Override"]])
 let sessionProperties = SessionProperties(properties: [10: ["sessionpar1"]])
 let userProperties = UserProperties(customProperties:[20:["Test"]])
 let ecommerceProperties = EcommerceProperties()
 MappIntelligencetvOS.shared()?.trackCustomEvent(withName: "TestAction", actionProperties: actionProperties, sessionProperties: sessionProperties, userProperties: userProperties ecommerceProperties: ecommerceProperties)
 @endcode
@return the error which may happen through process of tracking, if returns nil there is no error.
*/
- (NSError *_Nullable) trackCustomEventWithName:(NSString *_Nonnull) name  actionProperties: (ActionProperties *_Nullable) actionProperties sessionProperties: (SessionProperties *_Nullable) sessionProperties userProperties: (UserProperties *_Nullable) userProperties ecommerceProperties: (EcommerceProperties *_Nullable) ecommerceProperties  advertisementProperties: (AdvertisementProperties *_Nullable) advertisemementProperties;

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

@end
