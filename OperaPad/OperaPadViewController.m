//
//  OperaPadViewController.m
//  OperaPad
//
//  Created by Tom Coleman on 13/05/11.
//  Copyright 2011 Percolate Studio. All rights reserved.
//

#import "OperaPadViewController.h"

@implementation OperaPadViewController
@synthesize scoreImage;
@synthesize overlayImage;
@synthesize scrollView;

- (void)dealloc
{
    [scrollView release];
    [scoreImage release];
    [overlayImage release];
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
    [super viewDidLoad];
    
    int nPages = 3;
    scrollView.contentSize = CGSizeMake(nPages*1024,768-20);
}

- (void)viewDidUnload
{
    [self setScrollView:nil];
    [self setScoreImage:nil];
    [self setOverlayImage:nil];
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
