//
//  MyCrawlsViewController.m
//  CampusCrawler
//
//  Created by James Lubowich on 2/5/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "BarCrawlsViewController.h"
#import "EventSegmentsController.h"
#import "Event.h"
#import "EventsFetcher.h"
#import "CampusCrawlerAppDelegate.h"
#import "Facebook.h"
#import "FBLoginButton.h"
#import "BarForEvent.h"
#import "Bar.h"
#import "Reachability.h"

@implementation BarCrawlsViewController
@synthesize eventSegmentsController, barsDictionary, eventsList;
@synthesize currentEvents, pastEvents;
@synthesize facebookView, fbLoginButton;
@synthesize myTableView;
@synthesize spinner, combinedView, loadingLabel;
@synthesize lastUpdated;

- (id)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if (self) {
    }
    return self;
}



- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}


#pragma mark - 
#pragma mark View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSLog(@"My crawls - view did load");
    
    //date formatting
    dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MM/dd/yy"];
    
    eventSegmentsController = [[EventSegmentsController alloc] initWithNavigationController:self.navigationController ];

    //fb button
    fbLoginButton.isLoggedIn = NO;
    [fbLoginButton updateImage];
    
    //refresh header view
    EGORefreshTableHeaderView *view = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0.0f, 0.0f - self.myTableView.bounds.size.height, self.view.frame.size.width, self.myTableView.bounds.size.height)];
    view.delegate = self;
    [self.myTableView addSubview:view];
    refreshHeaderView = view;

    self.myTableView.scrollEnabled = NO;
    
    self.lastUpdated = [NSDate date];
    
    //  update the last update date
    [refreshHeaderView refreshLastUpdatedDate];

    //set facebook object
    CampusCrawlerAppDelegate *appDelegate = (CampusCrawlerAppDelegate*)[[UIApplication sharedApplication] delegate];
    facebook = appDelegate.facebook;
    facebook.sessionDelegate = self;

    currentEvents = [[NSMutableArray alloc] init ];
    pastEvents = [[NSMutableArray alloc] init ];
    
    //is logged in or viewing public crawls
    if(facebook.userId || [self.title isEqualToString:@"Public Crawls"]){
        [spinner startAnimating];
        [NSThread detachNewThreadSelector:@selector(spawnLoadingThread) toTarget:self withObject:nil];
    }
}

- (void)viewDidUnload
{
    [self setSpinner:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    //deselect cell
    [myTableView deselectRowAtIndexPath:[myTableView indexPathForSelectedRow] animated:animated];
    
    //show facebook screen if not logged in
    if(facebook.userId == nil && [self.title isEqualToString:@"My Crawls"]){
        self.view = facebookView;
    }
    //otherwise show tableview
    else{
        self.view = combinedView;
    }
    
}
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}
- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


#pragma mark - 
#pragma mark Table view data source

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    //only show sections after events have been loaded
    if([spinner isAnimating])
        return 0;
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(section == kCurrentSection)
        return [currentEvents count];
    if(section == kPastSection)
        return [pastEvents count];
    return 0;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    //sometimes number of sections in table isn't called
    if([spinner isAnimating])
        return @"";
        
    if(section == kCurrentSection)
        return @"Current Events";
    if(section == kPastSection)
        return @"Past Events";
    return @"";
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    Event *cellEvent;
    if(indexPath.section == kCurrentSection)
        cellEvent = [currentEvents objectAtIndex:indexPath.row];
    if(indexPath.section == kPastSection)
        cellEvent = [pastEvents objectAtIndex:indexPath.row];
        
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    cell.textLabel.text = cellEvent.title;
    cell.detailTextLabel.text = [self fuzzyDateFromDate:cellEvent.date];
//    [dateFormatter stringFromDate:cellEvent.date];
    
    return cell;
}


