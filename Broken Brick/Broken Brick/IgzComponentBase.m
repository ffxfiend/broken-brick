//
//  ComponentBase.m
//  Broken Brick
//
//  Created by Jeremiah Poisson on 7/20/13.
//  Copyright (c) 2013 Jeremiah Poisson. All rights reserved.
//

#import "IgzComponentBase.h"

@implementation IgzComponentBase

@synthesize type;

- (id) initWith:(NSString *) cType {
    
    self = [super init];
    if (self != nil) {
        [self setType:cType];
    }
    return self;
    
}

@end
