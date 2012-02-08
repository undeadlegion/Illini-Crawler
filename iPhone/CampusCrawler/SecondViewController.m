//
//  SecondViewController.m
//  CampusCrawler
//
//  Created by James Lubowich on 2/5/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "SecondViewController.h"
#import "CampusCrawlerAppDelegate.h"
#import "FBLoginButton.h"
#import "FBConnect.h"
#import "WallPost.h"
#import "Constants.h"

@implementation SecondViewController

@synthesize fbLoginButton, myTableView, facebook, profileButton;


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    facebook = ((CampusCrawlerAppDelegate *)[[UIApplication sharedApplication] delegate]).facebook;
    if(facebook.accessToken)
        fbLoginButton.isLoggedIn = YES;
    [fbLoginButton updateImage];

    if(useServer)
        profileButton.titleLabel.text = @"Using Server";
    else
        profileButton.titleLabel.text = @"Using Disk";
        
    retrievedResults = NO;
    wallPosts = [[NSMutableArray alloc] init];
}
- (void)viewWillAppear:(BOOL)animated{
    [fbLoginButton updateImage];
}

- (id)initWithCoder:(NSCoder *)aDecoder{
    if ([super initWithCoder:aDecoder]) {
        fbLoginButton.isLoggedIn = NO;
    }
    return self;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}


- (void)viewDidUnload
{
    [super viewDidUnload];

    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


#pragma mark - Facebook
/**
 * Called after user has logged in.
 */
- (void)fbDidLogin{
    fbLoginButton.isLoggedIn = YES;
    [fbLoginButton updateImage];
    [facebook requestWithGraphPath:@"me" andDelegate:self];
    NSLog(@"Expiration Date: %@",facebook.expirationDate);

}
- (void)fbDidLogout{
    fbLoginButton.isLoggedIn = NO;
    [fbLoginButton updateImage];
    profileButton.titleLabel.text = @"Profile Name";
}
/**
 * Show the authorization dialog.
 */
- (void)login {
    //view permissions at http://developers.facebook.com/docs/authentication/permissions/
    NSArray* permissions =  [NSArray arrayWithObjects:
                              @"user_events",  nil];//@"offline_access",
    
    [facebook authorize:permissions];
}

/**
 * Invalidate the access token and clear the cookie.
 */
- (void)logout {
    [facebook logout];
}
/**
 * Called on a login/logout button click.
 */
- (IBAction)fbButtonClick:(id)sender {
    if (fbLoginButton.isLoggedIn) {
        [self logout];
    } else {
        [self login];
    }
}

- (IBAction)otherButtonClick:(id)sender {
    if ( [facebook requestWithGraphPath:@"115347338524468/feed" andDelegate:self] == nil)
        [sender setTitle:@"Logged Out" forState:UIControlStateNormal];
    currentSender = sender;

}

#pragma mark - Table view data source

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (!retrievedResults) {
        static NSString *CellIdentifier = @"Cell";
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        }
        
        return cell;
    }
    
    else {
        static NSString *CellIdentifier = @"Cell";
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        }
        
        if (indexPath.row < [wallPosts count]) {
            WallPost *cellWallPost = [wallPosts objectAtIndex:indexPath.row];
            cell.textLabel.text = cellWallPost.name;
            cell.detailTextLabel.text = cellWallPost.message;
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
        else{
            cell.textLabel.text = @"";
            cell.detailTextLabel.text = @"";
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
        return cell;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [wallPosts count];
}


/**
 * Called when a request returns and its response has been parsed into
 * an object.
 *
 * The resulting object may be a dictionary, an array, a string, or a number,
 * depending on thee format of the API response.
 */
- (void)request:(FBRequest *)request didLoad:(id)result {
    if ([result isKindOfClass:[NSArray class]]) {
        result = [result objectAtIndex:0];
    }
    
    NSLog(@"Received result: %@", result);
    if([result objectForKey:@"name"]){
        [profileButton.titleLabel setText:[result objectForKey:@"name"]];
    }
    else{
        for (NSDictionary *wallPostings in [result objectForKey:@"data"])
        {
            id name = [[wallPostings objectForKey:@"from"] objectForKey:@"name"];
            id message = [wallPostings objectForKey:@"message"];
            WallPost *curPost = [[WallPost alloc] init];
            curPost.name = name;
            curPost.message = message;
            [wallPosts addObject:curPost];
        }
            retrievedResults = YES;
            [myTableView reloadData];
    }
    if([result objectForKey:@"id"]){
        facebook.userId = [result objectForKey:@"id"];
    }
}

- (IBAction)profileButtonClick:(id)sender{
    useServer = !useServer;

    if(useServer)
        profileButton.titleLabel.text = @"Using Server";
    else
        profileButton.titleLabel.text = @"Using Disk";
}

- (void)request:(FBRequest *)request didFailWithError:(NSError *)error {
    NSLog(@"REQUEST FAILED");
}

@end