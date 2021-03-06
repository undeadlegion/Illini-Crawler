//
//  FeedbackViewController.m
//  CampusCrawler
//
//  Created by James Lubowich on 4/23/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "FeedbackViewController.h"
#import "CampusCrawlerAppDelegate.h"


@implementation FeedbackViewController
@synthesize scrollView, feedbackView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
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
    [[NSNotificationCenter defaultCenter] addObserver:self  
                                             selector:@selector(keyboardNotification:)  
                                                 name:UIKeyboardWillShowNotification  
                                               object:nil];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)turnOffActivityIndicator:(NSTimer*)timer{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}

- (IBAction)pressedSend:(id)sender{
    CampusCrawlerAppDelegate *delegate = (CampusCrawlerAppDelegate *)[[UIApplication sharedApplication] delegate];
    Facebook *facebook = delegate.facebook;
        
    //start the activity indicator set a timer to turn it off
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(turnOffActivityIndicator:) userInfo:nil repeats:NO];
    
    NSString *urlString = [NSString stringWithFormat:@"%@%@", serverString, feedbackString];
    if(facebook.userId)
        urlString = [urlString stringByAppendingString:facebook.userId];
    else
        urlString = [urlString stringByAppendingString:@"0"];
    urlString = [urlString stringByAppendingString:@"&message="];
    urlString = [urlString stringByAppendingString:[feedbackView.text stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding]];
    NSLog(@"URL:%@", urlString);
    NSURL *url = [NSURL URLWithString:urlString];
        

    NSMutableURLRequest *urlRequest = [[NSMutableURLRequest alloc] initWithURL:url];
    [NSURLConnection sendSynchronousRequest:urlRequest returningResponse:nil error:nil];

}


- (void)keyboardNotification:(NSNotification*)notification {  
    NSDictionary *userInfo = [notification userInfo];
    NSValue *keyboardBoundsValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];  
    [keyboardBoundsValue getValue:&keyboardBounds];
}  

#pragma mark -
#pragma mark UITextViewDelegate

- (void)textViewDidEndEditing:(UITextView *)textView{
}
- (void)textViewDidBeginEditing:(UITextView *)textView{
    [self scrollViewToCenterOfScreen:textView];
}

- (BOOL)textViewShouldEndEditing:(UITextView *)textVIew{
    return YES;
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if([text isEqualToString:@"\n"]){
        [textView resignFirstResponder];
        [scrollView setContentOffset:CGPointMake(0, 0) animated:YES];  
        return NO;
    }
    return YES;
    
}
- (void)scrollViewToCenterOfScreen:(UIView *)theView {  
    CGFloat viewCenterY = theView.center.y;  
    CGRect applicationFrame = [[UIScreen mainScreen] applicationFrame];  
    
    CGFloat availableHeight = applicationFrame.size.height - keyboardBounds.size.height;    // Remove area covered by keyboard  
    
    CGFloat y = viewCenterY - availableHeight / 2.0;  
    if (y < 0) {  
        y = 0;  
    }  
//    scrollView.contentSize = CGSizeMake(applicationFrame.size.width, applicationFrame.size.height + keyboardBounds.size.height);  
    [scrollView setContentOffset:CGPointMake(0, y) animated:YES];  
}  
@end
