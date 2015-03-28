//
//  JSONBodyObject.m
//  RUBE2Class
//
//  Created by Piotr on 18.02.2014.
//  Copyright (c) 2014 Piotr Zagawa. All rights reserved.
//

#import "JSONBodyObject.h"
#import "JSONVectorObject.h"
#import "JSONFixtureObject.h"
#import "JSONPropertyObject.h"

@implementation JSONBodyObject

- (id)initWithJsonObject:(NSDictionary *)body
{
    self = [super init];
    
    if (self)
    {
        self.name = body[@"name"];
        
        if ([self.name hasSuffix:@"_test"] == YES)
        {
            self.isTest = YES;
        }

        self.type = [body[@"type"] integerValue];
        
        self.angle = body[@"angle"];
        
        self.angularVelocity = body[@"angularVelocity"];
        self.linearVelocity = [JSONVectorObject read:body[@"linearVelocity"]];

        self.isAwake = ([(NSNumber *)(body[@"awake"]) intValue] == 1);
        self.isFixedRotation = ([(NSNumber *)(body[@"fixedRotation"]) intValue] == 1);
        self.isBullet = ([(NSNumber *)(body[@"bullet"]) intValue] == 1);
        
        self.position = [JSONVectorObject read:body[@"position"]];
        self.massDataCenter = [JSONVectorObject read:body[@"massData-center"]];
        
        self.angularDamping = body[@"angularDamping"];
        self.linearDamping = body[@"linearDamping"];

        //parse fixtures
        NSArray *fixtureList = body[@"fixture"];

        self.fixtures = [[NSMutableArray alloc] init];
        
        for (NSDictionary *fixtureObject in fixtureList)
        {
            JSONFixtureObject *object = [[JSONFixtureObject alloc] initWithJsonObject:fixtureObject];
            
            if (object.isTest)
            {
                NSLog(@"Skipping test fixture: %@", object.name);
            }
            else
            {
                [self.fixtures addObject:object];
            }
        }
        
        //parse custom properties
        NSArray *propertiesList = body[@"customProperties"];

        self.properties = [[NSMutableArray alloc] init];

        for (NSDictionary *propertyObject in propertiesList)
        {
            JSONPropertyObject *object = [[JSONPropertyObject alloc] initWithJsonObject:propertyObject];
            
            object.namePrefix = self.propertyItemName;
            
            [self.properties addObject:object];
        }
    }
    
    return self;
}

- (NSString *)methodName
{
    return [NSString stringWithFormat:@"create_body_%@", self.name];
}

- (void)openBlock:(NSMutableString *)text
{
    [text appendString:@"{"];
    [text appendString:@"\n"];
}

- (void)closeBlock:(NSMutableString *)text
{
    [text appendString:@"}"];
    [text appendString:@"\n\n"];
}

- (NSString *)propertyItemName
{
    return [NSString stringWithFormat:@"body_%@", self.name];
}

- (NSString *)propertyItem
{
    NSMutableString *text = [[NSMutableString alloc] init];
    
    [text appendFormat:@"b2Body *%@;\n", self.propertyItemName];
    
    for (JSONFixtureObject *fixture in self.fixtures)
    {
        [text appendFormat:@"@property %@", fixture.propertyItem];
    }

    for (JSONPropertyObject *property in self.properties)
    {
        [text appendFormat:@"@property %@", property.propertyItem];
    }

    [text appendString:@"\n"];

    return text;
}

- (void)updateConstItem:(NSMutableString *)text
{
    for (JSONFixtureObject *fixture in self.fixtures)
    {
        [fixture updateConstItem:text];
    }
}

- (NSString *)createItem
{
    NSMutableString *text = [[NSMutableString alloc] init];
    
    [text appendFormat:@"\t[self %@];\n", self.methodName];
    
    for (JSONPropertyObject *property in self.properties)
    {
        [text appendFormat:@"\t%@;\n", property.createItem];
    }

    if (self.properties.count > 0)
    {
        [text appendString:@"\n"];
    }
    
    return text;
}

- (NSString *)deallocItem
{
    return [NSString stringWithFormat:@"\tself.physWorld->DestroyBody(self.%@);\n", self.propertyItemName];
}

- (NSString *)methodBody
{
    NSMutableString *text = [[NSMutableString alloc] init];
    
    [text appendFormat:@"- (void)%@\n", self.methodName];
    
    [self openBlock:text];
    
    //create body
    [text appendString:@"\t"];
    [text appendString:@"b2BodyDef bd;"];
    [text appendString:@"\n\n"];

    [text appendString:@"\t"];
    [text appendFormat:@"bd.type = b2BodyType(%lu);", self.type];
    [text appendString:@"\n"];
    
    [text appendString:@"\t"];
    [text appendFormat:@"bd.position.Set(%@);", self.position.description];
    [text appendString:@"\n"];

    [text appendString:@"\t"];
    [text appendFormat:@"bd.angle = %@;", self.angle];
    [text appendString:@"\n"];
    
    if (self.linearVelocity)
    {
        [text appendString:@"\t"];
        [text appendFormat:@"bd.linearVelocity.Set(%@);", self.linearVelocity.description];
        [text appendString:@"\n"];
    }

    [text appendString:@"\t"];
    [text appendFormat:@"bd.angularVelocity = %@;", self.angularVelocity];
    [text appendString:@"\n"];

    [text appendString:@"\t"];
    [text appendFormat:@"bd.awake = %hhd;", self.isAwake];
    [text appendString:@"\n"];

    [text appendString:@"\t"];
    [text appendFormat:@"bd.fixedRotation = %hhd;", self.isFixedRotation];
    [text appendString:@"\n"];

    [text appendString:@"\t"];
    [text appendFormat:@"bd.bullet = %hhd;", self.isBullet];
    [text appendString:@"\n"];

    [text appendString:@"\n"];
    
    [text appendString:@"\t"];
    [text appendFormat:@"self.%@ = self.physWorld->CreateBody(&bd);", self.propertyItemName];
    [text appendString:@"\n"];

    //create fixtures
    for (JSONFixtureObject *fixture in self.fixtures)
    {
        [text appendString:fixture.methodBody];
        [text appendString:[fixture methodBodyEnd:self.propertyItemName]];
    }

    [self closeBlock:text];
    
    return text;
}

- (NSString *)userDataItem
{
    return [NSString stringWithFormat:@"\tself.%@->SetUserData(data);\n", self.propertyItemName];
}

@end
