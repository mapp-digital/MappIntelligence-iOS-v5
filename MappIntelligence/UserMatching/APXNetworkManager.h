//
//  APXNetworkManager.h
//  AppoxeeSDK
//
//  Created by Raz Elkayam on 3/2/15.
//  Copyright (c) 2015 Appoxee. All rights reserved.
//
#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, NetworkManagerOperationType) {
    kAPXNetworkManagerOperationTypeRegister = 1,
    kAPXNetworkManagerOperationTypeApplicationConfiguration,
    kAPXNetworkManagerOperationTypeReportPushOpen,
    kAPXNetworkManagerOperationTypeSetActions,
    kAPXNetworkManagerOperationTypeSession,
    kAPXNetworkManagerOperationTypeMessages,
    kAPXNetworkManagerOperationTypeTags,
    kAPXNetworkManagerOperationTypeGetCustomFields,
    kAPXNetworkManagerOperationTypeFeedback,
    kAPXNetworkManagerOperationTypeMoreApps,
    kAPXNetworkManagerOperationTypeGetAlias,
    kAPXNetworkManagerOperationTypeGeoServicesConfiguration, // For getting the geo_conf
    kAPXNetworkManagerOperationTypeGeoGetRegions,
    kAPXNetworkManagerOperationTypeGeoReportRegion,
    kAPXNetworkManagerOperationTypeGeoCheckIfConfigurationNeedsUpdate
};

typedef NS_ENUM(NSInteger, NetworkManagerEnvironment) {
    kAPXNetworkManagerEnvironmentVirginia = 0,
    kAPXNetworkManagerEnvironmentQALatest,
    kAPXNetworkManagerEnvironmentQAStable,
    kAPXNetworkManagerEnvironmentQA2,
    kAPXNetworkManagerEnvironmentQA3,
    kAPXNetworkManagerEnvironmentFrankfurt,
    kAPXNetworkManagerEnvironmentQAFrankfurt,
    kAPXNetworkManagerEnvironmentQAStaging,
    kAPXNetworkManagerEnvironmentQAIntegration,
    kAPXNetworkManagerCustomURLNishant,
    kAPXNetworkManagerEnvironmentFrankfurtSanity
};

typedef void(^APXNetworkManagerCompletionBlock)(NSError *error, id data);

@interface MINetworkManager : NSObject

@property (nonatomic) NetworkManagerEnvironment environment;
@property (nonatomic, strong) NSString *sdkID;
@property (nonatomic, strong) NSString *preferedURL;

+ (instancetype)shared;

// for communication with Appoxee Servers, passing info and updates.
- (void)performNetworkOperation:(NetworkManagerOperationType)operation withData:(NSData *)dataArg andCompletionBlock:(APXNetworkManagerCompletionBlock)completionBlock;


@end
