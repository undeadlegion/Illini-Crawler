//
//  EventWallViewController.h
//  CampusCrawler
//
//  Created by Dan  Kaufman on 3/13/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "FBConnect.h"
#import "CampusCrawlerAppDelegate.h"

#define POST_TO_WALL 0
#define WALL_POSTS 1

@interface EventWallViewController : UIViewController <UITableViewDelegate,UITableViewDataSource, FBRequestDelegate, FBDialogDelegate> {
    NSMutableArray *wallPosts;
    BOOL retrievedResults;
    
    UITableViewCell *wallPostCell;
    
    UITableView *myTableView;
    UIActivityIndicatorView *spinner;
    UILabel *loadingLabel;
    
    NSString *eventID;
}

@property (nonatomic, strong) IBOutlet UITableViewCell *wallPostCell;
@property (nonatomic, strong) IBOutlet UITableView *myTableView;
@property (nonatomic, strong) IBOutlet UIActivityIndicatorView *spinner;
@property (nonatomic, strong) IBOutlet UILabel *loadingLabel;
@property (nonatomic, strong) NSString *eventID;

- (IBAction)commentsButtonClick:(id)sender;

@end
