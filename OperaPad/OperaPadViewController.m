//
//  OperaPadViewController.m
//  OperaPad
//
//  Created by Tom Coleman on 13/05/11.
//  Copyright 2011 Percolate Studio. All rights reserved.
//

#import "OperaPadViewController.h"
#import "PaintingView.h"

@interface OperaPadViewController (private)
- (UIImage *) loadPageImage:(NSInteger)page;
@end

@implementation OperaPadViewController

@synthesize modeChooser;
@synthesize scrollView;

- (void)dealloc
{
    [scrollView release];
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
//    NSInteger width = self.view.frame.size.width, height = self.view.frame.size.height;
    // not sure how to get the right values for these
    NSInteger width = 1024, height = 768;
    
    int nPages = 3;
    pageNumber = 0;
    scrollView.contentSize = CGSizeMake(nPages*width,height-20);
    
    // load all the pages up (NOTE: assumes N_CACHED_PAGES = 3)
    for (int i = 0; i < N_CACHED_PAGES; i++) {
        CGRect rect = CGRectMake((-1 + i) * width, 0, width, height);
        scorePages[i] = [[UIImageView alloc] initWithFrame:rect];
        
        UIImage *pageImage = [self loadPageImage:i];
        if (pageImage != NULL) [scorePages[i] setImage:pageImage];
        
        [scrollView addSubview:scorePages[i]];
        [scorePages[i] release]; // the scrollView has a reference now
    }
        
    // rotate the modeChooser vertical
    // modeChooser.transform = CGAffineTransformTranslate(CGAffineTransformMakeRotation(M_PI / 2.0), modeChooser.frame.size.width/2,0.0);
    
    [self.view bringSubviewToFront:modeChooser];
    
    
    // read mode
    scrollView.scrollEnabled = YES;
    scrollView.pagingEnabled = YES;
}

- (void)viewDidUnload
{
    [self setScrollView:nil];
//    [self setScoreImage:nil];
//    [self setOverlayView:nil];
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

- (void) scrollViewDidScroll:(UIScrollView *)sender
{
    CGFloat pageWidth = scrollView.frame.size.width;
    NSInteger newPageNumber = lround(scrollView.contentOffset.x / pageWidth);
    
    if (newPageNumber != pageNumber) {
        if (newPageNumber > pageNumber) {
            // NOTE: assumes N_CACHED_PAGES is 3
            // move everything to the left one
            UIImageView *changingPage = scorePages[0];
            scorePages[0] = scorePages[1];
            scorePages[1] = scorePages[2];
            
            // load the new image into the left-most page
            UIImage *pageImage = [self loadPageImage:pageNumber + 3];
            if (pageImage != NULL) [changingPage setImage:pageImage];
            
            // re-position it
            CGRect frame = changingPage.frame;
            frame.origin.x += 3 * 1024; // FIXME: magic number
            changingPage.frame = frame;
            scorePages[2] = changingPage;
        } else {
            
        }
        pageNumber = newPageNumber;
    }
}

- (UIImage *) loadPageImage:(NSInteger)page
{
    if (page > 0) {
        NSString *filename = [NSString stringWithFormat:@"puccini-%d.png", page];
        return [UIImage imageNamed:filename];        
    } else {
        return NULL;
    }
}

- (IBAction)modeChanged:(id)sender {
    switch (modeChooser.selectedSegmentIndex) {
        case 0: // move
            scrollView.scrollEnabled = YES;
            scrollView.pagingEnabled = YES;
//            overlayView.disabled = YES;
            break;
        case 1: // draw
            scrollView.scrollEnabled = NO;
            scrollView.pagingEnabled = NO;

//            overlayView.disabled = NO;
//            [overlayView setBrushColorWithRed: 0.8 green:0.2 blue:0.2 opacity:1.0];
            break;
        case 2: // undo
//            [overlayView undo];
            modeChooser.selectedSegmentIndex = 1;
            break;
        case 3: // erase
            scrollView.scrollEnabled = NO;
            scrollView.pagingEnabled = NO;
            
//            overlayView.disabled = NO;
//            [overlayView setEraserMode]; 
            break;
        case 4: // clear
//            [overlayView clear];
            modeChooser.selectedSegmentIndex = 1;
            break;
    }    
}
                                                                   

@end
