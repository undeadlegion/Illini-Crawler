//
//  EventDetailViewController.m
//  CampusCrawler
//
//  Created by James Lubowich on 2/16/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "BarsForEventViewController.h"
#import "Event.h"
#import "BarForEvent.h"
#import "BarDetailViewController.h"
#import "BarsForEventFetcher.h"
#import "Bar.h"
#import "CampusCrawlerAppDelegate.h"
#import "Reachability.h"

@implementation BarsForEventViewController
@synthesize currentEvent, serverURL;
@synthesize barsDictionary, currentBars, pastBars;
@synthesize lastUpdated;
@synthesize myTableView;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc
{
    [pastBars release];
    [currentBars release];
    [currentEvent release];
    [serverURL release];
    [barsDictionary release];
    [dateFormatter release];
    [refreshHeaderView release];
    [lastUpdated release];
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"h:mm a"];
//    NSLocale *uslocale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
//    [dateFormatter setLocale:uslocale];

    //refresh header view
    EGORefreshTableHeaderView *view = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0.0f, 0.0f - self.myTableView.bounds.size.height, self.view.frame.size.width, self.myTableView.bounds.size.height)];
    view.delegate = self;
    [self.myTableView addSubview:view];
    refreshHeaderView = view;
    [view release];
    
    self.myTableView.scrollEnabled = NO;
    self.lastUpdated = [NSDate date];
    [refreshHeaderView refreshLastUpdatedDate];
    
    self.barsDictionary = ((CampusCrawlerAppDelegate *)[[UIApplication sharedApplication] delegate]).barsDictionary;
    serverURL = [[NSURL alloc] initWithString:serverString];

}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [NSThread detachNewThreadSelector:@selector(spawnLoadingThread) toTarget:self withObject:nil];
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

#pragma mark - Table view data source
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(section == kCurrentSection)
        return [currentBars count];
    if(section == kPastSection)
        return [pastBars count];
    return 0;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if(section == kCurrentSection)
        return @"Current Bars";
    if(section == kPastSection)
        return @"Past Bars";
    return @"";
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
    }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    BarForEvent *barForEvent;
    
    if(indexPath.section == kCurrentSection){
        barForEvent = [currentBars objectAtIndex:indexPath.row];
    }
    if(indexPath.section == kPastSection){
        barForEvent = [pastBars objectAtIndex:indexPath.row];
    }
    
    Bar *bar = [barsDictionary objectForKey:barForEvent.barId];
    
    cell.textLabel.text = bar.name;
    cell.detailTextLabel.text = [dateFormatter stringFromDate:barForEvent.time];
    
    //image view resizing properties
    cell.imageView.contentMode = UIViewContentModeScaleAspectFit;
    cell.imageView.autoresizingMask = ( UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight );

    //scale the image
    CGSize size = CGSizeMake(50, 50);
    UIGraphicsBeginImageContext(size);
    [bar.quickLogo drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage *newThumbnail = UIGraphicsGetImageFromCurrentImageContext(); 
    UIGraphicsEndImageContext();
    if(newThumbnail == nil) 
        NSLog(@"could not scale image");
        
    cell.imageView.image = newThumbnail;

    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    BarDetailViewController *detailViewController = [[BarDetailViewController alloc] initWithNibName:@"BarDetailViewController" bundle:nil];
    
    BarForEvent *eventBar;
    if(indexPath.section == kCurrentSection)
        eventBar = [currentBars objectAtIndex:indexPath.row];
    if(indexPath.section == kPastSection)
        eventBar = [pastBars objectAtIndex:indexPath.row];
        
    detailViewController.currentBar = [barsDictionary objectForKey:eventBar.barId];
    detailViewController.currentDateId = currentEvent.dateId;
    [self.navigationController pushViewController:detailViewController animated:YES];
    [detailViewController release];
    
}

#pragma mark - Instance Methods

