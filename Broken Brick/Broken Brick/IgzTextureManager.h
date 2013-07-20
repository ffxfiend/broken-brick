//
//  IgzTextureManager.h
//  Broken Brick
//
//  Created by Jeremiah Poisson on 7/20/13.
//  Copyright (c) 2013 Jeremiah Poisson. All rights reserved.
//

#import <Foundation/Foundation.h>

@class IgzTextureObject;

@interface IgzTextureManager : NSObject {
    
    NSMutableDictionary *textureObjects;
    
}

+ (IgzTextureManager *)sharedManager;

- (BOOL) loadTexture:(NSString *) fileName;
- (IgzTextureObject *) getTexture:(NSString *)texture;

@end
