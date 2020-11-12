//
//  DeepLink.m
//  MappIntelligenceSDK
//
//  Created by Miroljub Stoilkovic on 06/11/2020.
//  Copyright © 2020 Mapp Digital US, LLC. All rights reserved.
//

#import "DeepLink.h"
#import "ActionEvent.h"
#import "MappIntelligenceLogger.h"
#import "DefaultTracker.h"

NSString *const MappUrlDomain = @"MAPP_URLDomain";
NSString *const UrlErrorDescriptionInvalid = @"Url is invalid";

@implementation DeepLink

+ (NSError *)trackFrom:(NSURL *) url {
        
    AdvertisementProperties *advertisementProperties = [[AdvertisementProperties alloc] init];
    NSMutableDictionary *campaignParameters = [[NSMutableDictionary alloc] init];

    //extract properties
    NSURLComponents *components = [[NSURLComponents alloc] initWithURL:url resolvingAgainstBaseURL:YES];
    NSArray *queryItems = components.queryItems;

    for (NSURLQueryItem *item in queryItems) {
        if ([item.name isEqualToString:@"wt_mc"]) {
            advertisementProperties.campaignId = item.value;
        }
        if ([DeepLink isCampaignParameter: item.name]) {
            int idx = [[item.name substringFromIndex:5] intValue];
            NSNumber *key = [NSNumber numberWithInt:idx];
            NSArray *value = [NSArray arrayWithObject:item.value];
            if(key) {
                [campaignParameters setObject:value forKey:key];
            }
        }
    }
    if (advertisementProperties.campaignId) {
        ActionEvent *deepLinkEvent = [[ActionEvent alloc] init];
        advertisementProperties.customProperties = campaignParameters;
        deepLinkEvent.name = @"wt_ignore";
        deepLinkEvent.pageName = @"0";
        deepLinkEvent.advertisementProperties = advertisementProperties;
        return [[DefaultTracker sharedInstance] trackAction:deepLinkEvent];
    } else {
        [MappIntelligenceLogger.shared logObj:@"Cannot succesfully parse deeplink url. No campaign parameter!" forDescription: kMappIntelligenceLogLevelDescriptionDebug];
        return [[NSError alloc] initWithDomain:MappUrlDomain code:0 userInfo:@{NSLocalizedDescriptionKey:UrlErrorDescriptionInvalid}];
    }
}

+ (BOOL) isCampaignParameter: (NSString *) key {
    NSRegularExpression *regexp = [[NSRegularExpression alloc] initWithPattern:@"^wt_cc" options:0 error:nil];
    long n = [regexp numberOfMatchesInString:key options:0 range:NSMakeRange(0, key.length)];
    if (n > 0) {
        return YES;
    } else {
        return NO;
    }
}

@end
