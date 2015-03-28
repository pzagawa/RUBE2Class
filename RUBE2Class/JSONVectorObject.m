//
//  JSONVector.m
//  RUBE2Class
//
//  Created by Piotr on 18.02.2014.
//  Copyright (c) 2014 Piotr Zagawa. All rights reserved.
//

#import "JSONVectorObject.h"

@implementation JSONVectorObject

- (id)initWithZero
{
    self = [super init];
    
    if (self)
    {
        self.x = 0;
        self.y = 0;
    }
    
    return self;
}

- (id)initWithX:(float)x andY:(float)y
{
    self = [super init];
    
    if (self)
    {
        self.x = x;
        self.y = y;
    }
    
    return self;
}

- (id)initWithJsonObject:(NSDictionary *)vector
{
    self = [super init];
    
    if (self)
    {
        self.x = [(NSNumber *)(vector[@"x"]) floatValue];
        self.y = [(NSNumber *)(vector[@"y"]) floatValue];
    }
    
    return self;
}

+ (JSONVectorObject *)read:(id)value
{
    if (value == nil)
    {
        return nil;
    }
    
    if ([value isKindOfClass:NSNumber.class])
    {
        if ([((NSNumber *)value) longValue] == 0)
        {
            return [[JSONVectorObject alloc] initWithZero];
        }
    }
    
    return [[JSONVectorObject alloc] initWithJsonObject:value];
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"%f, %f", self.x, self.y];
}

- (NSString *)debugDescription
{
    return self.description;
}

@end
