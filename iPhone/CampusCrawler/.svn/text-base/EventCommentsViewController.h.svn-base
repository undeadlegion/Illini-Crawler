//
//  EventCommentsViewController.h
//  CampusCrawler
//
//  Created by Dan  Kaufman on 4/4/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WallPost.h"
#import "CampusCrawlerAppDelegate.h"

@interface EventCommentsViewController : UIViewController <UITableViewDelegate,UITableViewDataSource,FBRequestDelegate,FBSessionDelegate> {
    UITableViewCell *wallPostCell;
    WallPost *wallPost;
    
    BOOL retrievedResults;
    
    UITableView *myTableView;
    UIActivityIndicatorView *spinner;
    UILabel *loadingLabel;
}

@property (nonatomic, retain) IBOutlet UITableViewCell *wallPostCell;
@property (nonatomic, retain) IBOutlet WallPost *wallPost;
@property (nonatomic, retain) IBOutlet UITableView *myTableView;
@property (nonatomic, retain) IBOutlet UIActivityIndicatorView *spinner;
@property (nonatomic, retain) IBOutlet UILabel *loadingLabel;

- (void)loadComments;

@end