#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    Event *selectedEvent;
    if(indexPath.section == kCurrentSection)
        selectedEvent = [currentEvents objectAtIndex:indexPath.row];
    if(indexPath.section == kPastSection)
        selectedEvent = [pastEvents objectAtIndex:indexPath.row];
    eventSegmentsController.currentEvent = selectedEvent;
    eventSegmentsController.barsDictionary = barsDictionary;
    [eventSegmentsController pushFirstViewController];
}


#pragma mark - 
#pragma mark Facebook

- (void)fbDidLogin{
    [facebook requestWithGraphPath:@"me" andDelegate:self];
    NSLog(@"Expiration Date: %@",facebook.expirationDate);
    [spinner startAnimating];
    self.view = combinedView;
}
- (void)fbDidNotLogin:(BOOL)cancelled{
    //is facebook access token nil?
    NSLog(@"Login Cancelled");
}
- (void)fbDidLogout{
    fbLoginButton.isLoggedIn = NO;
    [fbLoginButton updateImage];
}
- (IBAction)fbButtonClick:(id)sender {
    //login to facebook
    NSArray* permissions =  [NSArray arrayWithObjects:
                              @"user_events",  nil];//@"offline_access",
    
    [facebook authorize:permissions];
}
//request completed 
//can be dict, array, string ,or number
- (void)request:(FBRequest *)request didLoad:(id)result {
    if ([result isKindOfClass:[NSArray class]]) {
        result = [result objectAtIndex:0];
    }
    if([result objectForKey:@"id"]){
        facebook.userId = [result objectForKey:@"id"];
        NSLog(@"Facebook Id:%@", facebook.userId);
        [NSThread detachNewThreadSelector:@selector(spawnLoadingThread) toTarget:self withObject:nil];
    }
}
//error in FB request
- (void)request:(FBRequest *)request didFailWithError:(NSError *)error{
    NSLog(@"Request Failed");
}

- (void)fbSessionInvalidated{
    NSLog(@"Fb Session Invalidated");
}

- (void)fbDidExtendToken:(NSString*)accessToken
               expiresAt:(NSDate*)expiresAt{
    NSLog(@"Fb Did Extend Token");
}

#pragma mark - 
#pragma mark Data Loading

- (void)loadEvents{
    NSString *eventsPath;
    NSURL *serverURL = [NSURL URLWithString:serverString];
    EventsFetcher *eventsFetcher = [[EventsFetcher alloc] init];

    //load data from server
    if(useServer){
        NSLog(@"Loading Events from Server");
        //my Crawls
        if([self.title isEqualToString:@"My Crawls"]){
            eventsPath = [eventsRequestString stringByAppendingString:facebook.userId];
        }
        //public Crawls
        else{
            eventsPath = publicEventsRequestString;
        }
    }
    //load from disk
    else{
        NSLog(@"Loading Events From Disk");
        eventsPath = [[NSBundle mainBundle] pathForResource:@"events" ofType:@"xml"];
    }
    
    self.eventsList = [eventsFetcher fetchEventsFromPath:eventsPath relativeTo:serverURL isURL:useServer];

    //hack to wait for all bars to be loaded
    while( barsDictionary == nil){
        self.barsDictionary = ((CampusCrawlerAppDelegate *)[[UIApplication sharedApplication] delegate]).barsDictionary;
    }
    
}

- (void)spawnLoadingThread{
    @autoreleasepool {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
        
        NSLog(@"Checking Network...");
        //network is okay
        if([self isReachable]){
            NSLog(@"Reachable");
            [self loadEvents];
            self.lastUpdated = [NSDate date];
            [self sortEvents];
        }
        //network not working
        else{
            CampusCrawlerAppDelegate *delegate = (CampusCrawlerAppDelegate *)[[UIApplication sharedApplication] delegate];
            [delegate showAlert:@"Network Connection Unavailable" withTitle:@"Connection Error"];
        }
        
        //loading spawned from pull to refresh
        if(isReloading){
            while(!minimumWaitCompleted){}
            [self doneLoadingTableViewData];
        }
        
        //reset everything in the view
        [spinner stopAnimating];
        spinner.hidden = YES;
        loadingLabel.hidden = YES;
        self.myTableView.scrollEnabled = YES;
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        [myTableView reloadData];

    }
}

