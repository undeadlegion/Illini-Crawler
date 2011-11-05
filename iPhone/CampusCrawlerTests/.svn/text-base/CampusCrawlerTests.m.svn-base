//
//  CampusCrawlerTests.m
//  CampusCrawlerTests
//
//  Created by James Lubowich on 2/5/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "CampusCrawlerTests.h"
#import "Event.h"
#import "BarsFetcher.h"
#import "Constants.h"
#import "Bar.h"
#import "EventsFetcher.h"

@implementation CampusCrawlerTests

- (void)setUp
{
    [super setUp];
    
    // Set-up code here.
}

- (void)tearDown
{
    // Tear-down code here.
    
    [super tearDown];
}

- (void)testEvent
{
    
    Event *event = [[Event alloc] init ];
    event.eventId = @"Campus Crawl";
    STAssertEquals(event.eventId, @"Campus Crawl", @"Event Id not Equal");
}

- (void)testExample
{
    STAssertTrue(TRUE, @"This works");
}


- (void)testBarsParseDisk
{
    BarsFetcher *barsFetcher = [[[BarsFetcher alloc] init] autorelease];
    NSString *barsPath;
    NSURL *serverURL = [[[NSURL alloc] initWithString:serverString] autorelease];    
    

    //load from disk
    NSLog(@"Loading Bars from Disk");
    barsPath = [[NSBundle mainBundle] pathForResource:@"bars" ofType:@"xml"];
    
    NSDictionary *barsDictionary = [[barsFetcher fetchBarsFromPath:barsPath relativeTo:serverURL isURL:NO]retain];
    Bar *bar = [barsDictionary objectForKey:@"1"];
    STAssertNotNil(barsDictionary, @"Bars Dictionary nil");
    STAssertNotNil(bar, @"Bar Not Contained in Dictionary");
    STAssertEqualObjects(bar.name, @"Firehaus", @"Name Doesn't Match");
    [barsDictionary release];
}

- (void)testEventsFetcherDisk
{
    EventsFetcher *eventsFetcher = [[[EventsFetcher alloc] init] autorelease];
    NSString *eventsPath;
    NSURL *serverURL = [[[NSURL alloc] initWithString:serverString] autorelease];
    
    eventsPath = [[NSBundle mainBundle] pathForResource:@"events" ofType:@"xml"];
    
    NSArray *eventsList = [eventsFetcher fetchEventsFromPath:eventsPath relativeTo:serverURL isURL:NO];
    STAssertNotNil(eventsList, @"Events List nil");
    
    Event *event = [eventsList objectAtIndex:0];
    STAssertNotNil(event, @"Event not found");
    
    NSString *expectedEventName = @"CS429 Crawl";
    STAssertEqualObjects(event.title, expectedEventName, @"Event titles don't match");
}

- (void)testBarsParseServer
{
    BarsFetcher *barsFetcher = [[[BarsFetcher alloc] init] autorelease];
    NSString *barsPath;
    NSURL *serverURL = [[[NSURL alloc] initWithString:serverString] autorelease];    
    NSLog(@"Test Server URL %@", serverURL);
    //load from server
    NSLog(@"Loading Bars from Server");
    barsPath = barRequestString;

    NSDictionary *barsDictionary = [[barsFetcher fetchBarsFromPath:barsPath relativeTo:serverURL isURL:YES] retain];
    NSLog(@"Loaded Bars for Test %@", barsDictionary);
    
    NSString *expectedBarName = @"Boltini Lounge";
    
    Bar *bar = [barsDictionary objectForKey:@"1"];
    STAssertNotNil(barsDictionary, @"Bars Dictionary nil");
    STAssertNotNil(bar, @"Bar Not Contained in Dictionary");
    STAssertEqualObjects(bar.name, expectedBarName, @"Name Doesn't Match");
    [barsDictionary release];
}



@end
