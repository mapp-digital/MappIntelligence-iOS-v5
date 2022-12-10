//
//  APXRichMessage.h
//  AppoxeeSDK
//
//  Created by Raz Elkayam on 3/19/15.
//  Copyright (c) 2015 Appoxee. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface APXRichMessage : NSObject <NSCoding>

/*!
 * The unique identifier of the message.
 */
@property (nonatomic, readonly) NSInteger uniqueID;

/*!
 * The post date of the message, in UTC.
 */
@property (nonatomic, readonly) NSDate *postDateUTC;

/*!
 * The post date of the message, in device local time.
 */
@property (nonatomic, strong, readonly) NSDate *postDate;

/*!
 * The title of the message.
 */
@property (nonatomic, strong, readonly) NSString *title;

/*!
 * The content of the message.
 */
@property (nonatomic, strong, readonly) NSString *content;

/*!
 * Indicates if the message is read.
 */
@property (nonatomic, readonly) BOOL isRead;

/*!
 * The link of the message. Implicitly marks message as read.
 */
@property (nonatomic, strong, readonly) NSString *messageLink;

/*!
 * Init with keyed values.
 */
- (id)initWithKeyedValues:(NSDictionary *)keyedValues;

/*!
 * Init with keyed values and a 'read' indication.
 */
- (id)initWithKeyedValues:(NSDictionary *)keyedValues andMarkAsRead:(BOOL)isRead;

@end
