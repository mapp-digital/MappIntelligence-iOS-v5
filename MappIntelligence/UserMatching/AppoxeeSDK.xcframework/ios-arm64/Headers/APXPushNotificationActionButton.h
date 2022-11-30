//
//  APXPushNotificationActionButton.h
//  AppoxeeSDK
//
//  Created by Raz Elkayam on 3/18/15.
//  Copyright (c) 2015 Appoxee. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "APXPushNotificationActionButtonAction.h"

@interface APXPushNotificationActionButton : NSObject

@property (nonatomic, strong) APXPushNotificationActionButtonAction *foregroundActionButtonAction; // of Type APXPushNotificationActionButtonAction
@property (nonatomic, strong) NSArray *backgroundActions; // of Type APXPushNotificationActionButtonAction

- (id)initWithKeyedValues:(NSDictionary *)keyedValues;

@end
