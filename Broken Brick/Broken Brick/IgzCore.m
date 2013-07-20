//
//  IgzCore.m
//  Broken Brick
//
//  Created by Jeremiah Poisson on 7/20/13.
//  Copyright (c) 2013 Jeremiah Poisson. All rights reserved.
//

#import "IgzCore.h"
#import <OpenGL/gl.h>
#import <OpenGL/glu.h>
#import <mach/mach_time.h>
#import "IgzTextureManager.h"
#import "IgzTextureObject.h"

#define USE_FIXED_RATE_TIMING   1
#define UPDATE_RATE             110.0
#define MINIMUM_FRAME_RATE      4
#define MAX_UPDATES_PER_FRAME   UPDATE_RATE / MINIMUM_FRAME_RATE
#define TICK_INTERVAL           1.0 / UPDATE_RATE
#define MAX_TIME_ALLOWED        MAX_UPDATES_PER_FRAME / TICK_INTERVAL


@interface IgzCore (InternalMethods)

- (CVReturn) getFrameForTime:(const CVTimeStamp *)outputTime;
- (double) currentTime;

@end

#pragma mark -
#pragma mark Display Link


static CVReturn MyDisplayLinkCallback(CVDisplayLinkRef dispalyLink, const CVTimeStamp *now,
                                      const CVTimeStamp *outputTime, CVOptionFlags flagsIn,
                                      CVOptionFlags *flagsOut, void *displayLinkContext) {
    @autoreleasepool {
        CVReturn result = [(__bridge IgzCore *)displayLinkContext getFrameForTime:outputTime];
        return result;
    }
}

@implementation IgzCore

@synthesize rtri;
@synthesize rquad;
@synthesize dt;
@synthesize prevFrameTime;
@synthesize timeLeftOverForUpdate;
@synthesize viewHeight;
@synthesize viewWidth;
@synthesize viewAspect;

#pragma mark -
#pragma mark Initialization Methods

+ (NSOpenGLPixelFormat *) defaultPixelFormat {
    
    NSOpenGLPixelFormatAttribute attrs[] = {
        NSOpenGLPFADoubleBuffer,
        NSOpenGLPFADepthSize, 32, 0
    };
    
    
    NSOpenGLPixelFormat *pixelFormat = [[NSOpenGLPixelFormat alloc] initWithAttributes:attrs];
    
    if (pixelFormat == nil) {
        NSLog(@"Error creating pixel format.");
    }
    
    return pixelFormat;
    
}

- (id) initWithFrame:(NSRect)frameRect pixelFormat:(NSOpenGLPixelFormat *)format {
    
    self = [super initWithFrame:frameRect];
    if (self != nil) {
        // set the default Pixel Format
        [self setPixelFormat:format];
        
        // Create the openGL Context
        [self setOpenGLContext:[[NSOpenGLContext alloc] initWithFormat:[self pixelFormat] shareContext:nil]];
        
        if ([self openGLContext] == nil) {
            NSLog(@"Unable to create a windowed OpenGL context.");
            exit(0);
        }
        
        // set synch to VBL to eliminate tearing
        GLint    vblSynch = 1;
        [[self openGLContext] setValues:&vblSynch forParameter:NSOpenGLCPSwapInterval];
        
        // set up the display link
        CVDisplayLinkCreateWithActiveCGDisplays(&displayLink);
        
        CVDisplayLinkSetOutputCallback(displayLink, &MyDisplayLinkCallback, (__bridge void *)(self));
        CGLContextObj cglContext = [[self openGLContext] CGLContextObj];
        CGLPixelFormatObj cglPixelFormat = [[self pixelFormat] CGLPixelFormatObj];
        CVDisplayLinkSetCurrentCGDisplayFromOpenGLContext(displayLink, cglContext, cglPixelFormat);
        
        // set up our fixed delta time (which we maintain as an instance variable in case you want to change
        // it on the fly somewhere down the road, for whatever reason -- you could just as well use a constant
        // or define if you prefer instead)
        dt = 1.0 / UPDATE_RATE;
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(_surfaceNeedsUpdate)
                                                     name:NSViewGlobalFrameDidChangeNotification
                                                   object:self];
        
        inputLock = [[NSLock alloc] init];
        
        [self setWantsBestResolutionOpenGLSurface:YES];
        
        [self prepareOpenGL];
        [self _surfaceNeedsUpdate];
        
        // Textures
        [[IgzTextureManager sharedManager] loadTexture:@"ff13.jpg"];
        [[IgzTextureManager sharedManager] loadTexture:@"lightning.png"];
        
        CVDisplayLinkStart(displayLink);
        
        [self setRtri:0.0];
        
    }
    return self;
}

