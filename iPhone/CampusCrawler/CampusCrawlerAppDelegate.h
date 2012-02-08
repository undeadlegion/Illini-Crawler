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
@interface CampusCrawlerAppDelegate : NSObject <UIApplicationDelegate, UITabBarControllerDelegate> {
    Facebook *facebook;
    NSDictionary *barsDictionary;
}

@property (nonatomic, strong) IBOutlet UIWindow *window;
@property (nonatomic, strong) IBOutlet UITabBarController *tabBarController;
@property (nonatomic, strong) Facebook *facebook;
@property (nonatomic, strong) NSDictionary *barsDictionary;
- (void)loadBars;
- (void)showAlert:(NSString*)pushmessage withTitle:(NSString*)title;
- (void)spawnLoadingThread;
- (BOOL)isReachable;
@end
