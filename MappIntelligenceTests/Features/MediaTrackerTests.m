//
//  MediaTrackerTests.m
//  MappIntelligenceTests
//
//  Created by Stefan Stevanovic on 20.9.22..
//  Copyright © 2022 Mapp Digital US, LLC. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "MIMediaTracker.h"
#import "MIMediaEvent.h"

@interface MediaTrackerTests : XCTestCase
@property MIMediaTracker* mediaTracker;
@end

@implementation MediaTrackerTests

- (void)setUp {
    _mediaTracker = [MIMediaTracker sharedInstance];
}

- (void)tearDown {
    _mediaTracker = NULL;
}

- (void)testSharedInstance {
    XCTAssertNotNil(_mediaTracker);
}

- (void)testShouldTrack {
//    MIMediaEvent* event = [[MIMediaEvent alloc] initWithPageName: @"testPageName" parameters:[[MIMediaParameters alloc] initWith:@"test" action:@"stop" position: @5 duration: @4]];
//    XCTAssertFalse([_mediaTracker shouldTrack:event]);
    
//    MIMediaEvent* event = [[MIMediaEvent alloc] initWithPageName: @"testPageName" parameters:[[MIMediaParameters alloc] initWith:@"test" action:@"stop" position: @5 duration: @7]];
//    XCTAssertTrue([_mediaTracker shouldTrack:event]);
    
    //TODO: write test for livestream
}

@end
