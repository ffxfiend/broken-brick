//
//  IgzTextureObject.h
//  Broken Brick
//
//  Created by Jeremiah Poisson on 7/20/13.
//  Copyright (c) 2013 Jeremiah Poisson. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <OpenGL/gl.h>

@interface IgzTextureObject : NSObject

@property (readwrite) size_t width;
@property (readwrite) size_t height;
@property (readwrite) GLuint txtIndex;
@property (readwrite) float xScale;
@property (readwrite) float yScale;
@property (readwrite) float rotation;
@property (readwrite) CGRect section;

- (id) initWith:(NSImage *)image texture:(GLuint)texture;

@end
