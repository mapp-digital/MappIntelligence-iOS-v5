//
//  Webrekk.h
//  Webrekk
//
//  Created by Stefan Stevanovic on 1/3/20.
//  Copyright © 2020 Stefan Stevanovic. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface MappIntelligence : NSObject
{}
/**
 MappIntelignece instance
 @brief Method for gets a singleton instance of MappInteligence.
 <pre><code>
 MappIntelligence *mappIntelligence = [MappIntelligence shared];
 </code></pre>
 @return MappIntelligence an Instance Type of MappIntelligence.
 */
+ (nullable instancetype)shared;
-(void)trackPage:(UIViewController*_Nullable) controller;
+(void) setConfigurationWith: (NSDictionary *_Nullable) dictionary;
@end
