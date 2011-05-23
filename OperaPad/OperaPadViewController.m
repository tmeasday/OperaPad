//
//  OperaPadViewController.m
//  OperaPad
//
//  Created by Tom Coleman on 13/05/11.
//  Copyright 2011 Percolate Studio. All rights reserved.
//

#import "OperaPadViewController.h"
#import "PaintingView.h"

@implementation OperaPadViewController
@synthesize scoreImage;
@synthesize overlayView;
@synthesize modeChooser;
@synthesize scrollView;

- (void)dealloc
{
    [scrollView release];
    [scoreImage release];
    [overlayView release];
    [modeChooser release];
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
        
    // rotate the modeChooser vertical
    // modeChooser.transform = CGAffineTransformTranslate(CGAffineTransformMakeRotation(M_PI / 2.0), modeChooser.frame.size.width/2,0.0);
    
    
    // read mode
    scrollView.scrollEnabled = YES;
    scrollView.pagingEnabled = YES;
    
    [overlayView setBrushColorWithRed: 0.0 green:0.5 blue:0.5];
}

- (void)viewDidUnload
{
    [self setScrollView:nil];
    [self setScoreImage:nil];
    [self setOverlayView:nil];
    [self setModeChooser:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return YES;
}

- (IBAction)modeChanged:(id)sender {
    switch (modeChooser.selectedSegmentIndex) {
        case 0:
            scrollView.scrollEnabled = YES;
            scrollView.pagingEnabled = YES;            
            break;
        case 1:
            scrollView.scrollEnabled = NO;
            scrollView.pagingEnabled = NO;
            break;
        case 4:
            [overlayView erase];
            modeChooser.selectedSegmentIndex = 1;
//            scrollView.scrollEnabled = NO;
//            scrollView.pagingEnabled = NO;
        default:
            break;
    }    
}
@end
