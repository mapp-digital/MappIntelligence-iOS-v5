//
//  WebtrekkDataService.m
//  Webrekk
//
//  Created by Vladan Randjelovic on 15/01/2020.
//  Copyright © 2020 Stefan Stevanovic. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WebtrekkDataService.h"
#import "WebtrekkDefaultConfig.h"
#import "WebtrekkLogger.h"


@interface WebtrekkDataService()

@property WebtrekkDefaultConfig * defaultConfiguration;

@end

@implementation WebtrekkDataService: NSObject

- (id)init
{
    self = [super init];
    _defaultConfiguration = [[WebtrekkDefaultConfig alloc] init];
    return self;
}

+ (instancetype)shared
{
    static WebtrekkDataService *shared = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shared = [[WebtrekkDataService alloc] init];
    });
    
    return shared;
}

@end
