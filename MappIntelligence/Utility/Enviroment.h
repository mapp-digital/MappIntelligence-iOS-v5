//
//  Enviroment.h
//  MappIntelligenceSDK
//
//  Created by Stefan Stevanovic on 3/6/20.
//  Copyright © 2020 Stefan Stevanovic. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Enviroment : NSObject

@property(nonatomic) NSString *appVersion;
@property(nonatomic) NSString *deviceModelString;
@property(nonatomic) NSString *operatingSystemName;
@property(nonatomic) NSString *operatingSystemVersionString;

@end

NS_ASSUME_NONNULL_END