- (BOOL)isReachable{
    Reachability *r = [Reachability reachabilityWithHostName:reachabilityString];
    NetworkStatus internetStatus = [r currentReachabilityStatus];
    if(internetStatus == NotReachable) {
        return NO;
    }
    return YES;
}
- (void)reloadTableViewDataSource{
    isReloading = YES;
    [NSThread detachNewThreadSelector:@selector(spawnLoadingThread) toTarget:self withObject:nil];
    //bars also need to be reloaded
    if(self.barsDictionary == nil){
        CampusCrawlerAppDelegate *delegate = (CampusCrawlerAppDelegate *)[[UIApplication sharedApplication] delegate];
        [delegate spawnLoadingThread];
    }
}
- (void)doneLoadingTableViewData{
    isReloading = NO;
	[refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:self.myTableView];
}
- (void)waitCompleted:(NSTimer *)theTimer{
    minimumWaitCompleted = YES;
}
#pragma mark -
#pragma mark Date Methods


- (void)sortEvents{
    self.pastEvents = [[NSMutableArray alloc] init];
    self.currentEvents = [[NSMutableArray alloc] init];
    for (Event *event in eventsList) {
        if([event isPast]){
            [pastEvents insertObject:event atIndex:0];
        }
        else{
            [currentEvents addObject:event];
        }
    }
}

- (NSString *)fuzzyDateFromDate:(NSDate *)date{
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    unsigned unitFlags = NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit| NSHourCalendarUnit;
    NSDateComponents *dateComps = [calendar components:unitFlags fromDate:[NSDate date] toDate:date options:0];
    int year = [dateComps year];
    int months = [dateComps month];
    int days = [dateComps day];
    
    if(year == 0 && months >= 0 && days >= 0){
        if(months == 0){
            if(days == 0)
                return [NSString stringWithString:@"Today"];
            if(days == 1)
                return [NSString stringWithString:@"Tomorrow"];
            if(days == 2)
                return [NSString stringWithString:@"Two Days"];
            if(days == 3)
                return [NSString stringWithString:@"Three Days"];
            if(days < 5)
                return [NSString stringWithString:@"A Few Days"];
            if(days < 10)
                return [NSString stringWithString:@"A Week"];
            if(days < 17)
                return [NSString stringWithString:@"Two Weeks"];
            return [NSString stringWithString:@"A Few Weeks"];
        }
        if(months == 1)
            return [NSString stringWithString:@"A Month"];
        if(months == 2)
            return [NSString stringWithString:@"Two Months"];
        if(months == 3)
            return [NSString stringWithString:@"A Couple Months"];
        if(months < 6)
            return [NSString stringWithString:@"A Few Months"];
    }
    return [dateFormatter stringFromDate:date];
}


#pragma mark -
#pragma mark UIScrollViewDelegate Methods

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{	
	
	[refreshHeaderView egoRefreshScrollViewDidScroll:scrollView];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
	
	[refreshHeaderView egoRefreshScrollViewDidEndDragging:scrollView];
}


#pragma mark -
#pragma mark EGORefreshTableHeaderDelegate Methods

- (void)egoRefreshTableHeaderDidTriggerRefresh:(EGORefreshTableHeaderView*)view{
	
    minimumWaitCompleted = NO;
    [NSTimer scheduledTimerWithTimeInterval:1.5 target:self selector:@selector(waitCompleted:) userInfo:nil repeats:NO];
	[self reloadTableViewDataSource];	
}

- (BOOL)egoRefreshTableHeaderDataSourceIsLoading:(EGORefreshTableHeaderView*)view{
	
	return isReloading;
}

- (NSDate*)egoRefreshTableHeaderDataSourceLastUpdated:(EGORefreshTableHeaderView*)view{
	
	return lastUpdated;
}
@end