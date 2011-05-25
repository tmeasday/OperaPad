//
//  Snapshot.h
//  OperaPad
//
//  Created by Tom Coleman on 25/05/11.
//  Copyright 2011 Percolate Studio. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <OpenGLES/EAGL.h>
#import <OpenGLES/ES1/gl.h>
#import <OpenGLES/ES1/glext.h>

@protocol EAGLView
- (CGFloat) contentScaleFactor;
- (GLuint) frameBuffer;
- (GLuint) renderBuffer;
- (EAGLContext *) context;
@end

@interface Snapshot : NSObject {
    UIImage *image;
    id<EAGLView> view;
}

@property(retain, nonatomic) UIImage *image;

- (id) initFromEAGLView:(id<EAGLView>)view;
- (void) take;
- (void) saveToTempFile;
- (void) restore;

@end