#pragma mark -
#pragma mark OpenGL Functions

- (void) clearGLContext {
    
    NSLog(@"clearGLContext:");
    
}

- (void) prepareOpenGL {
    
    glShadeModel(GL_SMOOTH);
    
    glClearColor(0, 0, 0, 0);
    
    glClearDepth(1.0);
    glEnable(GL_DEPTH_TEST);
    glEnable(GL_TEXTURE_2D);
    glDepthFunc(GL_LEQUAL);
    glHint(GL_PERSPECTIVE_CORRECTION_HINT, GL_NICEST);
    
    [[self openGLContext] makeCurrentContext];
    
}

- (void) lockFocus {
    
    NSOpenGLContext *context = [self openGLContext];
    
    [super lockFocus];
    if ([context view] != self) {
        [context setView:self];
    }
    
    [context makeCurrentContext];
    
}

- (void) setOpenGLContext:(NSOpenGLContext *)context {
    _openGLContext = context;
}

- (NSOpenGLContext *) openGLContext {
    return _openGLContext;
}

- (void) setPixelFormat:(NSOpenGLPixelFormat *)pixelFormat {
    _pixelFormat = pixelFormat;
}

- (NSOpenGLPixelFormat *) pixelFormat {
    return _pixelFormat;
}

#pragma mark -
#pragma mark Drawing/Updating Functions

- (void) _surfaceNeedsUpdate {
    
    [[self openGLContext] update];
    
    NSSize    viewBounds = [self convertRectToBacking:[self bounds]].size;
    viewWidth = viewBounds.width;
    viewHeight = viewBounds.height;
    
    NSOpenGLContext    *currentContext = [self openGLContext];
    [currentContext makeCurrentContext];
    
    // remember to lock the context before we touch it since display link is threaded
    CGLLockContext([currentContext CGLContextObj]);
    
    // let the context know we've changed size
    glViewport(0, 0, viewWidth, viewHeight);
    
    glMatrixMode(GL_PROJECTION);
    glLoadIdentity();
    
    // gluPerspective(45.0f,(GLfloat)viewWidth/(GLfloat)viewHeight,0.1f,100.0f);
    glOrtho(0, viewWidth, viewHeight, 0, -1.0, 1.0);
    
    // [self prepareOpenGL];
    
    glMatrixMode(GL_MODELVIEW);
    glLoadIdentity();
    
    CGLUnlockContext([currentContext CGLContextObj]);
    
}

- (void) update {
    
    /* float rotate = [self rtri];
     rotate += 0.2;
     [self setRtri:rotate]; */
    
    rtri += 0.2;
    rquad -= 0.15f;
    
}

