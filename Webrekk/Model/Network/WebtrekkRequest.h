//
//  WebtrekkRequest.h
//  Webrekk
//
//  Created by Stefan Stevanovic on 1/3/20.
//  Copyright © 2020 Stefan Stevanovic. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, APXRequestKeyType) {
    kAPXRequestKeyTypeRegister = 1,
    kAPXRequestKeyTypeApplicationConfiguration,
    kAPXRequestKeyTypeReportPushOpen,
    kAPXRequestKeyTypeReportPushDissmis,
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

@interface WebtrekkRequest : NSObject

- (void)addKeyedValues:(NSDictionary *)keyedValues forKeyType:(APXRequestKeyType)keyType;
@end
