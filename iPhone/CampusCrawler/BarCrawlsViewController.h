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

@property (nonatomic, strong) EventSegmentsController *eventSegmentsController;
@property (nonatomic, strong) NSArray *eventsList;
@property (nonatomic, strong) NSMutableArray *currentEvents;
@property (nonatomic, strong) NSMutableArray *pastEvents;
@property (nonatomic, strong) NSDictionary *barsDictionary;
@property (nonatomic, strong) IBOutlet UIView *facebookView;
@property (nonatomic, strong) IBOutlet FBLoginButton *fbLoginButton;
@property (nonatomic, strong) IBOutlet UITableView *myTableView;
@property (nonatomic, strong) IBOutlet UIView *combinedView;
@property (nonatomic, strong) IBOutlet UIActivityIndicatorView *spinner;
@property (nonatomic, strong) IBOutlet UILabel *loadingLabel;
@property (nonatomic, strong) NSDate *lastUpdated;

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
