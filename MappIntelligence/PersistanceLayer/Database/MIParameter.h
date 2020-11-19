//
//  MIParameter.h
//  MappIntelligenceSDK
//
//  Created by Stefan Stevanovic on 10/06/2020.
//  Copyright © 2020 Mapp Digital US, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MIParameter : NSObject

@property (nonatomic, strong, readwrite) NSNumber *uniqueId; // NSInteger
@property (nonatomic, strong, readwrite) NSString *name; // double
@property (nonatomic, strong, readwrite) NSString *value; // double
@property (nonatomic, strong, readwrite) NSNumber *request_uniqueId; // double, Meters

- (instancetype)initWithKeyedValues:(NSDictionary *)keyedValues;
- (NSDictionary *)dictionaryWithValuesForKeys;
- (NSString*)print;

@end

NS_ASSUME_NONNULL_END
