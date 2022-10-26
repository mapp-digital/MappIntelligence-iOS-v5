//
//  MIDeepLink.m
//  MappIntelligenceTests
//
//  Created by Stefan Stevanovic on 25.10.22..
//  Copyright © 2022 Mapp Digital US, LLC. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "MIDeepLink.h"

@interface MIDeepLinkTests : XCTestCase
- (NSError *_Nullable) saveToFile: (MICampaignParameters *) campaign;

@end

@implementation MIDeepLinkTests

- (void)setUp {
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
}

- (NSError *_Nullable) saveToFile: (MICampaignParameters *) campaign {
    NSError *error = nil;
    if (@available(iOS 11.0, *)) {
        NSData *data = [NSKeyedArchiver archivedDataWithRootObject:campaign requiringSecureCoding:YES error:&error];
        [data writeToFile:[self filePath] options:NSDataWritingAtomic error:&error];
    } else {
        // Fallback on earlier versions
        NSData *data = [NSKeyedArchiver archivedDataWithRootObject:campaign requiringSecureCoding:NO error:NULL];
        [data writeToFile:[self filePath] options:NSDataWritingAtomic error:&error];
    }
    return error;
}

- (NSString *) filePath {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docDir = [paths objectAtIndex: 0];
    NSString* campaignFilePath = [docDir stringByAppendingPathComponent: @"Campaign"];
    return campaignFilePath;
}

- (void)testLoadCampaign {
    XCTAssertNil([MIDeepLink loadCampaign], @"There is data into empty deeplink!");
    MICampaignParameters * cp = [[MICampaignParameters alloc] initWith:@"test campaign"];
    [self saveToFile: cp];
    XCTAssertNil([MIDeepLink loadCampaign], @"There is data into empty deeplink!");
    
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
