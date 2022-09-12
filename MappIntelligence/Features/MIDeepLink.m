//
//  DeepLink.m
//  MappIntelligenceSDK
//
//  Created by Miroljub Stoilkovic on 06/11/2020.
//  Copyright © 2020 Mapp Digital US, LLC. All rights reserved.
//

#import "MIDeepLink.h"
#import "MappIntelligenceLogger.h"
#import "MIDefaultTracker.h"

NSString *const MappUrlDomain = @"MAPP_URLDomain";
NSString *const UrlErrorDescriptionInvalid = @"Url is invalid";

@implementation MIDeepLink

+ (NSError *_Nullable)trackFromUrl:(NSURL *_Nullable) url withMediaCode: (NSString *_Nullable) mediaCode{
    
    NSString *mediaCodeTag = mediaCode ?: @"wt_mc";
    MICampaignParameters *campaignProperties = [[MICampaignParameters alloc] init];
    campaignProperties.mediaCode = mediaCodeTag;
    
    NSArray *queryItems = [[NSArray alloc] init];
    NSMutableDictionary *campaignParameters = [[NSMutableDictionary alloc] init];
    @try {
        NSURLComponents *components = [[NSURLComponents alloc] initWithURL:url resolvingAgainstBaseURL:YES];
        queryItems = components.queryItems;
    } @catch (NSException *exception) {
        [MappIntelligenceLogger.shared logObj:@"Url is invalid!" forDescription: kMappIntelligenceLogLevelDescriptionError];
    }
    

    for (NSURLQueryItem *item in queryItems) {
        if ([item.name isEqualToString:mediaCodeTag]) {
            campaignProperties.campaignId = item.value;
        }
        if ([MIDeepLink isCampaignParameter: item.name]) {
            int idx = 2;
            if (item.name.length >4) {
                idx = [[item.name substringFromIndex:5] intValue];
            } else {
                idx = [[item.name substringFromIndex:2] intValue];
            }
            NSNumber *key = [NSNumber numberWithInt:idx];
//            NSArray *value = [NSArray arrayWithObject:item.value];
            if(key && idx) {
                [campaignParameters setObject:item.value forKey:key];
            }
        }
    }

    if (campaignProperties.campaignId) {
        campaignProperties.customParameters = campaignParameters;
        return [MIDeepLink saveToFile:campaignProperties];
    } else {
        [MappIntelligenceLogger.shared logObj:@"Cannot succesfully parse deeplink url. No campaign parameter!" forDescription: kMappIntelligenceLogLevelDescriptionDebug];
        return [[NSError alloc] initWithDomain:MappUrlDomain code:0 userInfo:@{NSLocalizedDescriptionKey:UrlErrorDescriptionInvalid}];
    }
}

+ (BOOL) isCampaignParameter: (NSString *) key {
    NSRegularExpression *regexp = [[NSRegularExpression alloc] initWithPattern:@"^cc" options:0 error:nil];
    long n = [regexp numberOfMatchesInString:key options:0 range:NSMakeRange(0, key.length)];
    if (n > 0) {
        return YES;
    } else {
        return NO;
    }
}

+ (NSError *_Nullable) saveToFile: (MICampaignParameters *) campaign {
    NSError *error = nil;
    if (@available(iOS 11.0, *)) {
        NSData *data = [NSKeyedArchiver archivedDataWithRootObject:campaign requiringSecureCoding:YES error:&error];
        [data writeToFile:[MIDeepLink filePath] options:NSDataWritingAtomic error:&error];
    } else {
        // Fallback on earlier versions
        NSData *data = [NSKeyedArchiver archivedDataWithRootObject:campaign requiringSecureCoding:NO error:NULL];
        [data writeToFile:[MIDeepLink filePath] options:NSDataWritingAtomic error:&error];
    }
    return error;
}

+ (MICampaignParameters *_Nullable) loadCampaign {
    NSError *error = nil;
    NSData *fileData = [NSData dataWithContentsOfFile: [MIDeepLink filePath]];
    if (fileData == nil) {
        return nil;
    }
    if (@available(iOS 11.0, *)) {
        MICampaignParameters *properties = [NSKeyedUnarchiver unarchivedObjectOfClass:[MICampaignParameters class] fromData:fileData error:&error];
        return properties;
    } else {
        // Fallback on earlier versions
        MICampaignParameters *properties = [NSKeyedUnarchiver unarchivedObjectOfClass:[MICampaignParameters class] fromData:fileData error:NULL];
        return properties;
    }
}

+ (NSError *_Nullable) deleteCampaign {
    NSError *error = nil;
    [[NSFileManager defaultManager] removeItemAtPath:[MIDeepLink filePath] error:&error];
    return  error;
}

+ (NSString *) filePath {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docDir = [paths objectAtIndex: 0];
    NSString* campaignFilePath = [docDir stringByAppendingPathComponent: @"Campaign"];
    return campaignFilePath;
}

@end
