//
//  OperaPadViewController.h
//  OperaPad
//
//  Created by Tom Coleman on 13/05/11.
//  Copyright 2011 Percolate Studio. All rights reserved.
//

#import <UIKit/UIKit.h>

#define N_CACHED_PAGES 3

@class PaintingView;

@interface OperaPadViewController : UIViewController<UIScrollViewDelegate> {
    UIScrollView *scrollView;
    UISegmentedControl *modeChooser;

    // pages -- TODO: make this a single view
    UIImageView *scorePages[N_CACHED_PAGES];
    PaintingView *overlayPages[N_CACHED_PAGES];

    NSInteger pageNumber;
}
@property (nonatomic, retain) IBOutlet UIScrollView *scrollView;
@property (nonatomic, retain) IBOutlet UISegmentedControl *modeChooser;

- (IBAction)modeChanged:(id)sender;

@end
