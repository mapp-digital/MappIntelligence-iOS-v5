//
//  APXRequest.h
//  AppoxeeSDK
//
//  Created by Raz Elkayam on 3/3/15.
//  Copyright (c) 2015 Appoxee. All rights reserved.
//
#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, RequestKeyType) {
    kAPXRequestKeyTypeRegister = 1,
    kAPXRequestKeyTypeApplicationConfiguration,
    kAPXRequestKeyTypeReportPushOpen,
    kAPXRequestKeyTypeActionSet,
    kAPXRequestKeyTypeSessionReport,
    kAPXRequestKeyTypeRichMessage,
    kAPXRequestKeyTypeReportRichPushOpen,
    kAPXRequestKeyTypeGetAppAndDeviceTags,
    kAPXRequestKeyTypeUpdateAppAndDeviceTags,
    kAPXRequestKeyTypeGetCustomFields,
    kAPXRequestKeyTypeGetAlias,
    kAPXRequestKeyTypeGeoConfiguration,
    kAPXRequestKeyTypeGeoGetAllRegions,
    kAPXRequestKeyTypeGeoReportCrossing,
    kAPXRequestKeyTypeGeoUpdateGeoConf
};

@interface MIUMRequest : NSObject

- (void)addKeyedValues:(NSDictionary *)keyedValues forKeyType:(RequestKeyType)keyType;

@end
