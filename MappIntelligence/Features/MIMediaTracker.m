//
//  MIMediaTracker.m
//  MappIntelligenceSDK
//
//  Created by Miroljub Stoilkovic on 08/01/2021.
//  Copyright © 2021 Mapp Digital US, LLC. All rights reserved.
//

#import "MIMediaTracker.h"

@implementation MIMediaTracker

+ (nullable instancetype)sharedInstance {

  static MIWebViewTracker *shared = nil;
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    shared = [[MIWebViewTracker alloc] init];
  });
  return shared;
}

@end
