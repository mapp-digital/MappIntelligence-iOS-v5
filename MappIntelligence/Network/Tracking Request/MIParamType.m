//
//  MIParamType.m
//  MappIntelligenceSDK
//
//  Created by Miroljub Stoilkovic on 17/12/2020.
//  Copyright © 2020 Mapp Digital US, LLC. All rights reserved.
//

#import "MIParamType.h"

@implementation MIParamType

+(NSString *)pageParam {
    return @"cp";
}
+(NSString *)pageCategory {
    return @"cg";
}
+(NSString *)ecommerceParam {
    return @"cb";
}
+(NSString *)productCategory {
    return @"ca";
}
+(NSString *)eventParam {
    return @"ck";
}
+(NSString *)campaignParam {
    return @"cc";
}
+(NSString *)sessionParam {
    return @"cs";
}
+(NSString *)urmCategory {
    return @"uc";
}

+(NSString *) createCustomParam:(NSString *) type value: (NSInteger) value{
    return [NSString stringWithFormat:@"%@%ld", type, (long)value];
}

@end
