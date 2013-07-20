//
//  IgzTextureManager.m
//  Broken Brick
//
//  Created by Jeremiah Poisson on 7/20/13.
//  Copyright (c) 2013 Jeremiah Poisson. All rights reserved.
//

#import "IgzTextureManager.h"
#import "IgzTextureObject.h"

@implementation IgzTextureManager

+ (IgzTextureManager *) sharedManager {
    
    static IgzTextureManager *sharedManager;
    
    static BOOL initialized = NO;
    if(!initialized)
    {
        initialized = YES;
        sharedManager = [[IgzTextureManager alloc] init];
    }
    
    return sharedManager;
    
}

- (id) init {
    
    self = [super init];
    if (self != nil) {
        textureObjects = [[NSMutableDictionary alloc] init];
    }
    return self;
    
}

- (BOOL) loadTexture:(NSString *)fileName {
    
    NSImage *img = [NSImage imageNamed:fileName];
    if(img == nil)
        return FALSE;
    else if(img.size.height == 0 || img.size.width == 0)
        return FALSE;
    
    GLuint texture;
    
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
    
    IgzTextureObject *txt = [[IgzTextureObject alloc] initWith:img texture:texture];
    
    [textureObjects setObject:txt forKey:fileName];
    
    return YES;
    
}

- (IgzTextureObject *) getTexture:(NSString *)texture {
    return [textureObjects objectForKey:texture];
}

@end
