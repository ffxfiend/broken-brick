//
//  IgzSystemMovement.m
//  Broken Brick
//
//  Created by Jeremiah Poisson on 7/22/13.
//  Copyright (c) 2013 Jeremiah Poisson. All rights reserved.
//

#import "IgzSystemMovement.h"
#import "ComponentDefines.h"

@implementation IgzSystemMovement

- (id) init {
    
    self = [super init];
    if (self != nil) {
        
        // Set the required components
        requiredComponents = [[NSArray alloc] initWithObjects:IGZ_COMPONENT_POSITION, IGZ_COMPONENT_VELOCITY, nil];
        
    }
    return self;
    
}

@end
