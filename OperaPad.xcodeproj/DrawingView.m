//
//  DrawingView.m
//  OperaPad
//
//  Created by Tom Coleman on 17/05/11.
//  Copyright 2011 Percolate Studio. All rights reserved.
//

#import "DrawingView.h"


@implementation DrawingView

@synthesize disabled;

- (void)drawRect:(CGRect)rect {
    // Drawing code
}

// Handles the start of a touch
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (!self.disabled) {
        UITouch *touch = [touches anyObject];
        
        lastPoint = [touch locationInView:self];
        //    lastPoint.y -= 20;        
    }
}

// Handles the continuation of a touch.
- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (!self.disabled) {
        UITouch *touch = [touches anyObject];	
        CGPoint currentPoint = [touch locationInView:self];
        //    currentPoint.y -= 20;
        
        
        UIGraphicsBeginImageContext(self.frame.size);
        CGContextRef context = UIGraphicsGetCurrentContext();
        [self.image drawInRect:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        
        CGContextSetLineCap(context, kCGLineCapRound);
        CGContextSetLineWidth(context, 2.0);
        CGContextSetRGBStrokeColor(context, 0.0, 0.0, 0.0, 1.0);
        CGContextBeginPath(context);
        CGContextMoveToPoint(context, lastPoint.x, lastPoint.y);
        CGContextAddLineToPoint(context, currentPoint.x, currentPoint.y);
        CGContextStrokePath(context) ;
        
        self.image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        lastPoint = currentPoint;        
    }
}
    
@end
