//
//  Texture.h
//  Broken Brick
//
//  Created by Jeremiah Poisson on 7/20/13.
//  Copyright (c) 2013 Jeremiah Poisson. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IgzComponentBase.h"

@class IgzTextureObject;

@interface IgzComponentTexture : IgzComponentBase

@property (readwrite) IgzTextureObject *texture;

@end
