//
//  MyClass.m
//  CampusCrawler
//
//  Created by James Lubowich on 3/14/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "customNavigationController.h"


@implementation customNavigationController

- (UIViewController *)popViewControllerAnimated:(BOOL)animated{
    NSLog(@"Pop View!");
    
    UIViewController *lastViewController = [self.viewControllers lastObject];
    if(lastViewController.navigationItem.prompt != nil){
        NSLog(@"Custom pop");
        
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration: 1.00];
        [UIView setAnimationTransition:UIViewAnimationTransitionCurlDown forView:self.view cache:NO];

        UIViewController *viewController = [super popViewControllerAnimated:NO];
        [UIView commitAnimations];

        lastViewController.navigationItem.prompt = nil;

        return viewController;
    }
    else{
        return [super popViewControllerAnimated:animated];
    }
}

@end
