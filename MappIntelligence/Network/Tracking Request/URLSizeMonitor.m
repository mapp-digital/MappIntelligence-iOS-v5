//
//  URLSizeMonitor.m
//  MappIntelligenceSDK
//
//  Created by Stefan Stevanovic on 3/7/20.
//  Copyright © 2020 Stefan Stevanovic. All rights reserved.
//

#import "URLSizeMonitor.h"

@interface URLSizeMonitor ()

@property int maxRequestSize;

@end

@implementation URLSizeMonitor

- (instancetype)init {
  self = [super init];
  if (self) {
    [self setCurrentProductSize:0];
    [self setCurrentRequestSize:0];
    _maxRequestSize = 8 * 1024;
  }
  return self;
}

- (void)addSize:(int)size {
  self.currentRequestSize += size;
}

@end
