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
#import "MIMediaParameters.h"

@interface MIMediaTrackerTests : XCTestCase
@property (nonatomic, strong) MIMediaTracker *tracker;
@end

@implementation MIMediaTrackerTests

- (void)setUp {
    [super setUp];
    self.tracker = [MIMediaTracker sharedInstance];
}

- (void)tearDown {
    self.tracker = nil;
    [super tearDown];
}

- (void)testSingletonInstance {
    MIMediaTracker *instance1 = [MIMediaTracker sharedInstance];
    MIMediaTracker *instance2 = [MIMediaTracker sharedInstance];
    XCTAssertEqual(instance1, instance2, @"MIMediaTracker should return the same instance each time");
}

- (void)testShouldTrack_LiveStream_FirstEvent {
    // Create a live stream event (duration = 0)
    MIMediaEvent *liveStreamEvent = [self createEventWithDuration:0 action:@"play"];
    
    // Ensure that the first live stream event is tracked
    BOOL shouldTrack = [self.tracker shouldTrack:liveStreamEvent];
    XCTAssertTrue(shouldTrack, @"The first live stream event should be tracked");
}

- (void)testShouldTrack_LiveStream_SameActionWithinAllowedInterval {
    // Create a live stream event (duration = 0)
    MIMediaEvent *liveStreamEvent = [self createEventWithDuration:0 action:@"play"];
    
    // Track the first event
    [self.tracker shouldTrack:liveStreamEvent];
    
    // Track the same event within the allowed interval
    BOOL shouldTrack = [self.tracker shouldTrack:liveStreamEvent];
    XCTAssertFalse(shouldTrack, @"The live stream event should not be tracked within the allowed interval if the action is the same");
}

- (void)testShouldTrack_LiveStream_DifferentActionWithinAllowedInterval {
    // Create two live stream events with different actions
    MIMediaEvent *liveStreamEventPlay = [self createEventWithDuration:0 action:@"play"];
    MIMediaEvent *liveStreamEventPause = [self createEventWithDuration:0 action:@"pause"];
    
    // Track the first event
    [self.tracker shouldTrack:liveStreamEventPlay];
    
    // Track a different action event within the allowed interval
    BOOL shouldTrack = [self.tracker shouldTrack:liveStreamEventPause];
    XCTAssertTrue(shouldTrack, @"The live stream event with a different action should be tracked even within the allowed interval");
}

- (void)testShouldTrack_NonLiveStream_FirstEvent {
    // Create a non-live stream event (duration > 0)
    MIMediaEvent *nonLiveStreamEvent = [self createEventWithDuration:@100 action:@"play"];
    
    // Ensure that the first non-live stream event is tracked
    BOOL shouldTrack = [self.tracker shouldTrack:nonLiveStreamEvent];
    XCTAssertTrue(shouldTrack, @"The first non-live stream event should be tracked");
}

- (void)testShouldTrack_NonLiveStream_SameActionWithinAllowedInterval {
    // Create a non-live stream event (duration > 0)
    MIMediaEvent *nonLiveStreamEvent = [self createEventWithDuration:@100 action:@"play"];
    
    // Track the first event
    [self.tracker shouldTrack:nonLiveStreamEvent];
    
    // Track the same event within the allowed interval
    BOOL shouldTrack = [self.tracker shouldTrack:nonLiveStreamEvent];
    XCTAssertFalse(shouldTrack, @"The non-live stream event should not be tracked within the allowed interval if the action is the same");
}

- (void)testShouldTrack_NonLiveStream_DifferentActionWithinAllowedInterval {
    // Create two non-live stream events with different actions
    MIMediaEvent *nonLiveStreamEventPlay = [self createEventWithDuration:@100 action:@"play"];
    MIMediaEvent *nonLiveStreamEventPause = [self createEventWithDuration:@100 action:@"pause"];
    
    // Track the first event
    [self.tracker shouldTrack:nonLiveStreamEventPlay];
    
    // Track a different action event within the allowed interval
    BOOL shouldTrack = [self.tracker shouldTrack:nonLiveStreamEventPause];
    XCTAssertTrue(shouldTrack, @"The non-live stream event with a different action should be tracked even within the allowed interval");
}

#pragma mark - Helper Methods

- (MIMediaEvent *)createEventWithDuration:(NSNumber *)duration action:(NSString *)action {
    
    MIMediaParameters *params = [[MIMediaParameters alloc] initWith:@"TestMediaParamterName" action:action position:@1.0 duration:duration];
    MIMediaEvent *event = [[MIMediaEvent alloc] initWithPageName:@"TestMediaName" parameters:params];
    return event;
}

@end

