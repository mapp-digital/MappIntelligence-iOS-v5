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
#import "ActionEvent.h"

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

@property (nonatomic, readwrite) NSTimeInterval requestTimeout;
@property (nonatomic, readwrite) logLevel logLevel;
@property (nonatomic, readwrite) BOOL batchSupportEnabled;
@property (nonatomic, readwrite) NSInteger batchSupportSize;
/**
 MappIntelignece instance
 @brief Method for gets a singleton instance of MappInteligence.
 <pre><code>
 let mappInteligenceSingleton = MappIntelligence.shared()
 </code></pre>
 @return MappIntelligence an Instance Type of MappIntelligence.
 */
+ (nullable instancetype)shared;
+ (NSString *_Nonnull)version;
+ (NSString *_Nonnull)getUrl;
+ (NSString *_Nonnull)getId;

#if !TARGET_OS_WATCH
/**
@brief Method which will collect the name of current UIViewController, write request into database which will be sent to the the your tracking server.
<pre><code>
MappIntelligence.shared()?.trackPage(self)
</code></pre>
@return the error which may happen through process of tracking, if returns nil there is no error.
*/
- (NSError *_Nullable)trackPage:(UIViewController *_Nullable)controller;
#endif
/**
@brief Method which will track the name which you specify.
@param name - the name represented as a sting value which need to be track.
<pre><code>
MappIntelligence.shared()?.trackPageWith("testString")
</code></pre>
@return the error which may happen through process of tracking, if returns nil there is no error.
*/
- (NSError *_Nullable)trackPageWith:(NSString *_Nullable)name;
/**
@brief Method which will track page event which you create from page properties.
@param event - page event which can contain details, groups and seach term.
<pre><code>
MappIntelligence.shared()?.trackPageWithEvent(with: PageViewEvent(PageProperties([20: "cp20Override"], andWithGroup: nil, andWithSearch: "testSearchTerm")))
</code></pre>
@return the error which may happen through process of tracking, if returns nil there is no error.
*/
- (NSError *_Nullable)trackPageWithEvent:(PageViewEvent  *_Nullable)event;

/**
@brief Method which will track action event which you create from action properties and page properties.
@param event - action event which can contain details, groups and seach term.
<pre><code>
MappIntelligence.shared()?.trackActionWithEvent(with: PageViewEvent(PageProperties([20: "cp20Override"], andWithGroup: nil, andWithSearch: "testSearchTerm")))
</code></pre>
@return the error which may happen through process of tracking, if returns nil there is no error.
*/
- (NSError *_Nullable)trackActionWithEvent: (ActionEvent *_Nullable)event;

/**
@brief Method which will initialize your domain and track id which identify your tracking server where data will be stored.
@param trackIDs - array of numbers which represent your track ids for your tracking server, that information as domain also will be provided to you by your account manager.
@param trackDomain - string value which represent domain of your track server. For example: "www.mappIntelligence-trackDomain.com"
<pre><code>
MappIntelligence.shared()?.initWithConfiguration([12345678, 8783291721], onTrackdomain: "www.mappIntelligence-trackDomain.com")
</code></pre>
*/
- (void)initWithConfiguration:(NSArray *_Nonnull)trackIDs
                    onTrackdomain:(NSString *_Nonnull)trackDomain;
/**
@brief Method which will reset MappIntelligence singleton and allow you to create new one. This metod will set defaut empty value for domain and track ids so you must initialise it again with new values.
<pre><code>
MappIntelligence.shared()?.reset()
</code></pre>
*/
- (void)reset;
/**
@brief Method which will make opt out from MappIntelligence tracking server and will not send data anymore.
@param status - true will opt out, false will make opt in.
@param value - true - will send all request which is currently present in database, false will just opt out/in you but it will not send any data.
<pre><code>
MappIntelligence.shared()?.optOut(with: false, andSendCurrentData: false)
</code></pre>
 */
- (void)optOutWith:(BOOL) status andSendCurrentData:(BOOL) value;

//testable methods
- (void) printAllRequestFromDatabase;
- (void) removeRequestFromDatabaseWithID: (int)ID;

@end
