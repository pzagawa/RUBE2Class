//
//  JSONFixtureObject.m
//  RUBE2Class
//
//  Created by Piotr on 22.02.2014.
//  Copyright (c) 2014 Piotr Zagawa. All rights reserved.
//

#import "JSONFixtureObject.h"
#import "JSONShapeObject.h"
#import "JSONVectorObject.h"

@implementation JSONFixtureObject

- (id)initWithJsonObject:(NSDictionary *)fixture
{
    self = [super init];
    
    if (self)
    {
        self.name = fixture[@"name"];
        
        if ([self.name hasSuffix:@"_test"] == YES)
        {
            self.isTest = YES;
        }

        //properties
        self.density = fixture[@"density"];
        self.friction = fixture[@"friction"];
        self.restitution = fixture[@"restitution"];

        self.filterCategoryBits = fixture[@"filter-categoryBits"];
        self.filterMaskBits = fixture[@"filter-maskBits"];
        self.filterGroupIndex = fixture[@"filter-groupIndex"];
        
        self.isSensor = ([(NSNumber *)(fixture[@"sensor"]) intValue] == 1);
        
        //get shape object
        self.shapeObject = [JSONShapeObject fromFixture:fixture];
    }
    
    return self;
}

- (void)openBlock:(NSMutableString *)text
{
    [text appendString:@"\t{"];
    [text appendString:@"\n"];
}

- (void)closeBlock:(NSMutableString *)text
{
    [text appendString:@"\t}"];
    [text appendString:@"\n"];
}

- (NSString *)propertyItemName
{
    return [NSString stringWithFormat:@"fixture_%@", self.name];
}

- (NSString *)propertyItem
{
    return [NSString stringWithFormat:@"b2Fixture *%@;\n", self.propertyItemName];
}

- (void)updateConstItem:(NSMutableString *)text
{
}

- (NSString *)createItem
{
    return @"";
}

- (NSString *)deallocItem
{
    return @"";
}

- (NSString *)methodBody
{
    NSMutableString *text = [[NSMutableString alloc] init];

    [text appendString:@"\n\t"];
    [text appendFormat:@"//create fixture: %@\n", self.name];
    
    [self openBlock:text];
    
    [text appendString:@"\t\t"];
    [text appendString:@"b2FixtureDef fd;"];
    [text appendString:@"\n\n"];
    
    [text appendString:@"\t\t"];
    [text appendFormat:@"fd.density = %@;", (self.density == nil) ? @"1" : self.density];
    [text appendString:@"\n"];

    [text appendString:@"\t\t"];
    [text appendFormat:@"fd.friction = %@;", (self.friction == nil) ? @"0.2" : self.friction];
    [text appendString:@"\n"];

    [text appendString:@"\t\t"];
    [text appendFormat:@"fd.restitution = %@;", (self.restitution == nil) ? @"0" : self.restitution];
    [text appendString:@"\n"];
    [text appendString:@"\n"];
    
    [text appendString:@"\t\t"];
    [text appendString:@"fd.filter.categoryBits = self.collisionBitsCategory;"];
    [text appendString:@"\n"];
    
    [text appendString:@"\t\t"];
    [text appendString:@"fd.filter.maskBits = self.collisionBitsMask;"];
    [text appendString:@"\n"];

    [text appendString:@"\t\t"];
    [text appendFormat:@"fd.filter.groupIndex = %@;", (self.filterGroupIndex == nil) ? @"0" : self.filterGroupIndex];
    [text appendString:@"\n"];
    [text appendString:@"\n"];

    [text appendString:@"\t\t"];
    [text appendFormat:@"fd.isSensor = %hhd;", self.isSensor];
    [text appendString:@"\n"];
    
    [text appendString:@"\t"];
    [text appendString:self.shapeObject.methodBody];
    [text appendString:@"\n"];

    return text;
}

- (NSString *)userDataItem
{
    return @"";
}

- (NSString *)methodBodyEnd:(NSString *)parentName
{
    NSMutableString *text = [[NSMutableString alloc] init];

    [text appendString:@"\t\t"];
    [text appendFormat:@"self.%@ = self.%@->CreateFixture(&fd);", self.propertyItemName, parentName];
    [text appendString:@"\n"];
    
    [self closeBlock:text];

    return text;
}

@end
