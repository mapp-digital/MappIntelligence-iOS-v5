//
//  MIRequestData.h
//  MappIntelligenceSDK
//
//  Created by Stefan Stevanovic on 10/06/2020.
//  Copyright © 2020 Mapp Digital US, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MIRequest.h"

NS_ASSUME_NONNULL_BEGIN

@interface MIRequestData : NSObject

@property (nonatomic, strong, readonly) NSMutableArray <MIRequest *> *requests;

- (instancetype)initWithRequests:(NSArray <MIRequest *> *)requests;
- (instancetype)initWithKeyedValues:(NSDictionary * _Nullable)keyedValues;
- (NSDictionary *)dictionaryWithValues;
- (void) sendAllRequestsWithCompletitionHandler: (void(^)(NSError* _Nullable))completionHandler;
- (NSString*)print;

@end

NS_ASSUME_NONNULL_END
