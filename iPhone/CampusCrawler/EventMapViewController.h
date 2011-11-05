//
//  EventMapViewController.h
//  CampusCrawler
//
//  Created by James Lubowich on 2/22/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@class Event;
@interface EventMapViewController : UIViewController<MKMapViewDelegate> {
    Event *currentEvent;
    NSURL *serverURL;
    UISegmentedControl *viewToggle;
    MKMapView *mapView;
    MKPinAnnotationView *annotationView;
    NSDictionary *barsDictionary;
    NSMutableArray *barAnnotations;
}

@property (nonatomic, retain) Event *currentEvent;
@property (nonatomic, copy) NSURL *serverURL;
@property (nonatomic, retain) UISegmentedControl *viewToggle;
@property (nonatomic, retain) IBOutlet MKMapView *mapView;
@property (nonatomic, retain) NSDictionary *barsDictionary;

- (void)showDetails:(id)sender;
@end