- (void) drawRect:(NSRect)rect {
    
    NSOpenGLContext    *currentContext = [self openGLContext];
    [currentContext makeCurrentContext];
    
    // must lock GL context because display link is threaded
    CGLLockContext([currentContext CGLContextObj]);
    
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
    glLoadIdentity();
    
    // glTranslatef(-1.5f,0.0f,-6.0f);
    
    // glRotatef(rtri,0.0f,1.0f,0.0f);
    
    
    // Get the texture
    IgzTextureObject *txt = [[IgzTextureManager sharedManager] getTexture:@"ff13.jpg"];
    
    glBindTexture( GL_TEXTURE_2D, [txt txtIndex]);
    glBegin(GL_QUADS);
    {
        glTexCoord2f(0.0, 0.0);
        glVertex2d(50, 50);
        
        glTexCoord2f(1.0, 0.0);
        glVertex2d(350, 50);
        
        glTexCoord2f(1.0, 1.0);
        glVertex2d(350, 300);
        
        glTexCoord2f(0.0, 1.0);
        glVertex2d(50, 300);
    }
    glEnd();
    
    // Draw another texture
    IgzTextureObject *lightTexture = [[IgzTextureManager sharedManager] getTexture:@"lightning.png"];
    glBindTexture( GL_TEXTURE_2D, [lightTexture txtIndex]);
    glBegin(GL_QUADS);
    {
        glTexCoord2f(0.0, 0.0);
        glVertex2d(400, 50);
        
        glTexCoord2f(1.0, 0.0);
        glVertex2d(700, 50);
        
        glTexCoord2f(1.0, 1.0);
        glVertex2d(700, 300);
        
        glTexCoord2f(0.0, 1.0);
        glVertex2d(400, 300);
    }
    glEnd();
    
    /* int loop1 = 0;
     for (loop1=0; loop1<3-1; loop1++)                    // Loop Through Lives Minus Current Life
     {
     glLoadIdentity();                       // Reset The View
     glTranslatef(490+(loop1*40.0f),40.0f,0.0f);
     glColor3f(0.0f,1.0f,0.0f);                  // Set Player Color To Light Green
     glBegin(GL_LINES);                      // Start Drawing Our Player Using Lines
     glVertex2d(-5,-5);                  // Top Left Of Player
     glVertex2d( 5, 5);                  // Bottom Right Of Player
     glVertex2d( 5,-5);                  // Top Right Of Player
     glVertex2d(-5, 5);                  // Bottom Left Of Player
     glEnd();                            // Done Drawing The Player
     
     glColor3f(0.0f,0.75f,0.0f);                 // Set Player Color To Dark Green
     glBegin(GL_LINES);                      // Start Drawing Our Player Using Lines
     glVertex2d(-7, 0);                  // Left Center Of Player
     glVertex2d( 7, 0);                  // Right Center Of Player
     glVertex2d( 0,-7);                  // Top Center Of Player
     glVertex2d( 0, 7);                  // Bottom Center Of Player
     glEnd();
     } */
    
    
    // Draw a triangle
    // glColor3f(1.0f, 0.85f, 0.35f);
    /* glBegin(GL_TRIANGLES);
     {
     
     glColor3f(1.0f,0.0f,0.0f);          // Red
     glVertex3f( 0.0f, 1.0f, 0.0f);          // Top Of Triangle (Front)
     glColor3f(0.0f,1.0f,0.0f);          // Green
     glVertex3f(-1.0f,-1.0f, 1.0f);          // Left Of Triangle (Front)
     glColor3f(0.0f,0.0f,1.0f);          // Blue
     glVertex3f( 1.0f,-1.0f, 1.0f);
     
     glColor3f(1.0f,0.0f,0.0f);          // Red
     glVertex3f( 0.0f, 1.0f, 0.0f);          // Top Of Triangle (Right)
     glColor3f(0.0f,0.0f,1.0f);          // Blue
     glVertex3f( 1.0f,-1.0f, 1.0f);          // Left Of Triangle (Right)
     glColor3f(0.0f,1.0f,0.0f);          // Green
     glVertex3f( 1.0f,-1.0f, -1.0f);
     
     glColor3f(1.0f,0.0f,0.0f);          // Red
     glVertex3f( 0.0f, 1.0f, 0.0f);          // Top Of Triangle (Back)
     glColor3f(0.0f,1.0f,0.0f);          // Green
     glVertex3f( 1.0f,-1.0f, -1.0f);         // Left Of Triangle (Back)
     glColor3f(0.0f,0.0f,1.0f);          // Blue
     glVertex3f(-1.0f,-1.0f, -1.0f);
     
     glColor3f(1.0f,0.0f,0.0f);          // Red
     glVertex3f( 0.0f, 1.0f, 0.0f);          // Top Of Triangle (Left)
     glColor3f(0.0f,0.0f,1.0f);          // Blue
     glVertex3f(-1.0f,-1.0f,-1.0f);          // Left Of Triangle (Left)
     glColor3f(0.0f,1.0f,0.0f);          // Green
     glVertex3f(-1.0f,-1.0f, 1.0f);
     
     }
     glEnd();
     // ---------------
     
     glLoadIdentity();                   // Reset The Current Modelview Matrix
     glTranslatef(1.5f,0.0f,-6.0f);              // Move Right 1.5 Units And Into The Screen 6.0
     glRotatef(rquad,1.0f,0.0f,0.0f);
     
     glBegin(GL_QUADS);
     {
     glColor3f(0.0f,1.0f,0.0f);          // Set The Color To Green
     glVertex3f( 1.0f, 1.0f,-1.0f);          // Top Right Of The Quad (Top)
     glVertex3f(-1.0f, 1.0f,-1.0f);          // Top Left Of The Quad (Top)
     glVertex3f(-1.0f, 1.0f, 1.0f);          // Bottom Left Of The Quad (Top)
     glVertex3f( 1.0f, 1.0f, 1.0f);
     
     glColor3f(1.0f,0.5f,0.0f);          // Set The Color To Orange
     glVertex3f( 1.0f,-1.0f, 1.0f);          // Top Right Of The Quad (Bottom)
     glVertex3f(-1.0f,-1.0f, 1.0f);          // Top Left Of The Quad (Bottom)
     glVertex3f(-1.0f,-1.0f,-1.0f);          // Bottom Left Of The Quad (Bottom)
     glVertex3f( 1.0f,-1.0f,-1.0f);
     
     glColor3f(1.0f,0.0f,0.0f);          // Set The Color To Red
     glVertex3f( 1.0f, 1.0f, 1.0f);          // Top Right Of The Quad (Front)
     glVertex3f(-1.0f, 1.0f, 1.0f);          // Top Left Of The Quad (Front)
     glVertex3f(-1.0f,-1.0f, 1.0f);          // Bottom Left Of The Quad (Front)
     glVertex3f( 1.0f,-1.0f, 1.0f);
     
     glColor3f(1.0f,1.0f,0.0f);          // Set The Color To Yellow
     glVertex3f( 1.0f,-1.0f,-1.0f);          // Bottom Left Of The Quad (Back)
     glVertex3f(-1.0f,-1.0f,-1.0f);          // Bottom Right Of The Quad (Back)
     glVertex3f(-1.0f, 1.0f,-1.0f);          // Top Right Of The Quad (Back)
     glVertex3f( 1.0f, 1.0f,-1.0f);
     
     glColor3f(0.0f,0.0f,1.0f);          // Set The Color To Blue
     glVertex3f(-1.0f, 1.0f, 1.0f);          // Top Right Of The Quad (Left)
     glVertex3f(-1.0f, 1.0f,-1.0f);          // Top Left Of The Quad (Left)
     glVertex3f(-1.0f,-1.0f,-1.0f);          // Bottom Left Of The Quad (Left)
     glVertex3f(-1.0f,-1.0f, 1.0f);
     
     glColor3f(1.0f,0.0f,1.0f);          // Set The Color To Violet
     glVertex3f( 1.0f, 1.0f,-1.0f);          // Top Right Of The Quad (Right)
     glVertex3f( 1.0f, 1.0f, 1.0f);          // Top Left Of The Quad (Right)
     glVertex3f( 1.0f,-1.0f, 1.0f);          // Bottom Left Of The Quad (Right)
     glVertex3f( 1.0f,-1.0f,-1.0f);
     
     }
     glEnd(); */
    
    glFlush();
    
    [currentContext flushBuffer];
    
    CGLUnlockContext([currentContext CGLContextObj]);
}

