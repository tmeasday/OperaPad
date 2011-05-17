//
//  OperaPadViewController.h
//  OperaPad
//
//  Created by Tom Coleman on 13/05/11.
//  Copyright 2011 Percolate Studio. All rights reserved.
//

#import <UIKit/UIKit.h>
@class DrawingView;

@interface OperaPadViewController : UIViewController {
    UIScrollView *scrollView;
    UIImageView *scoreImage;
    DrawingView *overlayView;
    UISegmentedControl *modeChooser;
}
@property (nonatomic, retain) IBOutlet UIScrollView *scrollView;
@property (nonatomic, retain) IBOutlet UIImageView *scoreImage;
@property (nonatomic, retain) IBOutlet DrawingView *overlayView;
@property (nonatomic, retain) IBOutlet UISegmentedControl *modeChooser;

- (IBAction)modeChanged:(id)sender;

@end
