//
//  MappIntelligenceDataService.m
//  Webrekk
//
//  Created by Vladan Randjelovic on 15/01/2020.
//  Copyright © 2020 Stefan Stevanovic. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MappIntelligenceDataService.h"
//#import "MappIntelligenceLogger.h"


@interface MappIntelligenceDataService()


@end

@implementation MappIntelligenceDataService: NSObject

- (id)init
{
    self = [super init];
    return self;
}

+ (instancetype)shared
{
    static MappIntelligenceDataService *shared = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shared = [[MappIntelligenceDataService alloc] init];
    });
    
    return shared;
}

@end
