#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "AAEventsManager.h"
#import "AppAnalytics.h"

@interface AAEventsManager (Tests)
- (void)sendData;
- (void)deserialize;
@property (nonatomic, readwrite, strong) NSMutableDictionary* events;
@property (nonatomic, readwrite) BOOL debugLogEnabled;
@property (nonatomic, readwrite) BOOL exceptionAnalyticEnabled;
@property (nonatomic, readwrite) BOOL transactionAnalyticEnabled;
@property (nonatomic, readwrite) BOOL screenAnalyticEnabled;
@property (nonatomic, readwrite) BOOL popupAnalyticEnabled;
@property (nonatomic, readwrite) BOOL locationServicesAnalyticEnabled;
@property (nonatomic, readwrite) BOOL connectionAnalyticEnabled;
@property (nonatomic, readwrite) BOOL applicationStateAnalyticEnabled;
@property (nonatomic, readwrite) BOOL deviceOrientationAnalyticEnabled;
@property (nonatomic, readwrite) BOOL batteryAnalyticEnabled;
@property (nonatomic, readwrite) BOOL keyboardAnalyticsEnabled;
@end

@interface AppAnalytics (Tests)
+ (instancetype)instance;
@property (nonatomic, strong) NSString* appKey;
@property (nonatomic, strong) NSUUID* sessionUUID;
@property (nonatomic, strong) NSString* udid;
@property (nonatomic) BOOL heatMapAnalyticsEnabled;
@end

@interface AppAnalyticsTests : XCTestCase

@end

@implementation AppAnalyticsTests

