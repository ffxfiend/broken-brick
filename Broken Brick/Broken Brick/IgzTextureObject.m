//
//  IgzTextureObject.m
//  Broken Brick
//
//  Created by Jeremiah Poisson on 7/20/13.
//  Copyright (c) 2013 Jeremiah Poisson. All rights reserved.
//

#import "IgzTextureObject.h"

@implementation IgzTextureObject

@synthesize width;
@synthesize height;
@synthesize txtIndex;
@synthesize xScale;
@synthesize yScale;
@synthesize rotation;
@synthesize section;

- (id) initWith:(NSImage *)image texture:(GLuint)texture {
    
    self = [super init];
    if (self != nil) {
        
        [self setWidth:image.size.width];
        [self setHeight:image.size.height];
        [self setTxtIndex:texture];
        
        // Not sure about these...
        [self setXScale:0.0];
        [self setYScale:0.0];
        [self setRotation:0.0f];
        [self setSection:NSMakeRect(0.0, 0.0, image.size.width, image.size.height)];
        
    }
    return self;
    
}

@end
