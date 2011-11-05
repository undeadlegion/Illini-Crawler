//
//  EventGuestsViewController.h
//  CampusCrawler
//
//  Created by Dan  Kaufman on 3/6/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "FBConnect.h"
#import "CampusCrawlerAppDelegate.h"

#define ATTENDING 0
#define MAYBE_ATTENDING 1
#define NOT_ATTENDING 2
#define AWAITING_REPLY 3

@interface EventGuestsViewController : UIViewController <UITableViewDelegate,UITableViewDataSource,FBSessionDelegate, FBRequestDelegate> {
    BOOL retrievedResults;
    NSArray *alphabet;
    Facebook *facebook;
    
    NSArray *guests;
    NSArray *guestSectionSizes;
    NSArray *guestIndices;
    
    UITableView *myTableView;
    UIActivityIndicatorView *spinner;
    UILabel *loadingLabel;
    
    NSString *eventID;
    
    NSInteger guestType;
}

@property (nonatomic, retain) IBOutlet UITableView *myTableView;
@property (nonatomic, retain) IBOutlet UIActivityIndicatorView *spinner;
@property (nonatomic, retain) IBOutlet UILabel *loadingLabel;
@property (nonatomic, retain) NSArray *alphabet;
@property (nonatomic, retain) NSArray *guests;
@property (nonatomic, retain) NSArray *guestSectionSizes;
@property (nonatomic, retain) NSArray *guestIndices;
@property (nonatomic, retain) NSString *eventID;
@property (nonatomic) NSInteger guestType;

- (void)populateGuestsSectionAndIndices:(NSArray*)sortedGuests;
- (void)setTitleFromGuestType;

@end
