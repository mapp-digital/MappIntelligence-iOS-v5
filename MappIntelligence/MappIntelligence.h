//
//  Webrekk.h
//  Webrekk
//
//  Created by Stefan Stevanovic on 1/3/20.
//  Copyright © 2020 Mapp Digital US, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "PageViewEvent.h"
#import "ActionProperties.h"
#import "SessionProperties.h"
#import "UserProperties.h"

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
@param pageProperties - properties can contain parameters, categories and search terms.
@param sessionProperties - contains properties for session, each property can have multiple values
@param userProperties - customer related data
@code
 let params:[NSNumber:[String]] = [20: ["cp20Override", "cp21Override", "cp22Override"]]
 let categories:NSMutableDictionary = [10: ["test"]]
 let searchTerm = "testSearchTerm"
 let sessionProperties = SessionProperties(witProperties: [10: ["sessionpar1"]])
 let userProperties = UserProperties(customProperties:[20:["Test"]])

 MappIntelligence.shared()?.trackPage(with: self, pageProperties: PageProperties(pageParams: params, andWithPageCategory: categories, andWithSearch: searchTerm), sessionProperties: sessionProperties, userProperties: userProperties)
@endcode
@return Error in case of a failure. Returns nil if no error was detected.
*/
- (NSError *_Nullable)trackPageWithViewController:(UIViewController *_Nonnull)controller pageProperties:(PageProperties  *_Nullable)pageProperties sessionProperties:(SessionProperties *_Nullable) sessionProperties  userProperties: (UserProperties *_Nullable) userProperties ecommerceProperties: (EcommerceProperties *_Nullable) ecommerceProperties advertisementProperties: (AdvertisementProperties *_Nullable) advertisemementProperties;
#endif
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
 MappIntelligence.shared()?.trackPage(withName: customName, pageProperties: PageProperties(pageParams: params, andWithPageCategory: categories, andWithSearch: searchTerm), sessionProperties: sessionProperties, userProperties: userProperties ecommerceProperties: ecommerceProperties)
@endcode
@return Error that can happen while tracking. Returns nil if no error was detected.
*/
- (NSError *_Nullable)trackPageWithName: (NSString *_Nonnull) name pageProperties:(PageProperties  *_Nullable)pageProperties sessionProperties: (SessionProperties *_Nullable) sessionProperties  userProperties: (UserProperties *_Nullable) userProperties ecommerceProperties: (EcommerceProperties *_Nullable) ecommerceProperties advertisementProperties: (AdvertisementProperties *_Nullable) advertisemementProperties;

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
 MappIntelligence.shared()?.trackCustomEvent(withName: "TestAction", actionProperties: actionProperties, sessionProperties: sessionProperties, userProperties: userProperties ecommerceProperties: ecommerceProperties)
 @endcode
@return the error which may happen through process of tracking, if returns nil there is no error.
*/
- (NSError *_Nullable) trackCustomEventWithName:(NSString *_Nonnull) name actionProperties: (ActionProperties *_Nullable) actionProperties sessionProperties: (SessionProperties *_Nullable) sessionProperties  userProperties: (UserProperties *_Nullable) userProperties ecommerceProperties: (EcommerceProperties *_Nullable) ecommerceProperties advertisementProperties: (AdvertisementProperties *_Nullable) advertisemementProperties;


- (NSError *_Nullable) trackUrl:(NSURL *) url;

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

@end
