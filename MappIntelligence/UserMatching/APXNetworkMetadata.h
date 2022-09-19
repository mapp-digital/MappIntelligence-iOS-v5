//
//  APXNetworkMetadata.h
//  AppoxeeSDK
//
//  Created by Raz Elkayam on 3/4/15.
//  Copyright (c) 2015 Appoxee. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NetworkMetadata : NSObject

@property (nonatomic, getter = isSuccess) BOOL succes;
@property (nonatomic) NSInteger code;
@property (nonatomic, strong) NSString *message;

- (id)initWithKeyedValues:(NSDictionary *)keyedValues;

@end
