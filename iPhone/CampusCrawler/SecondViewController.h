//
//  SecondViewController.h
//  CampusCrawler
//
//  Created by James Lubowich on 2/5/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Facebook, FBLoginButton, WallPost;

#import "FBConnect.h"

@interface SecondViewController : UIViewController <FBSessionDelegate, FBRequestDelegate, UITableViewDelegate, UITableViewDataSource> {
    
    FBLoginButton *fbLoginButton;
    Facebook *facebook;
    
    NSString *fullName;
    id currentSender;
    //UITableView *myTableView;
    BOOL retrievedResults;
    NSMutableArray *wallPosts;
    WallPost *currentWallPost;
}
@property (nonatomic, retain) IBOutlet UITableView *myTableView;
@property (nonatomic, retain) IBOutlet FBLoginButton *fbLoginButton;
@property (nonatomic, retain) Facebook *facebook;
@property (nonatomic, retain) IBOutlet UIButton *profileButton;

- (IBAction)fbButtonClick:(id)sender;
- (IBAction)profileButtonClick:(id)sender;
@end
