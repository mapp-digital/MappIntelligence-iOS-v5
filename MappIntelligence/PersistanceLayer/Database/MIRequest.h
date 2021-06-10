//
//  Request.h
//  MappIntelligenceSDK
//
//  Created by Stefan Stevanovic on 10/06/2020.
//  Copyright © 2020 Mapp Digital US, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MIParameter.h"

typedef NS_ENUM(NSInteger, REQUEST_STATUS) {
    ACTIVE = 1,
    SENT,
    FAILED
};

NS_ASSUME_NONNULL_BEGIN

@interface MIRequest : NSObject

@property (nonatomic, strong, readwrite) NSNumber *uniqueId; // NSInteger
@property (nonatomic, strong, readwrite) NSString *domain; // string
@property (nonatomic, strong, readwrite) NSString *track_ids; // string
@property (nonatomic, readwrite)  REQUEST_STATUS status; // integer
@property (nonatomic, strong, readwrite) NSDate *date; // integer
@property (nonatomic, strong, readwrite) NSMutableArray<MIParameter*> *parameters;

- (instancetype)initWithKeyedValues:(NSDictionary *)keyedValues;
- (instancetype)initWithParamters:(NSArray<NSURLQueryItem *> *)parameters andDomain: (NSString*) domain andTrackIds: (NSString*) trackids;
- (NSDictionary *)dictionaryWithValuesForKeys;
- (NSString*)print;
- (NSURL*)urlForBatchSupprot: (BOOL)option;

@end

NS_ASSUME_NONNULL_END
