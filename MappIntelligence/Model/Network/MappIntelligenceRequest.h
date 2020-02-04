//
//  MappIntelligenceRequest.h
//  Webrekk
//
//  Created by Stefan Stevanovic on 1/3/20.
//  Copyright © 2020 Stefan Stevanovic. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, MappIntelligenceRequestKeyType) {
    kMappIntelligenceRequestKeyTypeRegister = 1,
    kMappIntelligenceRequestKeyTypeApplicationConfiguration,
    kMappIntelligenceRequestKeyTypeReportPushOpen,
    kMappIntelligenceRequestKeyTypeReportPushDissmis,
    kMappIntelligenceRequestKeyTypeActionSet,
    kMappIntelligenceRequestKeyTypeSessionReport,
    kMappIntelligenceRequestKeyTypeRichMessage,
    kMappIntelligenceRequestKeyTypeReportRichPushOpen,
    kMappIntelligenceRequestKeyTypeGetAppAndDeviceTags,
    kMappIntelligenceRequestKeyTypeUpdateAppAndDeviceTags,
    kMappIntelligenceRequestKeyTypeGetCustomFields,
    kMappIntelligenceRequestKeyTypeGetAlias,
    kMappIntelligenceRequestKeyTypeGeoConfiguration,
    kMappIntelligenceRequestKeyTypeGeoGetAllRegions,
    kMappIntelligenceRequestKeyTypeGeoReportCrossing,
    kMappIntelligenceRequestKeyTypeGeoUpdateGeoConf
};

@interface MappIntelligenceRequest : NSObject

- (void)addKeyedValues:(NSDictionary *)keyedValues forKeyType:(MappIntelligenceRequestKeyType)keyType;
@end
