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
- (void) take
{
    // Get the size of the backing CAEAGLLayer
    GLint backingWidth, backingHeight;
    glBindRenderbufferOES(GL_RENDERBUFFER_OES, view.renderBuffer);
    glGetRenderbufferParameterivOES(GL_RENDERBUFFER_OES, GL_RENDERBUFFER_WIDTH_OES, &backingWidth);
    glGetRenderbufferParameterivOES(GL_RENDERBUFFER_OES, GL_RENDERBUFFER_HEIGHT_OES, &backingHeight);
    NSLog(@"saving image at size: %d x %d", backingWidth, backingHeight);
    
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
    // check that these guys are turned on right
    glEnable(GL_TEXTURE_2D);
    glEnable(GL_BLEND);
    glBlendFunc(GL_ONE, GL_SRC_COLOR);
        
    // turn the image into a texture
    GLuint texture[1];
    glGenTextures(1, &texture[0]);
    glBindTexture(GL_TEXTURE_2D, texture[0]);
    glTexParameteri(GL_TEXTURE_2D,GL_TEXTURE_MIN_FILTER,GL_LINEAR); 
    glTexParameteri(GL_TEXTURE_2D,GL_TEXTURE_MAG_FILTER,GL_LINEAR);
    
    // TODO -- we could probably just save the pixel data without going via an image
    CGImageRef cgimage = self.image.CGImage;
    GLuint width = CGImageGetWidth(cgimage);
    GLuint height = CGImageGetHeight(cgimage);
    GLuint texture_w = pow(2, ceil(log(width)/log(2))), texture_h = pow(2, ceil(log(height)/log(2)));
    
    NSLog(@"creating texture of size: %d x %d from image of size %d x %d", texture_w, texture_h, width, height);
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    void *imageData = malloc( texture_w * texture_h * 4 );
    CGContextRef context = CGBitmapContextCreate(imageData, texture_w, texture_h, 8, texture_w * 4, CGImageGetColorSpace(cgimage), kCGImageAlphaPremultipliedLast);
    CGColorSpaceRelease( colorSpace );
    CGContextClearRect( context, CGRectMake( 0, 0, width, height ) );
    CGContextTranslateCTM( context, 0, height - height );
    CGContextDrawImage( context, CGRectMake( 0, 0, width, height ), cgimage );
    
    // shouldn't need these
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR);
    
    glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA, texture_w, texture_h, 0, GL_RGBA, GL_UNSIGNED_BYTE, imageData);
    
    CGContextRelease(context);
    free(imageData);
    
    // now draw the texture
    glBindTexture(GL_TEXTURE_2D, texture[0]);
    glBlendFunc(GL_ONE, GL_ONE_MINUS_SRC_ALPHA);

    glEnableClientState(GL_VERTEX_ARRAY);
    glEnableClientState(GL_TEXTURE_COORD_ARRAY);
    const GLfloat vertices[] = {0.0,0.0, width,0.0, width,height, 0.0,0.0, 0.0,height, width,height};
    glVertexPointer(2, GL_FLOAT, 0, vertices);
    
    GLfloat s_width = 1.0 * width / texture_w, s_height = 1.0 * height / texture_h;
    const GLfloat texCoords[] = {0.0,1.0, s_width,1.0, s_width,1-s_height, 0.0,1.0, 0.0,1-s_height, s_width,1-s_height};
    glTexCoordPointer(2, GL_FLOAT, 0, texCoords);
    glDrawArrays(GL_TRIANGLES, 0, 6);
    
	// Display the buffer
	glBindRenderbufferOES(GL_RENDERBUFFER_OES, view.renderBuffer);
	[view.context presentRenderbuffer:GL_RENDERBUFFER_OES];       
}

@end
