
        
    
//
//  Enviroment.m
//  MappIntelligenceSDK
//
//  Created by Stefan Stevanovic on 3/6/20.
//  Copyright © 2020 Stefan Stevanovic. All rights reserved.
//

#import "Enviroment.h"
#import <UIKit/UIKit.h>
#import <sys/utsname.h>
#if TARGET_OS_WATCH
#import <WatchKit/WatchKit.h>
#endif

@implementation Enviroment

- (NSString *)appVersion {
  return NSBundle.mainBundle.infoDictionary[@"CFBundleShortVersionString"];
}

- (NSString *)deviceModelString {
#if TARGET_IPHONE_SIMULATOR
  return @"iPhone";
#else
  struct utsname systemInfo;
  uname(&systemInfo);
  return [NSString stringWithCString:systemInfo.machine
                            encoding:NSUTF8StringEncoding];
#endif
}

- (NSString *)operatingSystemName {
#if !TARGET_OS_WATCH
  return [[UIDevice currentDevice] systemName];
#else
    return [[WKInterfaceDevice currentDevice] systemName];
#endif
}

- (NSString *)operatingSystemVersionString {
  return [[[NSProcessInfo alloc] init] operatingSystemVersionString];
}

@end
