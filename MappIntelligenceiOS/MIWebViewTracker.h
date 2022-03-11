//
//  MIWebViewTracker.h
//  MappIntelligenceSDK
//
//  Created by Miroljub Stoilkovic on 08/12/2020.
//  Copyright © 2020 Mapp Digital US, LLC. All rights reserved.
//
#import <Foundation/Foundation.h>
#import <WebKit/WebKit.h>


NS_ASSUME_NONNULL_BEGIN

@interface MIWebViewTracker : NSObject<WKScriptMessageHandler>

+ (nullable instancetype)sharedInstance;
-(WKWebViewConfiguration *_Nonnull) updateConfiguration: (WKWebViewConfiguration *_Nullable) configuration;

@end

NS_ASSUME_NONNULL_END
