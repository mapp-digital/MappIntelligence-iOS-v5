//
//  APXPushNotificationAction.h
//  AppoxeeSDK
//
//  Created by Raz Elkayam on 3/18/15.
//  Copyright (c) 2015 Appoxee. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "APXPushNotificationActionButton.h"

@interface APXPushNotificationAction : NSObject

@property (nonatomic, getter = isAppoxeeCategory, readonly) BOOL appoxeeCategory;
@property (nonatomic, strong, readonly) NSString *categoryName;
@property (nonatomic, strong, readonly) NSArray <APXPushNotificationActionButton *> *actionButtons;

- (id)initWithKeyedValues:(NSDictionary *)keyedValues;

@end
