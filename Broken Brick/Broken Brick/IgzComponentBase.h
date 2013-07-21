//
//  ComponentBase.h
//  Broken Brick
//
//  Created by Jeremiah Poisson on 7/20/13.
//  Copyright (c) 2013 Jeremiah Poisson. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IgzComponentBase : NSObject

@property (readwrite) NSString *type;

- (id) initWith:(NSString *) cType;

@end
