//
//  DeepLink.m
//  MappIntelligenceSDK
//
//  Created by Miroljub Stoilkovic on 06/11/2020.
//  Copyright © 2020 Mapp Digital US, LLC. All rights reserved.
//

#import "DeepLink.h"
#import "MappIntelligenceLogger.h"
#import "DefaultTracker.h"

NSString *const MappUrlDomain = @"MAPP_URLDomain";
NSString *const UrlErrorDescriptionInvalid = @"Url is invalid";

@implementation DeepLink

+ (NSError *_Nullable)trackFromUrl:(NSURL *_Nullable) url withMediaCode: (NSString *_Nullable) mediaCode{
    
    NSString *mediaCodeTag = mediaCode ?: @"wt_mc";
    AdvertisementProperties *advertisementProperties = [[AdvertisementProperties alloc] init];
    advertisementProperties.mediaCode = mediaCodeTag;
    
    NSMutableDictionary *campaignParameters = [[NSMutableDictionary alloc] init];
    NSURLComponents *components = [[NSURLComponents alloc] initWithURL:url resolvingAgainstBaseURL:YES];
    NSArray *queryItems = components.queryItems;

    for (NSURLQueryItem *item in queryItems) {
        if ([item.name isEqualToString:mediaCodeTag]) {
            advertisementProperties.campaignId = item.value;
        }
        if ([DeepLink isCampaignParameter: item.name]) {
            int idx = [[item.name substringFromIndex:5] intValue];
            NSNumber *key = [NSNumber numberWithInt:idx];
            NSArray *value = [NSArray arrayWithObject:item.value];
            if(key && idx) {
                [campaignParameters setObject:value forKey:key];
            }
        }
    }

    if (advertisementProperties.campaignId) {
        advertisementProperties.customProperties = campaignParameters;
        return [DeepLink saveToFile:advertisementProperties];
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

+ (NSError *_Nullable) saveToFile: (AdvertisementProperties *) campaign {
    NSError *error = nil;
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:campaign requiringSecureCoding:YES error:&error];
    [data writeToFile:[DeepLink filePath] options:NSDataWritingAtomic error:&error];
    return error;
}

+ (AdvertisementProperties *_Nullable) loadCampaign {
    NSError *error = nil;
    NSData *fileData = [NSData dataWithContentsOfFile: [DeepLink filePath]];
    AdvertisementProperties *properties = [NSKeyedUnarchiver unarchivedObjectOfClass:[AdvertisementProperties class] fromData:fileData error:&error];
    return properties;
}

+ (NSError *_Nullable) deleteCampaign {
    NSError *error = nil;
    [[NSFileManager defaultManager] removeItemAtPath:[DeepLink filePath] error:&error];
    return  error;
}

+ (NSString *) filePath {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docDir = [paths objectAtIndex: 0];
    NSString* campaignFilePath = [docDir stringByAppendingPathComponent: @"Campaign"];
    return campaignFilePath;
}

@end