- (void)sortBarsForEvent{
    self.pastBars = [[[NSMutableArray alloc] init] autorelease];
    self.currentBars = [[[NSMutableArray alloc] init ] autorelease];
    for (BarForEvent *bar in currentEvent.barsForEvent) {
        if([bar isPast]){
            [pastBars addObject:bar];
        }
        else{
            [currentBars addObject:bar];
        }
    }
}

- (void)updateBarSpecials{
    for (BarForEvent *barForEvent in currentEvent.barsForEvent) {
        Bar *bar = [barsDictionary objectForKey:barForEvent.barId];
        [bar.specials setObject:barForEvent.specials forKey:currentEvent.dateId];
    }
}

- (void)scheduleNotifications{
    NSLog(@"ScheduleNotifications Called");
    NSArray *scheduledNotifications = [[UIApplication sharedApplication] scheduledLocalNotifications];
    NSLog(@"Count:%d", [currentEvent.barsForEvent count]);
    for (BarForEvent *barForEvent in currentEvent.barsForEvent){
        BOOL isScheduled = NO;
        for (UILocalNotification *notif in scheduledNotifications) {
            if([[notif.userInfo objectForKey:@"Id"] isEqualToString:currentEvent.eventId]){
                isScheduled = YES;
                break;
            }
        }
        //no need to schedule
        if(isScheduled)
            continue;
        
        //get the days and hours between now and the event
        NSCalendar *calendar = [NSCalendar currentCalendar];
        unsigned unitFlags = NSYearCalendarUnit|NSMonthCalendarUnit |NSDayCalendarUnit| NSHourCalendarUnit |NSMinuteCalendarUnit |NSSecondCalendarUnit;
        NSDateComponents *dateComps = [calendar components:unitFlags fromDate:[NSDate date] toDate:barForEvent.time options:0];
        int years = [dateComps year];
        int months = [dateComps month];
        int days = [dateComps day];
        int hours = [dateComps hour];
        int minutes = [dateComps minute];
        int seconds = [dateComps second];
        
        NSLog(@"Cheking %@ in the past", ((Bar*)[barsDictionary objectForKey:barForEvent.barId]).name);
        NSLog(@"Results: %d,%d,%d,%d,%d", years, months, days, hours, minutes);
        //of if in past
        //|| years != 0 || months != 0
        if(days < 0 || hours < 0)
            continue;
        NSLog(@"OK");
        
        //it's the day of
        if(days == 0 || days == 1 && hours == 0){
            NSLog(@"It's the day of");                  
            //schedule each of the bars
            UILocalNotification *notification;
            NSDictionary *infoDict;
            //0 minute warning
            if(minutes > 0 || seconds > 0){
                NSLog(@"Schedule 0 minute: %@", [NSDateFormatter localizedStringFromDate:barForEvent.time dateStyle:NSDateFormatterShortStyle timeStyle:NSDateFormatterShortStyle]);
                notification = [[UILocalNotification alloc] init];
                notification.fireDate = barForEvent.time;
                notification.timeZone = [NSTimeZone defaultTimeZone];
                notification.soundName = UILocalNotificationDefaultSoundName;
                NSString *message = [NSString stringWithFormat:@"Go to %@ NOW!", ((Bar*)[barsDictionary objectForKey:barForEvent.barId]).name];
                notification.alertBody = message;
                notification.alertAction = @"";
                infoDict = [NSDictionary dictionaryWithObjectsAndKeys:@"Bar", @"Type", currentEvent.eventId, @"Id", message, @"Message", barForEvent.time, @"Time", nil];
                notification.userInfo = infoDict;
                [[UIApplication sharedApplication] scheduleLocalNotification:notification];
                [notification release];            
            }
            //10 minute warning
            if(minutes > 10){
                NSLog(@"Schedule 10 minute: %@", [NSDateFormatter localizedStringFromDate:[barForEvent.time dateByAddingTimeInterval:-600] dateStyle:NSDateFormatterShortStyle timeStyle:NSDateFormatterShortStyle]);
                notification = [[UILocalNotification alloc] init];
                notification.fireDate = [barForEvent.time dateByAddingTimeInterval:-600];
                notification.timeZone = [NSTimeZone defaultTimeZone];
                notification.soundName = UILocalNotificationDefaultSoundName;
                NSString *message = [NSString stringWithFormat:@"Go to %@ in 10 minutes!", ((Bar*)[barsDictionary objectForKey:barForEvent.barId]).name];
                notification.alertBody = notification.alertBody = message;
                notification.alertAction = @"";
                infoDict = [NSDictionary dictionaryWithObjectsAndKeys:@"Bar", @"Type", currentEvent.eventId, @"Id", 
                            message, @"Message",[barForEvent.time dateByAddingTimeInterval:-600], @"Time", nil];
                notification.userInfo = infoDict;
                
                [[UIApplication sharedApplication] scheduleLocalNotification:notification];
                [notification release];
            }
            //15 minute warning
            if(minutes > 15){
                NSLog(@"Schedule 15 minute: %@", [NSDateFormatter localizedStringFromDate:[barForEvent.time dateByAddingTimeInterval:-900] dateStyle:NSDateFormatterShortStyle timeStyle:NSDateFormatterShortStyle]);
                notification = [[UILocalNotification alloc] init];
                notification.fireDate = [barForEvent.time dateByAddingTimeInterval:-900];
                notification.timeZone = [NSTimeZone defaultTimeZone];
                notification.soundName = UILocalNotificationDefaultSoundName;
                NSString *message = [NSString stringWithFormat:@"Go to %@ in 15 minutes!", ((Bar*)[barsDictionary objectForKey:barForEvent.barId]).name];
                notification.alertBody = notification.alertBody = message;
                notification.alertAction = @"";
                infoDict = [NSDictionary dictionaryWithObjectsAndKeys:@"Bar", @"Type", currentEvent.eventId, @"Id", message, @"Message",[barForEvent.time dateByAddingTimeInterval:-900], @"Time", nil];
                notification.userInfo = infoDict;
                
                [[UIApplication sharedApplication] scheduleLocalNotification:notification];
                [notification release];
                
            }
        }
    }
    
}
- (void)loadBarsForEvent{
    
    //bars already loaded
    if(self.currentEvent.barsForEvent && !isReloading){
        return;
    }
    BarsForEventFetcher *barsForEventFetcher = [[BarsForEventFetcher alloc] init];
    NSString *eventBarsPath;
    if(useServer){
        eventBarsPath = [barsForEventRequestString stringByAppendingString:currentEvent.eventId];
    }
    else{
        eventBarsPath = [[NSBundle mainBundle] pathForResource:@"barsForEvent" ofType:@"xml"];
    }
    NSLog(@"eventPath:%@", eventBarsPath);
    self.currentEvent.barsForEvent = [barsForEventFetcher fetchEventBarsFromPath:eventBarsPath relativeTo:serverURL withEvent:currentEvent isURL:useServer];
    [barsForEventFetcher release];
}


- (void)spawnLoadingThread{
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];    
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
        
    NSLog(@"Checking Network...");
    //network is okay
    if([self isReachable]){
        NSLog(@"Reachable");
        [self loadBarsForEvent];
        [self scheduleNotifications];
        [self sortBarsForEvent];
        [self updateBarSpecials];
        self.lastUpdated = [NSDate date];
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

    //reset view
    self.myTableView.scrollEnabled = YES;
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    [myTableView reloadData];
    
    [pool release];
}

- (BOOL)isReachable{
    Reachability *r = [Reachability reachabilityWithHostName:reachabilityString];
    NetworkStatus internetStatus = [r currentReachabilityStatus];
    if(internetStatus == NotReachable) {
        return NO;
    }
    return YES;
}
- (void)doneLoadingTableViewData{
    isReloading = NO;
    [refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:self.myTableView];
    
}

- (void)reloadTableViewDataSource{
    isReloading = YES;
    [NSThread detachNewThreadSelector:@selector(spawnLoadingThread) toTarget:self withObject:nil];
}

- (void)waitCompleted:(NSTimer *)theTimer{
    minimumWaitCompleted = YES;
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
