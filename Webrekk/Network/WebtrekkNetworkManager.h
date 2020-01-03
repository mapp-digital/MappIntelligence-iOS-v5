//
//  WebtrekkNetworkManager.h
//  Webrekk
//
//  Created by Stefan Stevanovic on 1/3/20.
//  Copyright © 2020 Stefan Stevanovic. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, APXNetworkManagerOperationType) {
    kAPXNetworkManagerOperationTypeRegister = 1,
    kAPXNetworkManagerOperationTypeApplicationConfiguration,
    kAPXNetworkManagerOperationTypeReportPushOpen,
    kAPXNetworkManagerOperationTypeReportPushClicked,
    kAPXNetworkManagerOperationTypePushDismiss,
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

typedef NS_ENUM(NSInteger, APXNetworkManagerEnvironment) {
    kAPXNetworkManagerEnvironmentVirginia = 0,
    kAPXNetworkManagerEnvironmentQALatest,
    kAPXNetworkManagerEnvironmentQAStable,
    kAPXNetworkManagerEnvironmentQA2,
    kAPXNetworkManagerEnvironmentQA3,
    kAPXNetworkManagerEnvironmentFrankfurt,
    kAPXNetworkManagerEnvironmentQAFrankfurt,
    kAPXNetworkManagerEnvironmentQAStaging,
    kAPXNetworkManagerEnvironmentQAIntegration
};

typedef void(^APXNetworkManagerCompletionBlock)(NSError *error, id data);

@interface WebtrekkNetworkManager : NSObject

@property (nonatomic) APXNetworkManagerEnvironment environment;
@property (nonatomic, strong) NSString *sdkID;
@property (nonatomic, strong) NSString *preferedURL;

+ (instancetype)shared;

// for communication with Appoxee Servers, passing info and updates.
- (void)performNetworkOperation:(APXNetworkManagerOperationType)operation withData:(NSData *)dataArg andCompletionBlock:(APXNetworkManagerCompletionBlock)completionBlock;

// for communication with Appoxee Servers, passing info and updates.
- (NSDictionary *)performSynchronousNetworkOperation:(APXNetworkManagerOperationType)operation withData:(NSData *)data;

@end
