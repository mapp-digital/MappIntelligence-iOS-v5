//
//  APXClientDevice.h
//  AppoxeeSDK
//
//  Created by Raz Elkayam on 5/20/15.
//  Copyright (c) 2015 Appoxee. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface APXClientDevice : NSObject

@property (nonatomic, strong) NSString *sdkVersion; // 4.1
@property (nonatomic, strong) NSString *locale; // i.e en
@property (nonatomic, strong) NSString *timeZone; // Asia / Jerusalem
@property (nonatomic, strong) NSString *pushToken;
@property (nonatomic, strong) NSString *udid;
@property (nonatomic, strong) NSString *udidHashed;
@property (nonatomic, strong) NSString *osName;
@property (nonatomic, strong) NSString *osVersion;
@property (nonatomic, strong) NSString *hardwearType;
@property (nonatomic, strong) NSString *applicationID;
@property (nonatomic, getter = isInboxEnabled) BOOL inboxEnabled;
@property (nonatomic, getter = isPushEnabled) BOOL pushEnabled;

@end