- (void)setUp
{
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testExample
{
    // This is an example of a functional test case.
    XCTAssert(YES, @"Pass");
}

- (void)testLargeDataPerformance
{
    [self measureBlock:^
    {
        static int repeats = 10000;
        for (int i = 0; i < repeats; i++)
            [AppAnalytics logEvent:[NSString stringWithFormat:@"Event %lu", (unsigned long) [@(arc4random()) hash]]];
    }];
}

- (void)testSerialization
{
    for (int i = 0; i < 10; i++)
        [[AAEventsManager instance] addEvent:@"Event" async:NO];
    
    int eventsBefore = (int) [[AAEventsManager instance].events[[AppAnalytics instance].sessionUUID.UUIDString] count];
    
    [[AAEventsManager instance] deserialize];
    
    int eventsAfter = (int) [[AAEventsManager instance].events[[AppAnalytics instance].sessionUUID.UUIDString] count];
    
    XCTAssertNotEqual(eventsBefore, eventsAfter);
}

#pragma mark - Public Interface

- (void)testConstants
{
    XCTAssertNotNil(DebugLog);
    XCTAssertNotNil(HeatMapAnalytics);
    XCTAssertNotNil(ExceptionAnalytics);
    XCTAssertNotNil(TransactionAnalytics);
    XCTAssertNotNil(PopUpAnalytics);
    XCTAssertNotNil(LocationServicesAnalytics);
    XCTAssertNotNil(ConnectionAnalytics);
    XCTAssertNotNil(ApplicationStateAnalytics);
    XCTAssertNotNil(DeviceOrientationAnalytics);
    XCTAssertNotNil(KeyboardAnalytics);
}

- (void)testInit
{
    [AppAnalytics initWithAppKey:@"123"];
    
    // parameters initialised
    XCTAssertNotNil([AppAnalytics instance].appKey);
    XCTAssertNotNil([AppAnalytics instance].sessionUUID);
    XCTAssertNotNil([AppAnalytics instance].udid);
}

- (void)testInitOptions
{
    [AppAnalytics initWithAppKey:@"123"
                         options:@{DebugLog                     : @(NO),
                                   HeatMapAnalytics             : @(NO),
                                   ExceptionAnalytics           : @(NO),
                                   TransactionAnalytics         : @(NO),
                                   NavigationAnalytics          : @(NO),
                                   PopUpAnalytics               : @(NO),
                                   LocationServicesAnalytics    : @(NO),
                                   ConnectionAnalytics          : @(NO),
                                   ApplicationStateAnalytics    : @(NO),
                                   DeviceOrientationAnalytics   : @(NO),
                                   KeyboardAnalytics            : @(NO),
                                   BatteryAnalytics             : @(NO)
                                   }];
    
    // parameters initialised
    XCTAssertNotNil([AppAnalytics instance].appKey);
    XCTAssertNotNil([AppAnalytics instance].sessionUUID);
    XCTAssertNotNil([AppAnalytics instance].udid);
    
    // options correctly set
    XCTAssertFalse([AAEventsManager instance].debugLogEnabled, @"Passed");
    XCTAssertFalse([AAEventsManager instance].exceptionAnalyticEnabled, @"Passed");
    XCTAssertFalse([AAEventsManager instance].transactionAnalyticEnabled, @"Passed");
    XCTAssertFalse([AAEventsManager instance].screenAnalyticEnabled, @"Passed");
    XCTAssertFalse([AAEventsManager instance].popupAnalyticEnabled, @"Passed");
    XCTAssertFalse([AAEventsManager instance].locationServicesAnalyticEnabled, @"Passed");
    XCTAssertFalse([AAEventsManager instance].connectionAnalyticEnabled, @"Passed");
    XCTAssertFalse([AAEventsManager instance].applicationStateAnalyticEnabled, @"Passed");
    XCTAssertFalse([AAEventsManager instance].deviceOrientationAnalyticEnabled, @"Passed");
    XCTAssertFalse([AAEventsManager instance].batteryAnalyticEnabled, @"Passed");
    XCTAssertFalse([AAEventsManager instance].keyboardAnalyticsEnabled, @"Passed");
    XCTAssertFalse([AppAnalytics instance].heatMapAnalyticsEnabled, @"Passed");
}

- (void)testMultiInitialisation
{
    NSString* initialAppKey = [AppAnalytics instance].appKey ? [AppAnalytics instance].appKey : @"111";
    [AppAnalytics initWithAppKey:initialAppKey];
    [AppAnalytics initWithAppKey:@"123"];
    [AppAnalytics initWithAppKey:@"321" options:nil];
    
    XCTAssert([initialAppKey isEqualToString:[AppAnalytics instance].appKey]);
}

- (void)testLogEvent
{
    // unique event added. new container created
    int eventsBefore = (int) [[AAEventsManager instance].events[[AppAnalytics instance].sessionUUID.UUIDString] count];
    [[AAEventsManager instance] addEvent:@"UniqueEvent" async:NO];
    int eventsAfter = (int) [[AAEventsManager instance].events[[AppAnalytics instance].sessionUUID.UUIDString] count];
    XCTAssert(eventsAfter - eventsBefore == 1, @"Pass");
    
    // duplicated event added. new container should not be created
    eventsBefore = eventsAfter;
    [[AAEventsManager instance] addEvent:@"UniqueEvent" async:NO];
    eventsAfter = (int) [[AAEventsManager instance].events[[AppAnalytics instance].sessionUUID.UUIDString] count];
    XCTAssertEqual(eventsBefore, eventsAfter);
}

- (void)testLogEventWithParameters
{
    // first event with parameters. allocate new container
    int eventsBefore = (int) [[AAEventsManager instance].events[[AppAnalytics instance].sessionUUID.UUIDString] count];
    [[AAEventsManager instance] addEvent:@"X" parameters:@{} async:NO];
    int eventsAfter = (int) [[AAEventsManager instance].events[[AppAnalytics instance].sessionUUID.UUIDString] count];
    XCTAssert(eventsAfter - eventsBefore == 1, @"Pass");
    
    // duplicated event with parameters. use existing container
    eventsBefore = eventsAfter;
    [[AAEventsManager instance] addEvent:@"X" parameters:@{} async:NO];
    eventsAfter = (int) [[AAEventsManager instance].events[[AppAnalytics instance].sessionUUID.UUIDString] count];
    XCTAssertEqual(eventsBefore, eventsAfter);
    
    // same event name, new parameters. allocate new container
    eventsBefore = eventsAfter;
    [[AAEventsManager instance] addEvent:@"X" parameters:@{@"X" : @"XXX"} async:NO];
    eventsAfter = (int) [[AAEventsManager instance].events[[AppAnalytics instance].sessionUUID.UUIDString] count];
    XCTAssert(eventsAfter - eventsBefore == 1, @"Pass");
    
    // duplicated event with parameters 2. use existing container 2
    eventsBefore = eventsAfter;
    [[AAEventsManager instance] addEvent:@"X" parameters:@{@"X" : @"XXX"} async:NO];
    eventsAfter = (int) [[AAEventsManager instance].events[[AppAnalytics instance].sessionUUID.UUIDString] count];
    XCTAssertEqual(eventsBefore, eventsAfter);
}

@end