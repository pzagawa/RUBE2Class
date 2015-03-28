//
//  JSONVerticesObject.m
//  RUBE2Class
//
//  Created by Piotr on 23.02.2014.
//  Copyright (c) 2014 Piotr Zagawa. All rights reserved.
//

#import "JSONVerticesObject.h"
#import "JSONVectorObject.h"

@implementation JSONVerticesObject

- (id)initWithJsonObject:(NSDictionary *)vectorArray;
{
    self = [super init];
    
    if (self)
    {
        NSArray *xList = vectorArray[@"x"];
        NSArray *yList = vectorArray[@"y"];

        NSMutableArray *vertices = [[NSMutableArray alloc] init];

        for (int index = 0; index < xList.count; index++)
        {
            NSNumber *x = xList[index];
            NSNumber *y = yList[index];
            
            JSONVectorObject *vector = [[JSONVectorObject alloc] initWithX:[x floatValue] andY:[y floatValue]];
            
            [vertices addObject:vector];
        }
        
        self.list = vertices;
    }
    
    return self;
}

- (NSString *)textList
{
    NSMutableString *text = [[NSMutableString alloc] init];

    int index = 0;
    
    for (JSONVectorObject *vector in self.list)
    {
        [text appendString:@"\t\t"];
        [text appendFormat:@"vs[%d].Set(%@);", index, vector.description];
        [text appendString:@"\n"];
        
        index++;
    }
    
    [text appendString:@"\n"];

    return text;
}

@end
