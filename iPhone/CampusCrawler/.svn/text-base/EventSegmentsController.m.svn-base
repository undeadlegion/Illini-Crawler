//
//  EventSegmentsController.m
//  CampusCrawler
//
//  Created by James Lubowich on 2/22/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "EventSegmentsController.h"
#import "BarsForEventViewController.h"
#import "EventInfoViewController.h"
#import "EventMapViewController.h"
#import "Event.h"
#import "Constants.h"

@interface EventSegmentsController ()
@property (nonatomic, retain, readwrite) UINavigationController *navigationController;
@property (nonatomic, retain, readwrite) NSArray *viewControllers;
@end

@implementation EventSegmentsController
@synthesize navigationController, viewControllers, viewToggle;
@synthesize serverURL, currentEvent, barsDictionary;

- (id)initWithNavigationController:(UINavigationController *)aNavigationController
                   viewControllers:(NSArray *)theViewControllers{
    
    if((self = [super init])){
        self.navigationController = aNavigationController;
        self.viewControllers = theViewControllers;
    }
    return self;
}

- (id)initWithNavigationController:(UINavigationController *)theNavigationController{
    if((self = [super init])){
        self.navigationController = theNavigationController;
        [self initSegmentViewControllers];
        [self initViewToggle];
    }
    return self;
}

- (void)indexDidChangeForSegmentedControl:(UISegmentedControl *)segmentedControl{
    //don't push view if just setting the index
    if(isResettingIndex){
        isResettingIndex = NO;
        return;
    }
        
    NSUInteger index = segmentedControl.selectedSegmentIndex;
    UIViewController *incomingViewController = [viewControllers objectAtIndex:index];
    incomingViewController.navigationItem.titleView = segmentedControl;
    incomingViewController.navigationItem.prompt = @"View Event Details";
    
    ((EventInfoViewController *)incomingViewController).currentEvent = currentEvent;
    
    [navigationController popViewControllerAnimated:NO];
    [navigationController pushViewController:incomingViewController animated:NO];

}

- (void)pushFirstViewController{
    //setting the index sometimes triggers the target action
    isResettingIndex = YES;
    viewToggle.selectedSegmentIndex = 0;

    BarsForEventViewController *firstViewController = (BarsForEventViewController *)[viewControllers objectAtIndex:viewToggle.selectedSegmentIndex];
    firstViewController.currentEvent = currentEvent;
    firstViewController.navigationItem.prompt = @"View Event Details";
    firstViewController.navigationItem.titleView = viewToggle;
    [navigationController pushViewController:firstViewController animated:YES];

    //target action only sometimes goes off - make sure to reset flag
    if(isResettingIndex)
        isResettingIndex = NO;
}

- (void)initViewToggle{
    
    //change to the titles of the views
    viewToggle = [[UISegmentedControl alloc]
                  initWithItems:[NSArray arrayWithObjects:@"Itenerary",
                                 @"Info", @"Map", nil]];
    
    viewToggle.segmentedControlStyle = UISegmentedControlStyleBar;
    viewToggle.frame = CGRectMake(0, 0, 400, kCustomButtonHeight);
    viewToggle.selectedSegmentIndex = 0;
    [viewToggle addTarget:self action:@selector(indexDidChangeForSegmentedControl:)
         forControlEvents:UIControlEventValueChanged];
}

- (void)initSegmentViewControllers{
    BarsForEventViewController *detailViewController = [[[BarsForEventViewController alloc] initWithNibName:@"BarsForEventViewController" bundle:nil] autorelease];
    EventInfoViewController *infoViewController = [[[EventInfoViewController alloc] initWithNibName:@"EventInfoViewController" bundle:nil] autorelease];
    EventMapViewController *mapViewController = [[[EventMapViewController alloc] initWithNibName:@"EventMapViewController" bundle:nil] autorelease];
    
    viewControllers = [[NSArray alloc] initWithObjects:detailViewController,infoViewController, mapViewController,nil];
}

- (void)dealloc
{
    [navigationController release];
    [viewControllers release];
    [serverURL release];
    [currentEvent release];
    [barsDictionary release];
    [viewToggle release];
    [super dealloc];
}
@end
