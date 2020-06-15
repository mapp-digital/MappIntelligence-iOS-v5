//
//  Request.h
//  MappIntelligenceSDK
//
//  Created by Stefan Stevanovic on 10/06/2020.
//  Copyright © 2020 Mapp Digital US, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Parameter.h"

NS_ASSUME_NONNULL_BEGIN

@interface Request : NSObject

@property (nonatomic, strong, readwrite) NSNumber *uniqueId; // NSInteger
@property (nonatomic, strong, readwrite) NSString *domain; // string
@property (nonatomic, strong, readwrite) NSString *track_ids; // string
@property (nonatomic, strong, readwrite) NSNumber *status; // integer
@property (nonatomic, strong, readwrite) NSDate *date; // integer
@property (nonatomic, strong, readwrite) NSMutableArray<Parameter*> *parameters;

- (instancetype)initWithKeyedValues:(NSDictionary *)keyedValues;
- (instancetype)initWithParamters:(NSArray<NSURLQueryItem *> *)parameters andDomain: (NSString*) domain andTrackIds: (NSString*) trackids;
- (NSDictionary *)dictionaryWithValuesForKeys:(NSArray * _Nullable)keys;
- (void)print;

@end

NS_ASSUME_NONNULL_END
