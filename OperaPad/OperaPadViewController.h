//
//  OperaPadViewController.h
//  OperaPad
//
//  Created by Tom Coleman on 13/05/11.
//  Copyright 2011 Percolate Studio. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OperaPadViewController : UIViewController {
    UIScrollView *scrollView;
    UIImageView *scoreImage;
    UIImageView *overlayImage;
}
@property (nonatomic, retain) IBOutlet UIScrollView *scrollView;
@property (nonatomic, retain) IBOutlet UIImageView *scoreImage;
@property (nonatomic, retain) IBOutlet UIImageView *overlayImage;

@end
