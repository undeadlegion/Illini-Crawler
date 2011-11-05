//
//  EventBarsFetcher.h
//  CampusCrawler
//
//  Created by James Lubowich on 2/27/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
@class BarForEvent;
@class Event;

@interface BarsForEventFetcher : NSObject<NSXMLParserDelegate> {
    NSXMLParser *parser;
    NSMutableArray *barsForEventList;
    NSMutableString *currentStringValue;
    BarForEvent *currentBarForEvent;
    NSURL *serverURL;
    NSDateFormatter *dateFormatter;
    Event *currentEvent;
    NSDateComponents *currentEventDateComponents;
    NSUInteger dateId;
}
- (NSArray *)fetchEventBarsFromPath:(NSString *)path relativeTo:(NSURL *)baseURL withEvent:(Event *)event isURL:(BOOL)url;
- (void)parseXMLFile:(NSString *)pathToFile relativeTo:(NSURL *)baseURL isURL:(BOOL)url;

@property (nonatomic, retain) Event *currentEvent;
@property (nonatomic, retain) NSDateComponents *currentEventDateComponents;

@end
