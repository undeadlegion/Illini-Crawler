//
//  EventBarsFetcher.m
//  CampusCrawler
//
//  Created by James Lubowich on 2/27/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "BarsForEventFetcher.h"
#import "BarForEvent.h"
#import "Event.h"

@implementation BarsForEventFetcher

@synthesize currentEvent;
@synthesize currentEventDateComponents;

- (id)init{
    if((self = [super init])){
        serverURL = [[NSURL alloc] initWithString:serverString];
        dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        [dateFormatter setTimeZone:[NSTimeZone localTimeZone]];
        
//        [dateFormatter setLocale:[NSLocale currentLocale]];
//        NSLocale *ukLocale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_GB"];
//        [dateFormatter setLocale:ukLocale];        
//        [ukLocale release];
    }
    return self;
}


- (NSArray *)fetchEventBarsFromPath:(NSString *)path relativeTo:(NSURL *)baseURL withEvent:(Event *)event isURL:(BOOL)url{
    barsForEventList = [[NSMutableArray alloc] init];
    self.currentEvent = event;
    
    //set the event's date components
    self.currentEventDateComponents = [[NSDateComponents alloc] init];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    unsigned unitFlags = NSMonthCalendarUnit | NSDayCalendarUnit | NSYearCalendarUnit;
    currentEventDateComponents = [calendar components:unitFlags fromDate:currentEvent.date];
   
     [self parseXMLFile:path relativeTo:baseURL isURL:url];
    return barsForEventList;
}


#pragma mark - XML Parsing

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict{
    if([elementName isEqualToString:@"Bar"]){
        currentBarForEvent = [[BarForEvent alloc] init];
        currentBarForEvent.barId = [NSString stringWithString:[attributeDict objectForKey:@"id"]];
        NSLog(@"BarId:%@", currentBarForEvent.barId);
    }
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName{
    if([elementName isEqualToString:@"Bar"]) {
        
        [barsForEventList addObject:currentBarForEvent];
        currentBarForEvent = nil;
    }
    if([elementName isEqualToString:@"time"]){
        NSDate *time = [dateFormatter dateFromString:currentStringValue];
        currentBarForEvent.time = time;
    }
    if([elementName isEqualToString:@"specials"]){
        currentBarForEvent.specials = currentStringValue;
    }
    
    currentStringValue = nil;
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
    if (!currentStringValue) {
        currentStringValue = [[NSMutableString alloc] initWithCapacity:50];
    }
    if([string hasPrefix:@"\n"])
        return;
    [currentStringValue appendString:string];
}

- (void)parseXMLFile:(NSString *)pathToFile relativeTo:(NSURL *)baseURL isURL:(BOOL)url{
    BOOL success;
    NSURL *xmlURL;
    
    if(url)
        xmlURL = [NSURL URLWithString:pathToFile relativeToURL:baseURL];
    else
        xmlURL = [NSURL fileURLWithPath:pathToFile];
    
    
    parser = [[NSXMLParser alloc] initWithContentsOfURL:xmlURL];
    [parser setDelegate:self];
    [parser setShouldResolveExternalEntities:YES];
    
    success = [parser parse]; // return value not used
                              // if not successful, delegate is informed of error
}


@end
