//
//  APXRequest.h
//  AppoxeeSDK
//
//  Created by Raz Elkayam on 3/3/15.
//  Copyright (c) 2015 Appoxee. All rights reserved.
//
#if !TARGET_OS_WATCH &&  !TARGET_OS_TV
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

@interface Request : NSObject

- (void)addKeyedValues:(NSDictionary *)keyedValues forKeyType:(RequestKeyType)keyType;

@end
#endif
