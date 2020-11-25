//
//  MIEnvironment.h
//  MappIntelligenceSDK
//
//  Created by Stefan Stevanovic on 3/6/20.
//  Copyright © 2020 Mapp Digital US, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MIEnvironment : NSObject

+ (NSString *)deviceModelString;
+ (NSString *)operatingSystemName;
+ (NSString *)operatingSystemVersionString;
+ (NSString *)appVersion;
+ (NSString *)buildVersion;
+ (BOOL)appUpdated;

@end

NS_ASSUME_NONNULL_END
