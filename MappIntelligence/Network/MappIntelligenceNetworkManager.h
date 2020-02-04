//
//  MappIntelligenceNetworkManager.h
//  Webrekk
//
//  Created by Stefan Stevanovic on 1/3/20.
//  Copyright © 2020 Stefan Stevanovic. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, MappIntelligenceNetworkManagerOperationType) {
    kMappIntelligenceNetworkManagerOperationTypeRegister = 1,
    kMappIntelligenceNetworkManagerOperationTypeApplicationConfiguration,
    kMappIntelligenceNetworkManagerOperationTypeReportPushOpen,
    kMappIntelligenceNetworkManagerOperationTypeReportPushClicked,
    kMappIntelligenceNetworkManagerOperationTypePushDismiss,
    kMappIntelligenceNetworkManagerOperationTypeSetActions,
    kMappIntelligenceNetworkManagerOperationTypeSession,
    kMappIntelligenceNetworkManagerOperationTypeMessages,
    kMappIntelligenceNetworkManagerOperationTypeTags,
    kMappIntelligenceNetworkManagerOperationTypeGetCustomFields,
    kMappIntelligenceNetworkManagerOperationTypeFeedback,
    kMappIntelligenceNetworkManagerOperationTypeMoreApps,
    kMappIntelligenceNetworkManagerOperationTypeGetAlias,
    kMappIntelligenceNetworkManagerOperationTypeGeoServicesConfiguration, // For getting the geo_conf
    kMappIntelligenceNetworkManagerOperationTypeGeoGetRegions,
    kMappIntelligenceNetworkManagerOperationTypeGeoReportRegion,
    kMappIntelligenceNetworkManagerOperationTypeGeoCheckIfConfigurationNeedsUpdate
};

typedef NS_ENUM(NSInteger, MappIntelligenceNetworkManagerEnvironment) {
    kMappIntelligenceNetworkManagerEnvironmentVirginia = 0,
    kMappIntelligenceNetworkManagerEnvironmentQALatest,
    kMappIntelligenceNetworkManagerEnvironmentQAStable,
    kMappIntelligenceNetworkManagerEnvironmentQA2,
    kMappIntelligenceNetworkManagerEnvironmentQA3,
    kMappIntelligenceNetworkManagerEnvironmentFrankfurt,
    kMappIntelligenceNetworkManagerEnvironmentQAFrankfurt,
    kMappIntelligenceNetworkManagerEnvironmentQAStaging,
    kMappIntelligenceNetworkManagerEnvironmentQAIntegration
};

typedef void(^MappIntelligenceNetworkManagerCompletionBlock)(NSError *error, id data);

@interface MappIntelligenceNetworkManager : NSObject

@property (nonatomic) MappIntelligenceNetworkManagerEnvironment environment;
@property (nonatomic, strong) NSString *sdkID;
@property (nonatomic, strong) NSString *preferedURL;

+ (instancetype)shared;

// for communication with Appoxee Servers, passing info and updates.
- (void)performNetworkOperation:(MappIntelligenceNetworkManagerOperationType)operation withData:(NSData *)dataArg andCompletionBlock:(MappIntelligenceNetworkManagerCompletionBlock)completionBlock;

// for communication with Appoxee Servers, passing info and updates.
- (NSDictionary *)performSynchronousNetworkOperation:(MappIntelligenceNetworkManagerOperationType)operation withData:(NSData *)data;

@end
