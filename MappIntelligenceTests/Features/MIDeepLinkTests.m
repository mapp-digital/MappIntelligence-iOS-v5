//
//  MIDeepLink.m
//  MappIntelligenceTests
//
//  Created by Stefan Stevanovic on 25.10.22..
//  Copyright © 2022 Mapp Digital US, LLC. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "MIDeepLink.h"

static NSString * const UrlErrorDescriptionInvalid = @"Url is invalid";

@interface MIDeepLinkTests : XCTestCase
@end

@implementation MIDeepLinkTests

- (void)setUp {
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
}

- (void)testTrackFromUrl_ValidUrlWithMediaCode {
    NSURL *url = [NSURL URLWithString:@"https://example.com?wt_mc=abc123"];
    NSError *error = [MIDeepLink trackFromUrl:url withMediaCode:@"wt_mc"];
    
    XCTAssertNil(error, @"Tracking from a valid URL should not return an error");
}

- (void)testTrackFromUrl_InvalidUrl {
    NSURL *url = [NSURL URLWithString:@"invalid url"];
    NSError *error = [MIDeepLink trackFromUrl:url withMediaCode:@"wt_mc"];
    
    XCTAssertNotNil(error, @"Tracking from an invalid URL should return an error");
    XCTAssertEqualObjects(error.localizedDescription, UrlErrorDescriptionInvalid, @"Error description should be 'Url is invalid'");
}

- (void)testTrackFromUrl_NoMediaCode {
    NSURL *url = [NSURL URLWithString:@"https://example.com?wt_mc=campaignId"];
    NSError *error = [MIDeepLink trackFromUrl:url withMediaCode:nil];
    
    XCTAssertNil(error, @"Tracking from a valid URL without specifying a media code should not return an error");
}

- (void)testTrackFromUrl_NoCampaignId {
    // Given a URL without a campaign ID parameter
    NSURL *url = [NSURL URLWithString:@"https://example.com"];
    
    // When calling trackFromUrl
    NSError *error = [MIDeepLink trackFromUrl:url withMediaCode:nil];
    
    // Then it should return an error because no campaign ID is present
    XCTAssertNotNil(error, @"Tracking from a URL with no campaign ID should return an error");
    XCTAssertEqualObjects(error.localizedDescription, UrlErrorDescriptionInvalid, @"Error description should be 'Url is invalid'");
}

#pragma mark - loadCampaign Tests

- (void)testLoadCampaign_Success {
    // Given that a campaign is previously saved
    MICampaignParameters *savedCampaign = [[MICampaignParameters alloc] init];
    savedCampaign.campaignId = @"abc123";
    [self saveToFile:savedCampaign]; // Helper method to save campaign
    
    // When loading the campaign
    MICampaignParameters *loadedCampaign = [MIDeepLink loadCampaign];
    
    // Then it should return the saved campaign
    XCTAssertNotNil(loadedCampaign, @"The loaded campaign should not be nil");
    XCTAssertEqualObjects(loadedCampaign.campaignId, @"abc123", @"The loaded campaign ID should match the saved one");
}

#pragma mark - deleteCampaign Tests

- (void)testDeleteCampaign_Success {
    // Given that a campaign is saved
    MICampaignParameters *savedCampaign = [[MICampaignParameters alloc] init];
    savedCampaign.campaignId = @"abc123";
    [self saveToFile:savedCampaign]; // Helper method to save campaign
    
    // When calling deleteCampaign
    NSError *error = [MIDeepLink deleteCampaign];
    
    // Then there should be no error
    XCTAssertNil(error, @"Deleting a campaign should not return an error");
    
    // And loading the campaign should return nil
    MICampaignParameters *loadedCampaign = [MIDeepLink loadCampaign];
    XCTAssertNil(loadedCampaign, @"Loading a campaign after deletion should return nil");
}

- (void)testLoadCampaign_NoData {
    // Given that no campaign is saved
    
    // When loading the campaign
    MICampaignParameters *loadedCampaign = [MIDeepLink loadCampaign];
    
    // Then it should return nil as no data is available
    XCTAssertNil(loadedCampaign, @"Loading campaign when no data exists should return nil");
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

@end
