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
    return [[UIDevice currentDevice] systemName];
}

- (NSString *)operatingSystemVersionString {
    return [[[NSProcessInfo alloc] init] operatingSystemVersionString];
}

@end
