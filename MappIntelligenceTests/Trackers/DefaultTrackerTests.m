//
//  DefaultTrackerTests.m
//  MappIntelligenceTests
//
//  Created by Vladan Randjelovic on 14/02/2020.
//  Copyright © 2020 Mapp Digital US, LLC. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <UIKit/UIKit.h>
#import "DefaultTracker.h"

@interface DefaultTrackerTests : XCTestCase

@property DefaultTracker *tracker;

@end

@implementation DefaultTrackerTests

- (void)setUp {
    [super setUp];
    _tracker = [DefaultTracker sharedInstance];
}

- (void)tearDown {
    [super tearDown];
}

- (void)testExample {
    XCTAssertNotNil(_tracker);
}

- (void)testGenerateEverID {
    XCTAssertNotNil([_tracker generateEverId]);
}

- (void)testGenerateEverIDformat
{
    NSString *generatedEverID = [_tracker generateEverId];
    XCTAssertFalse([_tracker isReady]);
    XCTAssert([generatedEverID hasPrefix:@"6"], @"Ever ID should start with 6.");
    XCTAssertEqual(generatedEverID.length, 19, @"Ever ID should have 19 digits");
}

- (void)testUpdateFirstSessionWith {
//    XCTAssertFalse([_tracker isReady]);
//    [_tracker updateFirstSessionWith: UIApplicationStateActive];
//    XCTAssertTrue([_tracker isReady]);
//    [_tracker updateFirstSessionWith: UIApplicationStateInactive];
//    XCTAssertTrue([_tracker isReady]);
}

- (void)testTrackUIController {
    UIViewController *controller = [[UIViewController alloc] init];
    NSString *controllerName = NSStringFromClass([controller class]);
    [_tracker updateFirstSessionWith: UIApplicationStateActive];
    [_tracker trackWith: controllerName];
    //need to think about testable point into this method
    XCTAssertTrue([_tracker isReady]);
}

- (void)testTrackWithName {
    [_tracker updateFirstSessionWith: UIApplicationStateActive];
    [_tracker trackWith: @"testName"];
    XCTAssertTrue([_tracker isReady]);
}

- (void)testInitHibernate {
    [_tracker initHibernate];
    NSDate *hibernateDate = [[NSUserDefaults standardUserDefaults] objectForKey: @"appHibernationDate"];
    NSDate *date = [[NSDate alloc] init];
    //1 minute will be enough threshold
    XCTAssertTrue([date timeIntervalSinceDate: hibernateDate] < 60);
}

- (void)testinitializeTracking {
    DefaultTracker *tracker = [[DefaultTracker alloc] init];
    XCTAssertNotNil(tracker);
    XCTAssertTrue([tracker generateEverId]);
}

- (void)testReset {
    NSString *previousEverId = [_tracker generateEverId];
    [_tracker reset];
    NSString *nextEverId = [_tracker generateEverId];
    XCTAssertFalse([previousEverId isEqualToString: nextEverId]);
}


@end
