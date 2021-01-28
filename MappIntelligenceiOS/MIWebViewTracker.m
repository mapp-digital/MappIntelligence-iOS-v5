//
//  MIWebViewTracker.m
//  MappIntelligenceSDK
//
//  Created by Miroljub Stoilkovic on 08/12/2020.
//  Copyright © 2020 Mapp Digital US, LLC. All rights reserved.
//
#import "MIWebViewTracker.h"
#import "MIDefaultTracker.h"
#import "MappIntelligence.h"

NSString static *jsTag = @"MappIntelligenceiOSBridge";

@implementation MIWebViewTracker

+ (nullable instancetype)sharedInstance {

  static MIWebViewTracker *shared = nil;
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    shared = [[MIWebViewTracker alloc] init];
  });
  return shared;
}

-(WKWebViewConfiguration *_Nonnull) updateConfiguration: (WKWebViewConfiguration *_Nullable) configuration {
   
    WKUserScript *userScript = [[WKUserScript alloc] initWithSource: self.injectScript injectionTime:WKUserScriptInjectionTimeAtDocumentEnd forMainFrameOnly:YES];
    
    WKWebViewConfiguration *localConfiguration = configuration ?: [[WKWebViewConfiguration alloc] init];
    [localConfiguration.userContentController addUserScript:userScript];
    [localConfiguration.userContentController addScriptMessageHandler: self name:jsTag];
    return localConfiguration;
}

-(NSString *) injectScript {
    NSString *injectClass = [NSString stringWithFormat: @"var WebtrekkAndroidWebViewCallback ={};"
                             "WebtrekkAndroidWebViewCallback.trackCustomEvent = function(name, params){window.webkit.messageHandlers.%@.postMessage([\"action\",name, params])};"
                             "WebtrekkAndroidWebViewCallback.trackCustomPage = function(name, params){window.webkit.messageHandlers.%@.postMessage([\"page\",name, params])};"
                             "WebtrekkAndroidWebViewCallback.TAG = \"WebtrekkAndroidWebViewCallback\";"
                             "WebtrekkAndroidWebViewCallback.getUserAgent=function(){return \"%@\"};"
                             "WebtrekkAndroidWebViewCallback.getEverId = function(){return \"%@\"};",jsTag,jsTag, self.userAgent, self.everId];
    
    return injectClass;
}

- (NSString *) userAgent {
    return [[MIDefaultTracker sharedInstance] generateUserAgent];
}

- (NSString *) everId {
    return [[MIDefaultTracker sharedInstance] generateEverId];
}

- (void)userContentController:(nonnull WKUserContentController *)userContentController didReceiveScriptMessage:(nonnull WKScriptMessage *)message {
    
    if ([message.name isEqualToString:jsTag] && [message.body isKindOfClass:NSArray.class]) {
        if ([message.body[0] isEqualToString:@"page"]) {
            [self trackWebViewPageEventWith: message.body[1] parameters:message.body[2]];
        } else if ([message.body[0] isEqualToString:@"action"]) {
            [self trackWebViewActionEventWith: message.body[1] parameters:message.body[2]];
        }
    }
}

- (void) trackWebViewPageEventWith: (NSString *) name parameters: (NSString *) parameters {
    NSDictionary *params = [self getDict:parameters];
    [MappIntelligence.shared trackCustomPage:name trackingParams:params];
}

- (void) trackWebViewActionEventWith: (NSString *) name parameters: (NSString *) parameters {
    NSDictionary *params = [self getDict:parameters];
    [MappIntelligence.shared trackCustomEvent: name trackingParams:params];
}

- (NSDictionary *) getDict: (NSString *) data {
    NSError *jsonError;
    NSDictionary *json;
    @try {
        NSData *objectData = [data dataUsingEncoding:NSUTF8StringEncoding];
        json = [NSJSONSerialization JSONObjectWithData:objectData
                                              options:NSJSONReadingMutableContainers
                                                error:&jsonError];
    } @catch (NSException *exception) {
        return [[NSDictionary alloc] init];
    }
    return json;
}

@end
