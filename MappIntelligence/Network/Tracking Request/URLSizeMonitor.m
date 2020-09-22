//
//  URLSizeMonitor.m
//  MappIntelligenceSDK
//
//  Created by Stefan Stevanovic on 3/7/20.
//  Copyright © 2020 Mapp Digital US, LLC. All rights reserved.
//

#import "URLSizeMonitor.h"
#import "MappIntelligenceLogger.h"

static NSInteger const max_parameter_length = 255;

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
    
    NSString *decodedParameters = [pParameter stringByRemovingPercentEncoding];
    if (decodedParameters.length > max_parameter_length) {
        [[MappIntelligenceLogger shared] logObj:@"Field p is more then 255 length.Normalize it by cutting to 255 length." forDescription:kMappIntelligenceLogLevelDescriptionWarning];
        NSString *restOfParams = [[NSString alloc] initWithFormat:@"%@,,0,%@,32,0,%.f,0,0,0", library, size, stamp];
        long pageNameLengthMax = max_parameter_length - restOfParams.length;
        NSString *decodedPage = [page stringByRemovingPercentEncoding];
        NSString *cutPage = [decodedPage substringToIndex: pageNameLengthMax];
        page = [cutPage stringByAddingPercentEncodingWithAllowedCharacters: [NSCharacterSet URLQueryAllowedCharacterSet]];
        pParameter = [[NSString alloc] initWithFormat:@"%@,%@,0,%@,32,0,%.f,0,0,0", library, page, size, stamp];
    }
 return pParameter;
}

+ (NSString *) getSizedValue: (NSString *) value forParameter: (NSString *)parameter {
    if (value.length > max_parameter_length) {
        [[MappIntelligenceLogger shared] logObj: [NSString stringWithFormat: @"Field %@ is more then 255 length.Normalize it by cutting to 255 length.", parameter] forDescription:kMappIntelligenceLogLevelDescriptionWarning];

        return [value substringToIndex: max_parameter_length];
    }
    return value;
}

@end
