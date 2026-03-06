//
//  APXRequestBuilderTests.m
//  MappIntelligenceTests
//

#import <XCTest/XCTest.h>
#import <OCMock/OCMock.h>
#import "APXRequestBuilder.h"
#import "MIAPXIdentifier.h"

@interface MIRequestBuilder (TestAccess)
- (NSString *)deviceUniqueGlobaldentifier;
- (NSDictionary *)dictionaryWithValuesForKeys:(NSArray *)keys;
@end

@interface APXRequestBuilderTests : XCTestCase
@property (nonatomic, strong) id identifierClassMock;
@end

@implementation APXRequestBuilderTests

- (void)tearDown {
    if (self.identifierClassMock) {
        [self.identifierClassMock stopMocking];
        self.identifierClassMock = nil;
    }
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"UDID_USER_DEFAULTS_KEY"];
    [super tearDown];
}

- (void)testSharedReturnsSingleton {
    MIRequestBuilder *first = [MIRequestBuilder shared];
    MIRequestBuilder *second = [MIRequestBuilder shared];

    XCTAssertEqual(first, second);
}

- (void)testBuilderReturnsNewInstance {
    MIRequestBuilder *first = [MIRequestBuilder builder];
    MIRequestBuilder *second = [MIRequestBuilder builder];

    XCTAssertNotEqual(first, second);
}

- (void)testBuildRequestAsJsonDataReturnsNilWhenNoRequest {
    MIRequestBuilder *builder = [MIRequestBuilder builder];
    NSData *data = [builder buildRequestAsJsonData];

    XCTAssertNil(data);
}

- (void)testAddRequestKeyedValuesCreatesRequestAndBuildsJson {
    MIRequestBuilder *builder = [MIRequestBuilder builder];
    [builder addRequestKeyedValues:@{ @"foo": @"bar" } forRequestType:kAPXRequestKeyTypeRegister];

    NSData *data = [builder buildRequestAsJsonData];

    XCTAssertNotNil(data);
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
    XCTAssertNotNil(json[@"actions"]);
}

- (void)testDictionaryIncludesKeyAndAliasWhenSet {
    MIRequestBuilder *builder = [MIRequestBuilder builder];
    [builder addRequestKeyedValues:@{ @"a": @"b" } forRequestType:kAPXRequestKeyTypeRegister];

    [builder setValue:@"test-key" forKey:@"key"];
    [builder setValue:@"alias" forKey:@"aliasValue"];

    NSDictionary *dict = [builder dictionaryWithValuesForKeys:@[]];

    XCTAssertEqualObjects(dict[@"key"], @"test-key");
    XCTAssertEqualObjects(dict[@"alias"], @"alias");
}

- (void)testDeviceUniqueGlobaldentifierUsesStoredValue {
    [[NSUserDefaults standardUserDefaults] setObject:@"stored-udid" forKey:@"UDID_USER_DEFAULTS_KEY"];

    MIRequestBuilder *builder = [MIRequestBuilder builder];
    NSString *value = [builder valueForKey:@"key"];

    XCTAssertEqualObjects(value, @"stored-udid");
}

- (void)testDeviceUniqueGlobaldentifierUsesGeneratedWhenMissing {
    self.identifierClassMock = OCMClassMock([MIAPXIdentifier class]);
    OCMStub([self.identifierClassMock UDIDForDomain:[OCMArg any] usingKey:[OCMArg any]]).andReturn(@"generated-udid");

    MIRequestBuilder *builder = [MIRequestBuilder builder];
    NSString *value = [builder valueForKey:@"key"];

    XCTAssertEqualObjects(value, @"generated-udid");
    XCTAssertEqualObjects([[NSUserDefaults standardUserDefaults] objectForKey:@"UDID_USER_DEFAULTS_KEY"], @"generated-udid");
}

@end
