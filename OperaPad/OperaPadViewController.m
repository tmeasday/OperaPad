//
//  OperaPadViewController.m
//  OperaPad
//
//  Created by Tom Coleman on 13/05/11.
//  Copyright 2011 Percolate Studio. All rights reserved.
//

#import "OperaPadViewController.h"

@implementation OperaPadViewController
@synthesize webView;

- (void)dealloc
{
    [webView release];
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
 
- (void)viewDidLoad
{
    NSString *path = [[NSBundle mainBundle] pathForResource:@"puccini" ofType:@"pdf"];
    NSURL *url = [NSURL fileURLWithPath:path];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [webView loadRequest:request];
    
//    UISwipeGestureRecognizer *swipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipe:)];
//    swipe.direction = UISwipeGestureRecognizerDirectionLeft;
//    [self.scoreImage addGestureRecognizer:swipe];
//    [swipe release];
    
    [super viewDidLoad];
}

//- (IBAction) handleSwipe:(UISwipeGestureRecognizer *)sender {
//    NSString* newImageName = [[NSBundle mainBundle] pathForResource:@"puccini-2" ofType:@"png"];
//    
//    UIImage * newImage = [[UIImage alloc] initWithContentsOfFile:newImageName]; 
//    scoreImage.image = newImage;
//    [newImage release];
//}

- (void)viewDidUnload
{
    [self setWebView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return YES;
}

@end
