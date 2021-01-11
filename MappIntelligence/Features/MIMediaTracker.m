//
//  MIMediaTracker.m
//  MappIntelligenceSDK
//
//  Created by Miroljub Stoilkovic on 08/01/2021.
//  Copyright © 2021 Mapp Digital US, LLC. All rights reserved.
//

#import "MIMediaTracker.h"


@interface MIMediaTracker ()
@property NSTimeInterval lastRequest;
@end

@implementation MIMediaTracker

+ (nullable instancetype)sharedInstance {

  static MIMediaTracker *shared = nil;
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    shared = [[MIMediaTracker alloc] init];
  });
  return shared;
}

-(BOOL) shouldTrack: (MIMediaEvent *) event {
    return NO;
}

@end
