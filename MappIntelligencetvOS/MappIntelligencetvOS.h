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
 @code
  let params:NSMutableDictionary = [20: ["cp20Override", "cp21Override", "cp22Override"]]
  let categories:NSMutableDictionary = [10: ["test"]]
  let searchTerm = "testSearchTerm"
  MappIntelligencetvOS.shared()?.trackPage(with: self, andWith: PageProperties(pageParams: params, andWithPageCategory: categories, andWithSearch: searchTerm))
 @endcode
@param controller - current ui view controller.
@param properties - properties can contain parameters, categories and search terms.
@return Error in case of a failure. Returns nil if no error was detected.
*/
- (NSError *_Nullable)trackPageWithViewController:(UIViewController *_Nonnull)controller andWithPageProperties:(PageProperties  *_Nullable)properties;
/**
@brief Method to track additional page information.
@param name - custom page name.
@param properties - properties can contain details, groups and seach term.
@return Error that can happen while tracking. Returns nil if no error was detected.
 @code
   let customName = "the custom name of page"
   let params:NSMutableDictionary = [20: ["cp20Override", "cp21Override", "cp22Override"]]
   let categories:NSMutableDictionary = [10: ["test"]]
   let searchTerm = "testSearchTerm"
   MappIntelligencetvOS.shared()?.trackPage(withName: customName, andWith: PageProperties(pageParams: params, andWithPageCategory: categories, andWithSearch: searchTerm))
 @endcode
*/
- (NSError *_Nullable)trackPageWithName: (NSString *_Nonnull) name pageProperties:(PageProperties  *_Nullable) pageProperties sessionProperties: (SessionProperties *_Nullable) sessionProperties;
/**
@brief Method to reset the MappIntelligence singleton. This method will set the default empty values for trackID and track domain. Please ensure to provide new trackIDs and track domain.
@code
MappIntelligencetvOS.shared()?.reset()
@endcode
*/
- (void)reset;

@end
