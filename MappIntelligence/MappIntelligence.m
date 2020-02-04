//
//  Webrekk.m
//  Webrekk
//
//  Created by Stefan Stevanovic on 1/3/20.
//  Copyright © 2020 Stefan Stevanovic. All rights reserved.
//

#import "MappIntelligence.h"
#import "MappIntelligenceDataService.h"
#import "MappIntelligenceDefaultConfig.h"
#import "MappIntelligenceLogger.h"

@interface MappIntelligence()

@property MappIntelligenceDataService *dataService;

@property MappIntelligenceDefaultConfig * configuration;

@end

@implementation MappIntelligence
static MappIntelligence *sharedInstance = nil;
static MappIntelligenceDefaultConfig * config = nil;

+(id) sharedMappIntelligence {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

+(void) setConfigurationWith: (NSDictionary *) dictionary {
    NSData * dictData = [NSKeyedArchiver archivedDataWithRootObject:dictionary requiringSecureCoding:NO error:NULL];
    NSDictionary *dict = [NSKeyedUnarchiver unarchiveObjectWithData:dictData];
    config = [[MappIntelligenceDefaultConfig alloc] initWithDictionary: dict];
}

-(id) init {
    if (!sharedInstance) {
        sharedInstance = [super init];
        _dataService = [[MappIntelligenceDataService alloc]init];
        _configuration = [[MappIntelligenceDefaultConfig alloc] init];
    }
    return sharedInstance;
}

@end
