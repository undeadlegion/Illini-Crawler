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

@property (nonatomic, strong, readonly) UINavigationController *navigationController;
@property (nonatomic, strong, readonly) NSArray *viewControllers;
@property (nonatomic, strong) NSURL *serverURL;
@property (nonatomic, strong) Event *currentEvent;
@property (nonatomic, strong) NSDictionary *barsDictionary;
@property (nonatomic, strong) UISegmentedControl *viewToggle;

- (id)initWithNavigationController:(UINavigationController *)navigationController
               viewControllers:(NSArray *)viewControllers;
               
- (id)initWithNavigationController:(UINavigationController *)navigationController;
- (void)indexDidChangeForSegmentedControl:(UISegmentedControl *)segmentedControl;
- (void)pushFirstViewController;
- (void)initSegmentViewControllers;
- (void)initViewToggle;

@end
