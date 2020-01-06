//
//  WebtrekkNetworkManager.h
//  Webrekk
//
//  Created by Stefan Stevanovic on 1/3/20.
//  Copyright © 2020 Stefan Stevanovic. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, WebtrekkNetworkManagerOperationType) {
    kWebtrekkNetworkManagerOperationTypeRegister = 1,
    kWebtrekkNetworkManagerOperationTypeApplicationConfiguration,
    kWebtrekkNetworkManagerOperationTypeReportPushOpen,
    kWebtrekkNetworkManagerOperationTypeReportPushClicked,
    kWebtrekkNetworkManagerOperationTypePushDismiss,
    kWebtrekkNetworkManagerOperationTypeSetActions,
    kWebtrekkNetworkManagerOperationTypeSession,
    kWebtrekkNetworkManagerOperationTypeMessages,
    kWebtrekkNetworkManagerOperationTypeTags,
    kWebtrekkNetworkManagerOperationTypeGetCustomFields,
    kWebtrekkNetworkManagerOperationTypeFeedback,
    kWebtrekkNetworkManagerOperationTypeMoreApps,
    kWebtrekkNetworkManagerOperationTypeGetAlias,
    kWebtrekkNetworkManagerOperationTypeGeoServicesConfiguration, // For getting the geo_conf
    kWebtrekkNetworkManagerOperationTypeGeoGetRegions,
    kWebtrekkNetworkManagerOperationTypeGeoReportRegion,
    kWebtrekkNetworkManagerOperationTypeGeoCheckIfConfigurationNeedsUpdate
};

typedef NS_ENUM(NSInteger, WebtrekkNetworkManagerEnvironment) {
    kWebtrekkNetworkManagerEnvironmentVirginia = 0,
    kWebtrekkNetworkManagerEnvironmentQALatest,
    kWebtrekkNetworkManagerEnvironmentQAStable,
    kWebtrekkNetworkManagerEnvironmentQA2,
    kWebtrekkNetworkManagerEnvironmentQA3,
    kWebtrekkNetworkManagerEnvironmentFrankfurt,
    kWebtrekkNetworkManagerEnvironmentQAFrankfurt,
    kWebtrekkNetworkManagerEnvironmentQAStaging,
    kWebtrekkNetworkManagerEnvironmentQAIntegration
};

typedef void(^WebtrekkNetworkManagerCompletionBlock)(NSError *error, id data);

@interface WebtrekkNetworkManager : NSObject

@property (nonatomic) WebtrekkNetworkManagerEnvironment environment;
@property (nonatomic, strong) NSString *sdkID;
@property (nonatomic, strong) NSString *preferedURL;

+ (instancetype)shared;

// for communication with Appoxee Servers, passing info and updates.
- (void)performNetworkOperation:(WebtrekkNetworkManagerOperationType)operation withData:(NSData *)dataArg andCompletionBlock:(WebtrekkNetworkManagerCompletionBlock)completionBlock;

// for communication with Appoxee Servers, passing info and updates.
- (NSDictionary *)performSynchronousNetworkOperation:(WebtrekkNetworkManagerOperationType)operation withData:(NSData *)data;

@end
