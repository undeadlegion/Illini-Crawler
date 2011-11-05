//
//  EventsFetcher.h
//  CampusCrawler
//
//  Created by James Lubowich on 2/27/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Event;
@interface EventsFetcher : NSObject<NSXMLParserDelegate> {
    NSXMLParser *parser;
    NSMutableArray *eventsList;
    NSMutableString *currentStringValue;
    Event *currentEvent;
    NSURL *serverURL;
    NSDateFormatter *dateFormatter;
}

- (NSArray *)fetchEventsFromPath:(NSString *)path relativeTo:(NSURL *)baseURL isURL:(BOOL)url;
- (void)parseXMLFile:(NSString *)pathToFile relativeTo:(NSURL *)baseURL isURL:(BOOL)url;

@end
