//
//  PageProperties.h
//  MappIntelligenceSDK
//
//  Created by Stefan Stevanovic on 17/07/2020.
//  Copyright © 2020 Mapp Digital US, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TrackerRequest.h"

NS_ASSUME_NONNULL_BEGIN

@interface PageProperties : NSObject

//@property (nullable) NSString* name;
@property (nullable) NSString* internalSearch;
//@property id viewControllerType;
//@property (nonatomic) NSString* url;
@property (nullable) NSMutableDictionary* details;
@property (nullable) NSMutableDictionary* groups;

-(instancetype)initWith: (NSMutableDictionary* _Nullable) details andWithGroup: (NSMutableDictionary* _Nullable) groups andWithSearch: (NSString* _Nullable)internalSearch;
-(NSMutableArray<NSURLQueryItem*>*)asQueryItemsFor: (TrackerRequest*)request;

@end

NS_ASSUME_NONNULL_END
