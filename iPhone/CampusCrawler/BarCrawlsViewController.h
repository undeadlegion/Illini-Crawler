//
//  MyCrawlsViewController.h
//  CampusCrawler
//
//  Created by James Lubowich on 2/5/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FBConnect.h"
#import "EGORefreshTableHeaderView.h"

@class Event, EventSegmentsController;
@class BarsFetcher, EventsFetcher;
@class Facebook, FBLoginButton;
@class Reachability;

@interface BarCrawlsViewController : UIViewController <EGORefreshTableHeaderDelegate, FBSessionDelegate, FBRequestDelegate,UITableViewDataSource, UITableViewDelegate> {    
    NSArray *eventsList;
    NSMutableArray *currentEvents;
    NSMutableArray *pastEvents;
    NSDictionary *barsDictionary;
    
    NSDateFormatter *dateFormatter;
    
    EventSegmentsController *eventSegmentsController;
    
    Facebook *facebook;
    FBLoginButton *fbLoginButton;
    
    UITableView *myTableView;
    UIActivityIndicatorView *spinner;
    UILabel *loadingLabel;
    
    EGORefreshTableHeaderView *refreshHeaderView;
    BOOL isReloading;
    BOOL minimumWaitCompleted;
    NSDate *lastUpdated;
}

@property (nonatomic, retain) EventSegmentsController *eventSegmentsController;
@property (nonatomic, retain) NSArray *eventsList;
@property (nonatomic, retain) NSMutableArray *currentEvents;
@property (nonatomic, retain) NSMutableArray *pastEvents;
@property (nonatomic, retain) NSDictionary *barsDictionary;
@property (nonatomic, retain) IBOutlet UIView *facebookView;
@property (nonatomic, retain) IBOutlet FBLoginButton *fbLoginButton;
@property (nonatomic, retain) IBOutlet UITableView *myTableView;
@property (nonatomic, retain) IBOutlet UIView *combinedView;
@property (nonatomic, retain) IBOutlet UIActivityIndicatorView *spinner;
@property (nonatomic, retain) IBOutlet UILabel *loadingLabel;
@property (nonatomic, retain) NSDate *lastUpdated;

- (IBAction)fbButtonClick:(id)sender;
- (void)loadEvents;
- (void)sortEvents;
- (NSString *)fuzzyDateFromDate:(NSDate *)date;
- (void)reloadTableViewDataSource;
- (void)doneLoadingTableViewData;
- (BOOL)isReachable;
- (void)spawnLoadingThread;
- (void)waitCompleted:(NSTimer *)theTimer;
@end
