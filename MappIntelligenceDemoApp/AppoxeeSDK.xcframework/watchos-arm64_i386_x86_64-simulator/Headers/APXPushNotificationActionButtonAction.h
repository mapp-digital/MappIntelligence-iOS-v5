//
//  APXPushNotificationActionButtonAction.h
//  AppoxeeSDK
//
//  Created by Raz Elkayam on 3/18/15.
//  Copyright (c) 2015 Appoxee. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, APXPushNotificationActionButtonTodo) {
    kAPXPushNotificationActionButtonActionTodoSet = 1,
    kAPXPushNotificationActionButtonActionTodoRemove,
    kAPXPushNotificationActionButtonActionTodoIncrement,
    kAPXPushNotificationActionButtonActionTodoOpenURLScheme,
    kAPXPushNotificationActionButtonActionTodoOpenWebSite,
    kAPXPushNotificationActionButtonActionTodoOpenAppStore,
    kAPXPushNotificationActionButtonActionTodoOpenViewController
};

typedef NS_ENUM(NSInteger, APXPushNotificationActionButtonType) {
    kAPXPushNotificationActionButtonActionTypeCustom = 1,
    kAPXPushNotificationActionButtonActionTypeTag
};

@interface APXPushNotificationActionButtonAction : NSObject

@property (nonatomic, strong) NSString *name;
@property (nonatomic) APXPushNotificationActionButtonTodo todo;
@property (nonatomic) APXPushNotificationActionButtonType type;
@property (nonatomic, strong) NSString *value; // holds the value for any ToDo action

- (id)initWithKeyedValues:(NSDictionary *)keyedValues;

@end