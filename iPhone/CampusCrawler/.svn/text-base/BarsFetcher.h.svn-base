//
//  BarsFetcher.h
//  CampusCrawler
//
//  Created by James Lubowich on 2/27/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Bar;
@interface BarsFetcher : NSObject<NSXMLParserDelegate> {
    NSXMLParser *parser;
    NSMutableDictionary *barsDictionary;
    NSMutableString *currentStringValue;
    Bar *currentBar;
    NSURL *serverURL;
}

- (NSDictionary *)fetchBarsFromPath:(NSString *)path relativeTo:(NSURL *)baseURL isURL:(BOOL)url;
- (void)parseXMLFile:(NSString *)pathToFile relativeTo:(NSURL *)baseURL isURL:(BOOL)url;

@end
