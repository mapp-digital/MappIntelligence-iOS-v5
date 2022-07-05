//
//  APXInterfaceService.h
//  AppoxeeSDK
//
//  Created by Raz Elkayam on 7/12/15.
//  Copyright (c) 2015 Appoxee. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

typedef NS_ENUM(NSInteger, APXInterfaceServiceOperation) {
    kAPXInterfaceServiceOperationOne = 1,
    kAPXInterfaceServiceOperationTwo,
    kAPXInterfaceServiceOperationThree,
};

typedef void(^APXInterfaceServiceCompletionBlock)(NSError * _Nullable error, id _Nullable data);
typedef void(^APXInterfaceServiceFetchBlock)(UIBackgroundFetchResult fetchResult);

@class APXInterfaceService;

@protocol APXInterfaceServiceFetchDelegate <NSObject>

@required;
- (void)interfaceService:(nonnull APXInterfaceService *)service performFetchWithCompletionHandler:(nullable APXInterfaceServiceFetchBlock)fetchBlock withCompletionBlock:(nullable APXInterfaceServiceCompletionBlock)completionBlock;

@end

@interface APXInterfaceService : NSObject

+ (nullable instancetype)shared;
@property (nonatomic, strong, readwrite, nullable) CLLocationManager * locationManager;

@property (nonatomic, weak, nullable) id <APXInterfaceServiceFetchDelegate> fetchDelegate;

@property (nonatomic, strong, readwrite, nullable) NSString *appID;
@property (nonatomic, readonly) BOOL isBackgroundFetchAvailable;
@property (nonatomic, readonly) BOOL isSilentPushAvailable;

- (void)performOperation:(APXInterfaceServiceOperation)operation withIdentifier:(nullable NSString *)identifier andData:(nullable NSDictionary *)args andCompletionBlock:(nullable APXInterfaceServiceCompletionBlock)completionBlock;

- (void)performFetchWithCompletionHandler:(nullable APXInterfaceServiceFetchBlock)fetchBlock andCompletionBlock:(nullable APXInterfaceServiceCompletionBlock)completionBlock;

+ (NSTimeInterval)timestamp;
+ (nonnull NSString *)stringTimestamp;

@end
