//
//  lotasAppDelegate.m
//  Broken Brick
//
//  Created by Jeremiah Poisson on 7/20/13.
//  Copyright (c) 2013 Jeremiah Poisson. All rights reserved.
//

#import "lotasAppDelegate.h"
#import <OPenGL/gl.h>

#define WIDTH       800
#define HEIGHT      600
#define COLOR_BITS  16
#define DEPTH_BITS  16
#define FULLSCREEN  0

@implementation lotasAppDelegate

@synthesize glView;
@synthesize renderTimer;

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    // Insert code here to initialize your application
    NSLog(@"applicationDidFinishLaunching");
    
    // Center the window to the screen.
    NSRect mainDisplayRect = [[NSScreen mainScreen] frame];
    
    if (FULLSCREEN) {
        [_window setStyleMask:NSBorderlessWindowMask];
        [_window setBackingType:NSBorderlessWindowMask];
        
        
        [_window setLevel:NSMainMenuWindowLevel + 1];
        [_window setOpaque:YES];
        [_window setHidesOnDeactivate:YES];
        
        [_window setFrame:mainDisplayRect display:YES];
    } else {
        float x = mainDisplayRect.size.width / 2 - WIDTH / 2;
        float y = mainDisplayRect.size.height / 2 - HEIGHT / 2;
        
        NSRect screenSize = NSMakeRect(x, y, WIDTH, HEIGHT);
        [_window setFrame:screenSize display:YES];
    }
    
    NSOpenGLPixelFormat *pixelFormat = [IgzCore defaultPixelFormat];
    glView = [[IgzCore alloc] initWithFrame:[_window frame] pixelFormat:pixelFormat];
    
    NSLog(@"%@",glView);
    if (glView != nil) {
        NSLog(@"GLVIEW IS NOT NIL");
        [_window setContentView:glView];
        [_window makeKeyAndOrderFront:self];
        // [self setupRenderTimer];
    } else {
        [self createFailed];
    }
}

/*
 * Called if we fail to create a valid OpenGL view
 */
- (void) createFailed {
    
    NSLog(@"createFailed:");
    
    NSWindow *infoWindow;
    
    infoWindow = NSGetCriticalAlertPanel( @"Initialization failed",
                                         @"Failed to initialize OpenGL",
                                         @"OK", nil, nil );
    [ NSApp runModalForWindow:infoWindow ];
    [ infoWindow close ];
    [ NSApp terminate:self ];
}

@end
