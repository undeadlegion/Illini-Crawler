//
//  AdditionalTests.m
//  CampusCrawler
//
//  Created by James Lubowich on 4/5/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "AdditionalTests.h"
#import "Event.h"

@implementation AdditionalTests

#if USE_APPLICATION_UNIT_TEST     // all code under test is in the iPhone Application

- (void)testAppDelegate {
    
    id yourApplicationDelegate = [[UIApplication sharedApplication] delegate];
    STAssertNotNil(yourApplicationDelegate, @"UIApplication failed to find the AppDelegate");
    
}

#else                           // all code under test must be linked into the Unit Test bundle

- (void)testMath {
    
    STAssertTrue((1+1)==2, @"Compiler isn't feeling well today :-(" );
    
}

- (void)testEvent {
    Event *event = [[Event alloc] init];
    event.eventId = @"Test Event";
    STAssertNotNil(event, @"This is not nil");
    STAssertTrue((1+1)==2, @"Compiler isn't feeling well today :-(" );
    
}
- (void)testEvent2{
    Event *event = [[Event alloc] init ];
    event.eventId = @"Campus Crawl";
    STAssertEquals(event.eventId, @"Campus Crawl", @"Event Id not Equal");
}
- (void)testExample
{
    STAssertTrue(TRUE, @"This works");
//    STFail(@"Unit tests are not implemented yet in CampusCrawlerTests");
}
#endif

@end
