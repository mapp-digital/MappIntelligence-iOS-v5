//
//  URLSizeMonitor.m
//  MappIntelligenceSDK
//
//  Created by Stefan Stevanovic on 3/7/20.
//  Copyright © 2020 Mapp Digital US, LLC. All rights reserved.
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

- (NSString *)cutPParameterLegth:(NSString *)library
                        pageName:(NSString *)page
                   andScreenSize:(NSString *)size
                    andTimeStamp:(double)stamp {
  NSString *pParameter = [[NSString alloc]
      initWithFormat:@"%@,%@,0,%@,32,0,%.f,0,0,0", library, page, size, stamp];
  NSString *cuttedPage = page;
  if ([pParameter length] > 255) {
    unsigned long treshold = [pParameter length] - 255;
    unsigned long lastIndex = [page length] - treshold;
    cuttedPage = [page substringToIndex:lastIndex];
  }
  pParameter =
      [[NSString alloc] initWithFormat:@"%@,%@,0,%@,32,0,%.f,0,0,0", library,
                                       cuttedPage, size, stamp];
  return pParameter;
}

@end
