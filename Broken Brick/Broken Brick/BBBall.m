//
//  BBBall.m
//  Broken Brick
//
//  Created by Jeremiah Poisson on 7/20/13.
//  Copyright (c) 2013 Jeremiah Poisson. All rights reserved.
//

#import "BBBall.h"

// Components
#import "IgzComponentPosition.h"
#import "IgzComponentVelocity.h"
#import "IgzComponentTexture.h"

@implementation BBBall

- (id) init {
    
    self = [super init];
    if (self != nil) {
        
        // Add the necessary components.
        components = [[NSMutableDictionary alloc] init];
        [components setObject:[[IgzComponentPosition alloc] init] forKey:@"position"];
        [components setObject:[[IgzComponentVelocity alloc] init] forKey:@"velocity"];
        [components setObject:[[IgzComponentTexture alloc] init] forKey:@"texture"];
        
        
    }
    return self;
}

@end