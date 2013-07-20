//
//  lotasAppDelegate.h
//  Broken Brick
//
//  Created by Jeremiah Poisson on 7/20/13.
//  Copyright (c) 2013 Jeremiah Poisson. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "IgzCore.h"

@interface lotasAppDelegate : NSObject <NSApplicationDelegate>
{
    IgzCore *glView;
    NSTimer *renderTimer;
}

@property (readwrite) NSTimer *renderTimer;
@property (readwrite) IgzCore *glView;
@property (assign) IBOutlet NSWindow *window;

- (void) createFailed;

@end
