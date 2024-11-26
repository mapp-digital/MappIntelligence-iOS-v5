//
//  MIReachabilityTests.m
//  MappIntelligenceTests
//
//  Created by Mihajlo Jezdic on 25.11.24.
//  Copyright © 2024 Mapp Digital US, LLC. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "Reachability.h"
#import <arpa/inet.h>

@interface MIReachabilityTests : XCTestCase
@property (nonatomic, strong) Reachability *reachability;
@end

@implementation MIReachabilityTests

- (void)setUp {
    [super setUp];
    self.reachability = [Reachability reachabilityForInternetConnection];
}

- (void)tearDown {
    [self.reachability stopNotifier];
    self.reachability = nil;
    [super tearDown];
}

- (void)testReachabilityWithHostName {
    Reachability *reachability = [Reachability reachabilityWithHostName:@"www.apple.com"];
    XCTAssertNotNil(reachability, @"Reachability instance should not be nil.");
}

- (void)testReachabilityWithAddress {
    struct sockaddr_in address;
    bzero(&address, sizeof(address));
    address.sin_len = sizeof(address);
    address.sin_family = AF_INET;
    inet_aton("8.8.8.8", &address.sin_addr);

    Reachability *reachability = [Reachability reachabilityWithAddress:(const struct sockaddr *)&address];
    XCTAssertNotNil(reachability, @"Reachability instance should not be nil.");
}

- (void)testStartNotifier {
    BOOL started = [self.reachability startNotifier];
    XCTAssertTrue(started, @"Notifier should start successfully.");
}

- (void)testStopNotifier {
    [self.reachability startNotifier];
    [self.reachability stopNotifier];
    XCTAssertTrue(YES, @"Stopping notifier should not cause crashes.");
}

- (void)testCurrentReachabilityStatus {
    NetworkStatus status = [self.reachability currentReachabilityStatus];
    XCTAssert(status == NotReachable || status == ReachableViaWiFi || status == ReachableViaWWAN, @"Network status should be a valid value.");
}

- (void)testConnectionRequired {
    BOOL connectionRequired = [self.reachability connectionRequired];
    XCTAssert(connectionRequired == YES || connectionRequired == NO, @"Connection required should return YES or NO.");
}

@end

