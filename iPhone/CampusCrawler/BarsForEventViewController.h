//
//  EventDetailViewController.h
//  CampusCrawler
//
//  Created by James Lubowich on 2/16/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EGORefreshTableHeaderView.h"

@class Event, BarForEvent, BarsForEventFetcher;

@interface BarsForEventViewController : UITableViewController <EGORefreshTableHeaderDelegate,NSXMLParserDelegate>{
    Event *currentEvent;
    NSURL *serverURL;

    NSDateFormatter *dateFormatter;
    NSDictionary *barsDictionary;
    NSMutableArray *pastBars;
    NSMutableArray *currentBars;
    
    EGORefreshTableHeaderView *refreshHeaderView;
    BOOL isReloading;
    BOOL minimumWaitCompleted;
    NSDate *lastUpdated;
    UITableView *myTableView;
}

@property (nonatomic, retain) Event *currentEvent;
@property (nonatomic, copy) NSURL *serverURL;
@property (nonatomic, retain) NSDictionary *barsDictionary;
@property (nonatomic, retain) NSMutableArray *pastBars;
@property (nonatomic, retain) NSMutableArray *currentBars;
@property (nonatomic, retain) NSDate *lastUpdated;
@property (nonatomic, retain) IBOutlet UITableView *myTableView;

- (void)loadBarsForEvent;
- (void)sortBarsForEvent;
- (void)scheduleNotifications;

- (void)reloadTableViewDataSource;
- (void)doneLoadingTableViewData;
- (BOOL)isReachable;
- (void)waitCompleted:(NSTimer *)theTimer;

@end
