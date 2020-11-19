//
//  MIRequestData.h
//  MappIntelligenceSDK
//
//  Created by Stefan Stevanovic on 10/06/2020.
//  Copyright © 2020 Mapp Digital US, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Request.h"

NS_ASSUME_NONNULL_BEGIN

@interface MIRequestData : NSObject

@property (nonatomic, strong, readonly) NSMutableArray <Request *> *requests;

- (instancetype)initWithRequests:(NSArray <Request *> *)requests;
- (instancetype)initWithKeyedValues:(NSDictionary * _Nullable)keyedValues;
- (NSDictionary *)dictionaryWithValues;
- (void) sendAllRequestsWithCompletitionHandler: (void(^)(NSError* _Nullable))completionHandler;
- (NSString*)print;

@end

NS_ASSUME_NONNULL_END
