
        
    
//
//  MIEnvironment.m
//  MappIntelligenceSDK
//
//  Created by Stefan Stevanovic on 3/6/20.
//  Copyright © 2020 Mapp Digital US, LLC. All rights reserved.
//

#import "MIEnvironment.h"
#import <UIKit/UIKit.h>
#import <sys/utsname.h>
#if TARGET_OS_WATCH
#import <WatchKit/WatchKit.h>
#endif

static NSString *const appVersonKey = @"kAppVersion";
static NSString *const buildVersonKey = @"kBuildVersion";

@implementation MIEnvironment

+ (NSString *)appVersion {
  return NSBundle.mainBundle.infoDictionary[@"CFBundleShortVersionString"];
}

+ (NSString *)deviceModelString {
#if TARGET_IPHONE_SIMULATOR
  return @"iPhone";
#else
  struct utsname systemInfo;
  uname(&systemInfo);
  return [NSString stringWithCString:systemInfo.machine
                            encoding:NSUTF8StringEncoding];
#endif
}

+ (NSString *)operatingSystemName {
#if TARGET_OS_WATCH
  return [[WKInterfaceDevice currentDevice] systemName]; 
#else
    return [[UIDevice currentDevice] systemName];
#endif
}

+ (NSString *)operatingSystemVersionString {
  return [[[NSProcessInfo alloc] init] operatingSystemVersionString];
}

+ (NSString *)buildVersion {
    return NSBundle.mainBundle.infoDictionary[@"CFBundleVersion"];
}

+ (BOOL)appUpdated {
    NSString *previousVersion = [[NSUserDefaults standardUserDefaults] stringForKey:appVersonKey];
    if (!previousVersion) {
        [[NSUserDefaults standardUserDefaults] setObject:MIEnvironment.appVersion forKey:appVersonKey];
        return NO;
    }
    if ([previousVersion isEqual:MIEnvironment.appVersion]) {
        return NO;
    } else {
        [[NSUserDefaults standardUserDefaults] setObject:MIEnvironment.appVersion forKey:appVersonKey];
        return YES;
    }
}
@end