#pragma mark -
#pragma mark Texture Functions
- (BOOL) loadTextures:(NSString *)imageName {
    
    NSImage *img = [NSImage imageNamed:imageName];
    if(img == nil)
        return FALSE;
    else if(img.size.height == 0 || img.size.width == 0)
        return FALSE;
    NSBitmapImageRep *rep = [[NSBitmapImageRep alloc] initWithData: [img TIFFRepresentation]];
    glGenTextures( 1, &texture);
    glBindTexture( GL_TEXTURE_2D, texture);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_BASE_LEVEL, 0);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAX_LEVEL, 0);
    glTexParameteri( GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR );
    glTexParameteri( GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR );
    glTexImage2D( GL_TEXTURE_2D, 0, GL_RGB, rep.size.width,
                 rep.size.height, 0, GL_RGB,
                 GL_UNSIGNED_BYTE, rep.bitmapData);
    
    return YES;
}


#pragma mark -
#pragma mark Private Functions (timing)

- (CVReturn) getFrameForTime:(const CVTimeStamp *)outputTime {
    
#if USE_FIXED_RATE_TIMING
    
    double timeAllowed, frameDeltaTime, currTime;
    
    currTime = [self currentTime];
    if (prevFrameTime == 0.0) {
        prevFrameTime = currTime;
    }
    
    frameDeltaTime = 1.0 / (outputTime->rateScalar * (double)outputTime->videoTimeScale / (double)outputTime->videoRefreshPeriod);
    
    // frameDeltaTime = currTime - prevFrameTime; <-- Without display link
    
    prevFrameTime = currTime;
    
    timeAllowed = frameDeltaTime + timeLeftOverForUpdate;
    if (timeAllowed > MAX_TIME_ALLOWED) {
        timeAllowed = MAX_TIME_ALLOWED;
    }
    
    while (timeAllowed > TICK_INTERVAL) {
        timeAllowed -= TICK_INTERVAL;
        
        [self update];
    }
    
    timeLeftOverForUpdate = timeAllowed;
    
#else
    
    dt = 1.0 / (outputTime->rateScalar * (double)outputTime->videoTimeScale / (double)outputTime->videoRefreshPeriod);
    [self update];
    
#endif
    
    [self drawRect:[self frame]];
    
    return kCVReturnSuccess;
    
}

- (double) currentTime {
    static uint64_t        timebase = 0;
    uint64_t            time, nanos;
    double                seconds;
    
    // calculate the time base for this platform only on the first time through
    if (timebase == 0)
    {
        mach_timebase_info_data_t    timebaseInfo;
        mach_timebase_info(&timebaseInfo);
        timebase = timebaseInfo.numer / timebaseInfo.denom;
    }
    
    time = mach_absolute_time();
    nanos = time * timebase;
    seconds = (double)nanos * 1.0e-9;
    
    return seconds;
}

@end
