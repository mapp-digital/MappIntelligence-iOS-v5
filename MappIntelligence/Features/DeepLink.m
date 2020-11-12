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

@implementation DeepLink


//previous version sent with next request
+ (void)trackDeepLinkFrom:(NSUserActivity *) activity {
    if (activity.activityType == NSUserActivityTypeBrowsingWeb) {

        //extract properties
        NSURL *url = activity.webpageURL;
        NSURLComponents *components = [[NSURLComponents alloc] initWithURL:url resolvingAgainstBaseURL:YES];
        NSArray *queryItems = components.queryItems;
        
        NSString *campaignId;
        NSString *everId;
        //validate
        for (NSURLQueryItem *item in queryItems) {
            if ([item.name isEqualToString:@"eid"]) {
                
            }
            if ([item.name isEqualToString:@"mc"]) {
                campaignId = item.value;
            }
        }
        if (campaignId ) {
            ActionEvent *deepLinkEvent = [[ActionEvent alloc] init];
            deepLinkEvent.name = @"???";
            deepLinkEvent.pageName = @"???";
            AdvertisementProperties *advertisementProperties = [[AdvertisementProperties alloc] initWith: @"CampaignID???"];
            deepLinkEvent.advertisementProperties = advertisementProperties;
        } else {
            [MappIntelligenceLogger.shared logObj:@"Cannot succesfully parse deeplink url" forDescription: kMappIntelligenceLogLevelDescriptionDebug];
        }
    }
    
    //send action with campaign properties
}

+ (BOOL) validate:(NSString *) everId {
    
    return NO;
}


@end
