//
//  CampusCrawlerAppDelegate.m
//  CampusCrawler
//
//  Created by James Lubowich on 2/5/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "CampusCrawlerAppDelegate.h"
#import "BarsFetcher.h"
#import "Bar.h"
#import "Event.h"
#import "BarForEvent.h"
#import "Reachability.h"

@implementation CampusCrawlerAppDelegate

@synthesize facebook;
@synthesize window=_window;
@synthesize tabBarController=_tabBarController;
@synthesize barsDictionary;

NSString *campus_crawlerId = @"183973304975501";
NSString *campusCrawlerId = @"193718833988727";

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];

    //when the user hasn't set the setting it will be NO
    [defaults registerDefaults:[NSDictionary dictionaryWithObject:@"NO" forKey:@"Logout"]];

    //if logout is enabled
    if([defaults boolForKey:@"Logout"]){
        [defaults removeObjectForKey:@"Access Token"];
        [defaults removeObjectForKey:@"Expiration Date"];
        [defaults removeObjectForKey:@"UserId"];
        [defaults setBool:NO forKey:@"Logout"];
        [defaults synchronize];
    }
    
    facebook = [[Facebook alloc] initWithAppId:campus_crawlerId];
    
    NSString *accessToken = [defaults valueForKey:@"Access Token"];
    NSDate *expirationDate = [defaults valueForKey:@"Expiration Date"];
    NSString *userId = [defaults valueForKey:@"UserId"];
    
    if(accessToken != nil){
        facebook.accessToken = accessToken;
        facebook.expirationDate = expirationDate;
        facebook.userId = userId;
        NSLog(@"Loaded FB Authentication from disk");
    }
    else{
        NSLog(@"FB Authentication NOT loaded");
    }
    
    //spawn thread to load bars
    [self spawnLoadingThread];
    
    //check if opened by an notification
    UILocalNotification *notif = [launchOptions objectForKey:UIApplicationLaunchOptionsLocalNotificationKey];
    if(notif != nil){
        NSLog(@"App opened by Notifciation in DidFinishLaunching");
//        [self scheduleAlertsWithNotification:notif];
    }
    
    //hack for testing event
    [[UIApplication sharedApplication] cancelAllLocalNotifications];

    // Add the tab bar controller's current view as a subview of the window
    self.window.rootViewController = self.tabBarController;
    [self.window makeKeyAndVisible];
    
    return YES;
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
    
    return [facebook handleOpenURL:url]; 
}
- (BOOL)isReachable{
    Reachability *r = [Reachability reachabilityWithHostName:reachabilityString];
    NetworkStatus internetStatus = [r currentReachabilityStatus];
    if(internetStatus == NotReachable) {
        return NO;
    }
    return YES;
}
- (void)spawnLoadingThread{
    if([self isReachable]){
        [NSThread detachNewThreadSelector:@selector(loadBars) toTarget:self withObject:nil];
    }
}
- (void)loadBars{
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];    

    BarsFetcher *barsFetcher = [[[BarsFetcher alloc] init] autorelease];
    NSString *barsPath;
    NSURL *serverURL = [[[NSURL alloc] initWithString:serverString] autorelease];    

    //load from server
    if(useServer){
        NSLog(@"Loading Bars from Server");
        barsPath = barRequestString;
    }
    //load from disk
    else{
        NSLog(@"Loading Bars from Disk");
        barsPath = [[NSBundle mainBundle] pathForResource:@"bars" ofType:@"xml"];
    }

    self.barsDictionary = [barsFetcher fetchBarsFromPath:barsPath relativeTo:serverURL isURL:useServer];
    [pool release];
}

- (void) showAlert:(NSString*)pushmessage withTitle:(NSString*)title
{
    UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:title message:pushmessage delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alertView show];
    if (alertView) {
        [alertView release];
    }
}

// Handle the notificaton when the app is running
- (void)application:(UIApplication *)app didReceiveLocalNotification:(UILocalNotification *)notif {
    NSLog(@"Did Receive Local Notification %@",notif);
    NSLog(@"Notifications before: %d", [[[UIApplication sharedApplication] scheduledLocalNotifications] count]);
    [[UIApplication sharedApplication] cancelLocalNotification:notif];    
    NSLog(@"Notifications after: %d", [[[UIApplication sharedApplication] scheduledLocalNotifications] count]);
    NSString *message = [notif.userInfo objectForKey:@"Message"];
    [self showAlert:message withTitle:@"Campus Crawler"];
    
    //schedule alerts for the bars
    if([[notif.userInfo objectForKey:@"Type"] isEqualToString:@"Event Start"]){
        //decrement the badge number
        
//        Event *scheduledEvent = [NSKeyedUnarchiver unarchiveObjectWithData:[notif.userInfo objectForKey:@"Event Data"]];
//        [self scheduleBarAlertsForEvent:scheduledEvent];
    }
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
     */
    [[NSUserDefaults standardUserDefaults] setValue:facebook.accessToken forKey:@"Access Token"];
    [[NSUserDefaults standardUserDefaults] setValue:facebook.expirationDate forKey:@"Expiration Date"];
    [[NSUserDefaults standardUserDefaults] setValue:facebook.userId forKey:@"UserId"];
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    /*
     Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
     */
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    /*
     Called when the application is about to terminate.
     Save data if appropriate.
     See also applicationDidEnterBackground:.
     */
}

- (void)dealloc
{
    [_window release];
    [_tabBarController release];
    [facebook release];
    [barsDictionary release];
    [super dealloc];
}


- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController
{
    if(tabBarController.selectedIndex == 1){
        viewController.title = @"Public Crawls";
    }
    else{
        viewController.title = @"My Crawls";
    }
}

@end