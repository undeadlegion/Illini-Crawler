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

@property (nonatomic, strong) Event *currentEvent;
@property (nonatomic, copy) NSURL *serverURL;
@property (nonatomic, strong) NSDictionary *barsDictionary;
@property (nonatomic, strong) NSMutableArray *pastBars;
@property (nonatomic, strong) NSMutableArray *currentBars;
@property (nonatomic, strong) NSDate *lastUpdated;
@property (nonatomic, strong) IBOutlet UITableView *myTableView;

- (void)loadBarsForEvent;
- (void)sortBarsForEvent;
- (void)scheduleNotifications;

- (void)reloadTableViewDataSource;
- (void)doneLoadingTableViewData;
- (BOOL)isReachable;
- (void)waitCompleted:(NSTimer *)theTimer;

@end
