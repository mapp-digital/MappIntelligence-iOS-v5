//
//  WebtrekkRequest.h
//  Webrekk
//
//  Created by Stefan Stevanovic on 1/3/20.
//  Copyright © 2020 Stefan Stevanovic. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, WebtrekkRequestKeyType) {
    kWebtrekkRequestKeyTypeRegister = 1,
    kWebtrekkRequestKeyTypeApplicationConfiguration,
    kWebtrekkRequestKeyTypeReportPushOpen,
    kWebtrekkRequestKeyTypeReportPushDissmis,
    kWebtrekkRequestKeyTypeActionSet,
    kWebtrekkRequestKeyTypeSessionReport,
    kWebtrekkRequestKeyTypeRichMessage,
    kWebtrekkRequestKeyTypeReportRichPushOpen,
    kWebtrekkRequestKeyTypeGetAppAndDeviceTags,
    kWebtrekkRequestKeyTypeUpdateAppAndDeviceTags,
    kWebtrekkRequestKeyTypeGetCustomFields,
    kWebtrekkRequestKeyTypeGetAlias,
    kWebtrekkRequestKeyTypeGeoConfiguration,
    kWebtrekkRequestKeyTypeGeoGetAllRegions,
    kWebtrekkRequestKeyTypeGeoReportCrossing,
    kWebtrekkRequestKeyTypeGeoUpdateGeoConf
};

@interface WebtrekkRequest : NSObject

- (void)addKeyedValues:(NSDictionary *)keyedValues forKeyType:(WebtrekkRequestKeyType)keyType;
@end
