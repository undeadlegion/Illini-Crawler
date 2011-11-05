//
//  EventSegmentsController.h
//  CampusCrawler
//
//  Created by James Lubowich on 2/22/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Event;
@interface EventSegmentsController : NSObject {
    UINavigationController *navigationController;
    NSArray *viewControllers;
    NSURL *serverURL;
    Event *currentEvent;
    NSDictionary *barsDictionary;
    UISegmentedControl *viewToggle;
    BOOL isResettingIndex;
}

@property (nonatomic, retain, readonly) UINavigationController *navigationController;
@property (nonatomic, retain, readonly) NSArray *viewControllers;
@property (nonatomic, retain) NSURL *serverURL;
@property (nonatomic, retain) Event *currentEvent;
@property (nonatomic, retain) NSDictionary *barsDictionary;
@property (nonatomic, retain) UISegmentedControl *viewToggle;

- (id)initWithNavigationController:(UINavigationController *)navigationController
               viewControllers:(NSArray *)viewControllers;
               
- (id)initWithNavigationController:(UINavigationController *)navigationController;
- (void)indexDidChangeForSegmentedControl:(UISegmentedControl *)segmentedControl;
- (void)pushFirstViewController;
- (void)initSegmentViewControllers;
- (void)initViewToggle;

@end
