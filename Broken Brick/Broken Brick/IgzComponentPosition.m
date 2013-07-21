//
//  Position.m
//  Broken Brick
//
//  Created by Jeremiah Poisson on 7/20/13.
//  Copyright (c) 2013 Jeremiah Poisson. All rights reserved.
//

#import "IgzComponentPosition.h"

@implementation IgzComponentPosition

@synthesize x;
@synthesize y;

- (id) init {
    
    self = [super initWith:@"Position"];
    if (self != nil) {
        [self setX:0.0];
        [self setY:0.0];
    }
    return self;
    
}

@end