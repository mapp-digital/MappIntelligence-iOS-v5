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
#import "Enviroment.h"
#import "MappIntelligence.h"

@interface DefaultTrackerTests : XCTestCase

@property DefaultTracker *tracker;

@end

@implementation DefaultTrackerTests

- (void)setUp {
    [super setUp];
    _tracker = [DefaultTracker sharedInstance];
    NSArray<NSBundle*> *bundles = [NSBundle allBundles];
    NSString* path = @"";
    for (NSBundle* bundle in bundles) {
        if ([bundle pathForResource:@"SetupForLocalTesting" ofType:@"plist"]) {
            path = [bundle pathForResource:@"SetupForLocalTesting" ofType:@"plist"];
        }
    }
    XCTAssertTrue(![path isEqualToString:@""], @"There is no plist file with domain and trackIDs!");
    NSDictionary* dict = [NSDictionary dictionaryWithContentsOfFile:path];
    XCTAssertNotNil(dict, @"Dictionary does not contain domain or trackID!");
    NSNumber *number = [NSNumber numberWithLong:[[dict valueForKey:@"track_ids"] longValue]];
    NSArray* array = @[number];
    [[MappIntelligence shared] initWithConfiguration: array  onTrackdomain:[dict valueForKey:@"domain"]];
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

- (void)testGenerateUserAgent {
    NSString* generatedUserAgent = [_tracker generateUserAgent];
    Enviroment *env = [[Enviroment alloc] init];
    NSString *properties = [env.operatingSystemName
        stringByAppendingFormat:@" %@; %@; %@", env.operatingSystemVersionString,
                                env.deviceModelString,
                                NSLocale.currentLocale.localeIdentifier];

    NSString* currentUserAgent =
        [[NSString alloc] initWithFormat:@"Tracking Library %@ (%@))",
                                         MappIntelligence.version, properties];
    XCTAssertTrue([generatedUserAgent isEqualToString:currentUserAgent], @"The genereted user agent is not correct!");
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

- (void)testTrackWithPageEvent {
    NSMutableDictionary* details = [@{@20: @[@"cp20Override"]} copy];
    NSMutableDictionary* groups = [@{@15: @[@"testGroups"]} copy];
    NSString* internalSearch = @"testSearchTerm";
    NSMutableDictionary* sessionDictionary = [@{@10: @[@"sessionpar1"]} copy];
    SessionProperties* sessionProperties =  [[SessionProperties alloc] initWithProperties: sessionDictionary];
    PageProperties* pageProperties = [[PageProperties alloc] initWithPageParams:details andWithPageCategory:groups andWithSearch:internalSearch];
    EcommerceProperties* ecommerceProperties = [[EcommerceProperties alloc] init];
    PageViewEvent* pageViewEvent = [[PageViewEvent alloc] initWithName:@"the custom name" pageProperties:pageProperties sessionProperties:sessionProperties userProperties:nil ecommerceProperties:ecommerceProperties advertisementProperties:nil];
    NSError* error = [_tracker trackWithEvent:pageViewEvent];
    //TODO: add reasonable error or it will return null always
    XCTAssertNil(error, @"There was an error while tracking page view event!");
}

- (void) testTrackWithAction {
    NSMutableDictionary* properties = [@{@20: @[@"1 element"]} copy];
    NSString* actionname = @"TestAction";
    NSMutableDictionary* sessionDictionary = [@{@10: @[@"sessionpar1"]} copy];
    SessionProperties* sessionProperties =  [[SessionProperties alloc] initWithProperties: sessionDictionary];
    
    MIActionProperties* actionProperties = [[MIActionProperties alloc] initWithProperties:properties];
    ActionEvent *actionEvent = [[ActionEvent alloc] initWithName: actionname pageName:@"0" actionProperties:actionProperties sessionProperties:sessionProperties userProperties:nil ecommerceProperties:nil advertisementProperties:nil];
    NSError* error = [_tracker trackAction:actionEvent];
    XCTAssertNil(error, @"There was an error while tracking action event!");
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

- (void)testSendRequestFromDatabase {
    XCTestExpectation* expectation = [[XCTestExpectation alloc] initWithDescription:@"Wait until send all requests one by one from database!"];
    //1. write requests into database
    //2. send requests from database one by one
    [_tracker sendRequestFromDatabaseWithCompletionHandler:^(NSError * _Nullable error) {
        XCTAssertNil(error, @"There was an error while sending requests one by one!");
        [expectation fulfill];
    }];
    [self waitForExpectations:[NSArray arrayWithObject:expectation] timeout:15];
}

- (void)testSendBatchForRequest {
    XCTestExpectation* expectation = [[XCTestExpectation alloc] initWithDescription:@"Wait until send batch with requests from database!"];
    //1. write requests into database
    //2. send requests as a batch to the server
    [_tracker sendBatchForRequestWithCompletionHandler:^(NSError * _Nullable error) {
        XCTAssertNil(error, @"There was an error while sending requests from database as batch!");
        [expectation fulfill];
    }];
    [self waitForExpectations:[NSArray arrayWithObject:expectation] timeout:25];
}

- (void)testRemoveAllRequestsFromDB {
    XCTestExpectation* expectation = [[XCTestExpectation alloc] initWithDescription:@"Wait until delete all requests from database!"];
    //1. write requests into database
    //2. remove all requests from database
    [_tracker removeAllRequestsFromDBWithCompletionHandler:^(NSError * _Nullable error) {
        XCTAssertNil(error, @"There was an error while deleting requests from database!");
        [expectation fulfill];
    }];
    //3. check if all removed successfully
    [self waitForExpectations:[NSArray arrayWithObject:expectation] timeout:5];
}

@end
