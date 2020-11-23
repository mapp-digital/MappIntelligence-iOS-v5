//
//  MIDatabaseManager.h
//  MappIntelligenceSDK
//
//  Created by Stefan Stevanovic on 09/06/2020.
//  Copyright © 2020 Mapp Digital US, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MIRequest.h"

NS_ASSUME_NONNULL_BEGIN

@interface MIDatabaseManager : NSObject

typedef void(^StorageManagerCompletionHandler)(NSError *error, id _Nullable data);

+ (instancetype)shared;
- (BOOL)insertRequest:(MIRequest *)request;
- (NSError *)insertRequests:(NSArray *)requests;
- (void)fetchAllRequestsFromInterval:(double)interval  andWithCompletionHandler:(StorageManagerCompletionHandler)completionHandler;
- (BOOL)deleteRequest:(int)ID;
- (BOOL)deleteAllRequest;
- (void)removeOldRequestsWithCompletitionHandler: (StorageManagerCompletionHandler)completionHandler;
- (void)removeRequestsDB:(NSArray *)requestIds;
-(BOOL)updateStatusOfRequestWithId: (int) identifier andStatus: (int) status;
-(dispatch_queue_t)getExecutionQueue;
@end

NS_ASSUME_NONNULL_END
