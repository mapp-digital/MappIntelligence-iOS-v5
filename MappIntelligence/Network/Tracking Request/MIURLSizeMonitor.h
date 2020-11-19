//
//  MIURLSizeMonitor.h
//  MappIntelligenceSDK
//
//  Created by Stefan Stevanovic on 3/7/20.
//  Copyright © 2020 Mapp Digital US, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MIURLSizeMonitor : NSObject

@property int currentRequestSize;
@property int currentProductSize;

- (void)addSize:(int)size;
- (NSString *)cutPParameterLegth:(NSString *)library
                        pageName:(NSString *)page
                   andScreenSize:(NSString *)size
                    andTimeStamp:(double)stamp;

@end

NS_ASSUME_NONNULL_END
