//
//  IgzCore.h
//  Broken Brick
//
//  Created by Jeremiah Poisson on 7/20/13.
//  Copyright (c) 2013 Jeremiah Poisson. All rights reserved.
//

#import <Cocoa/Cocoa.h>

// For display link
#import <QuartzCore/QuartzCore.h>

@class NSOpenGLContext, NSOpenGLPixelFormat, IgzTextureManager;

@interface IgzCore : NSView {
    
@private
    NSOpenGLContext     *_openGLContext;
    NSOpenGLPixelFormat *_pixelFormat;
    
    
    // Display Link Stuff :)
    CVDisplayLinkRef displayLink;
    
    NSLock *inputLock;
    
    GLuint texture;
    IgzTextureManager *textureManager;
    
}

// Initialization Functions
+ (NSOpenGLPixelFormat *) defaultPixelFormat;
- (id) initWithFrame:(NSRect)frameRect pixelFormat:(NSOpenGLPixelFormat *)format;

// OpenGL Functions
- (void) clearGLContext;
- (void) prepareOpenGL;
- (void) lockFocus;
- (void) setOpenGLContext:(NSOpenGLContext *)context;
- (NSOpenGLContext *) openGLContext;
- (void) setPixelFormat:(NSOpenGLPixelFormat *)pixelFormat;
- (NSOpenGLPixelFormat *) pixelFormat;

// Drawing/Updating Functions
- (void) update;
- (void) _surfaceNeedsUpdate;

// Texture functions
- (BOOL) loadTextures:(NSString *)imageName;

@property (readwrite) double dt;
@property (readwrite) double prevFrameTime;
@property (readwrite) double timeLeftOverForUpdate;

@property (readwrite) float viewWidth;
@property (readwrite) float viewHeight;
@property (readwrite) float viewAspect;

@end
