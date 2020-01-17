//
//  Webrekk.m
//  Webrekk
//
//  Created by Stefan Stevanovic on 1/3/20.
//  Copyright © 2020 Stefan Stevanovic. All rights reserved.
//

#import "Webtrekk.h"

@implementation Webtrekk
static Webtrekk *sharedInstance = nil;

+(id) sharedWebtrek {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

-(id) init {
    if (!sharedInstance) {
        sharedInstance = [super init];
    }
    return sharedInstance;
}

@end
