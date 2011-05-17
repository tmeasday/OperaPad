//
//  DrawingView.h
//  OperaPad
//
//  Created by Tom Coleman on 17/05/11.
//  Copyright 2011 Percolate Studio. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface DrawingView : UIImageView {
    CGPoint lastPoint;
    BOOL disabled;
}

@property (readwrite, assign, nonatomic) BOOL disabled;

@end
