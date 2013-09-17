//
//  BrokenBrick.m
//  Broken Brick
//
//  Created by Jeremiah Poisson on 7/20/13.
//  Copyright (c) 2013 Jeremiah Poisson. All rights reserved.
//

#import "BrokenBrick.h"

// Game Objects
#import "BBBall.h"
#import "BBBrick.h"

@implementation BrokenBrick

- (id) init {

    self = [super init];
    if (self != nil) {
        
        // Initialize the game
        ball = [[BBBall alloc] init];
        
        
    }
    return self;
    
}

@end
