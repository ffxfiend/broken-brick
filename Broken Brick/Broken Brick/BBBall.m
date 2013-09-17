//
//  BBBall.m
//  Broken Brick
//
//  Created by Jeremiah Poisson on 7/20/13.
//  Copyright (c) 2013 Jeremiah Poisson. All rights reserved.
//

#import "BBBall.h"
#import "ComponentDefines.h"

// Components
#import "IgzComponentPosition.h"
#import "IgzComponentVelocity.h"
#import "IgzComponentTexture.h"
#import "IgzComponentAnimation.h"

@implementation BBBall

- (id) init {
    
    self = [super init];
    if (self != nil) {
        
        // Add the necessary components.
        components = [[NSMutableDictionary alloc] init];
        [components setObject:[[IgzComponentPosition alloc] init] forKey:IGZ_COMPONENT_POSITION];
        [components setObject:[[IgzComponentVelocity alloc] init] forKey:IGZ_COMPONENT_VELOCITY];
        [components setObject:[[IgzComponentTexture alloc] init] forKey:IGZ_COMPONENT_TEXTURE];
        [components setObject:[[IgzComponentAnimation alloc] init] forKey:IGZ_COMPONENT_ANIMATION];
        
    }
    return self;
}

@end
