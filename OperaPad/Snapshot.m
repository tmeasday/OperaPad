//
//  Snapshot.m
//  OperaPad
//
//  Created by Tom Coleman on 25/05/11.
//  Copyright 2011 Percolate Studio. All rights reserved.
//

#import "Snapshot.h"


@interface Snapshot(private)
- (UIImage *) snapshot;
@end

@implementation Snapshot

@synthesize image;

- (id) initFromEAGLView:(id<EAGLView>)v
{
    if (self = [super init])
    {
        view = v;
    }
    
    return self;
}

// this code is taken directly from apple's "OpenGL ES View Snapshot" example
// save the current rendered view into the image
- (void) snapshot
{
    // Get the size of the backing CAEAGLLayer
    GLint backingWidth, backingHeight;
    glBindRenderbufferOES(GL_RENDERBUFFER_OES, view.renderBuffer);
    glGetRenderbufferParameterivOES(GL_RENDERBUFFER_OES, GL_RENDERBUFFER_WIDTH_OES, &backingWidth);
    glGetRenderbufferParameterivOES(GL_RENDERBUFFER_OES, GL_RENDERBUFFER_HEIGHT_OES, &backingHeight);
    NSLog(@"size: %d x %d", backingWidth, backingHeight);
    
    NSInteger x = 0, y = 0, width = backingWidth, height = backingHeight;
    NSInteger dataLength = width * height * 4;
    GLubyte *data = (GLubyte*)malloc(dataLength * sizeof(GLubyte));
    
    // Read pixel data from the framebuffer
    glPixelStorei(GL_PACK_ALIGNMENT, 4);
    glReadPixels(x, y, width, height, GL_RGBA, GL_UNSIGNED_BYTE, data);
    
    // Create a CGImage with the pixel data
    // If your OpenGL ES content is opaque, use kCGImageAlphaNoneSkipLast to ignore the alpha channel
    // otherwise, use kCGImageAlphaPremultipliedLast
    CGDataProviderRef ref = CGDataProviderCreateWithData(NULL, data, dataLength, NULL);
    CGColorSpaceRef colorspace = CGColorSpaceCreateDeviceRGB();
    CGImageRef iref = CGImageCreate(width, height, 8, 32, width * 4, colorspace, kCGBitmapByteOrder32Big | kCGImageAlphaPremultipliedLast,
                                    ref, NULL, true, kCGRenderingIntentDefault);
    
    // OpenGL ES measures data in PIXELS
    // Create a graphics context with the target size measured in POINTS
    NSInteger widthInPoints, heightInPoints;
    if (NULL != UIGraphicsBeginImageContextWithOptions) {
        // On iOS 4 and later, use UIGraphicsBeginImageContextWithOptions to take the scale into consideration
        // Set the scale parameter to your OpenGL ES view's contentScaleFactor
        // so that you get a high-resolution snapshot when its value is greater than 1.0
        CGFloat scale = view.contentScaleFactor;
        widthInPoints = width / scale;
        heightInPoints = height / scale;
        UIGraphicsBeginImageContextWithOptions(CGSizeMake(widthInPoints, heightInPoints), NO, scale);
    }
    else {
        // On iOS prior to 4, fall back to use UIGraphicsBeginImageContext
        widthInPoints = width;
        heightInPoints = height;
        UIGraphicsBeginImageContext(CGSizeMake(widthInPoints, heightInPoints));
    }
    
    CGContextRef cgcontext = UIGraphicsGetCurrentContext();
    
    // UIKit coordinate system is upside down to GL/Quartz coordinate system
    // Flip the CGImage by rendering it to the flipped bitmap context
    // The size of the destination area is measured in POINTS
    CGContextSetBlendMode(cgcontext, kCGBlendModeCopy);
    CGContextDrawImage(cgcontext, CGRectMake(0.0, 0.0, widthInPoints, heightInPoints), iref);
    
    // Retrieve the UIImage from the current context
    self.image = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    // Clean up
    free(data);
    CFRelease(ref);
    CFRelease(colorspace);
    CGImageRelease(iref);
}

- (void) saveToTempFile
{
    // save out to a file
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];

    NSData* imgData = UIImagePNGRepresentation(self.image);
    NSString* targetPath = [NSString stringWithFormat:@"%@/%@", documentsDirectory, @"thisismyview.png" ];
    NSLog(targetPath);
    [imgData writeToFile:targetPath atomically:YES];
}


- (void) restore
{
	[EAGLContext setCurrentContext:view.context];
	
	// First, clear the buffer
	glBindFramebufferOES(GL_FRAMEBUFFER_OES, view.frameBuffer);
	glClearColor(0.0, 0.0, 0.0, 0.0);
	glClear(GL_COLOR_BUFFER_BIT);
    
    // Now, draw the image into the buffer
	
	// Display the buffer
	glBindRenderbufferOES(GL_RENDERBUFFER_OES, view.renderBuffer);
	[view.context presentRenderbuffer:GL_RENDERBUFFER_OES];       
}

@end
