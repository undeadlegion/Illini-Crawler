//
//  CampusCrawlerAppDelegate.h
//  CampusCrawler
//
//  Created by James Lubowich on 2/5/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "FBConnect.h"   

@class Event, Reachability;
@interface CampusCrawlerAppDelegate : NSObject <UIApplicationDelegate, UITabBarControllerDelegate, FBSessionDelegate> {
    Facebook *facebook;
    NSDictionary *barsDictionary;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet UITabBarController *tabBarController;
@property (nonatomic, retain) Facebook *facebook;
@property (nonatomic, retain) NSDictionary *barsDictionary;
- (void)loadBars;
- (void)showAlert:(NSString*)pushmessage withTitle:(NSString*)title;
- (void)spawnLoadingThread;
- (BOOL)isReachable;
@end
