//
//  Texture.m
//  Broken Brick
//
//  Created by Jeremiah Poisson on 7/20/13.
//  Copyright (c) 2013 Jeremiah Poisson. All rights reserved.
//

#import "IgzComponentTexture.h"
#import "IgzTextureObject.h"
#import "ComponentDefines.h"

@implementation IgzComponentTexture

@synthesize texture;

- (id) init {
    
    self = [super initWith:IGZ_COMPONENT_TEXTURE];
    if (self != nil) {
        
    }
    return self;
    
}

@end
