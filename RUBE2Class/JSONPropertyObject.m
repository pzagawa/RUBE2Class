//
//  JSONPropertyObject.m
//  RUBE2Class
//
//  Created by Piotr on 09.03.2014.
//  Copyright (c) 2014 Piotr Zagawa. All rights reserved.
//

#import "JSONPropertyObject.h"

@implementation JSONPropertyObject

- (id)initWithJsonObject:(NSDictionary *)property
{
    self = [super init];
    
    if (self)
    {
        self.name = property[@"name"];

        self.type = 0;

        id value = nil;
        
        value = property[@"int"];
        if (value != nil)
        {
            self.type = PropertyTypeInt;
            self.valueInteger = [value intValue];
        }
        
        value = property[@"float"];
        if (value != nil)
        {
            self.type = PropertyTypeFloat;
            self.valueFloat = [value floatValue];
        }

        value = property[@"string"];
        if (value != nil)
        {
            self.type = PropertyTypeString;
            self.valueString = value;
        }

        value = property[@"bool"];
        if (value != nil)
        {
            self.type = PropertyTypeBool;
            self.valueBool = ([value intValue] == 1);
        }
    }
    
    return self;
}

- (NSString *)propertyItemName
{
    return [NSString stringWithFormat:@"property_%@_%@", self.name, self.namePrefix];
}

- (NSString *)propertyItem
{
    if (self.type == PropertyTypeInt)
    {
        return [NSString stringWithFormat:@"int %@;\n", self.propertyItemName];
    }

    if (self.type == PropertyTypeFloat)
    {
        return [NSString stringWithFormat:@"float %@;\n", self.propertyItemName];
    }

    if (self.type == PropertyTypeString)
    {
        return [NSString stringWithFormat:@"NSString *%@;\n", self.propertyItemName];
    }

    if (self.type == PropertyTypeBool)
    {
        return [NSString stringWithFormat:@"BOOL %@;\n", self.propertyItemName];
    }
    
    return @"";
}

- (void)updateConstItem:(NSMutableString *)text
{
}

- (NSString *)createItem
{
    if (self.type == PropertyTypeInt)
    {
        return [NSString stringWithFormat:@"self.%@ = %d", self.propertyItemName, self.valueInteger];
    }
    
    if (self.type == PropertyTypeFloat)
    {
        return [NSString stringWithFormat:@"self.%@ = %f", self.propertyItemName, self.valueFloat];
    }
    
    if (self.type == PropertyTypeString)
    {
        return [NSString stringWithFormat:@"self.%@ = \"%@\"", self.propertyItemName, self.valueString];
    }
    
    if (self.type == PropertyTypeBool)
    {
        return [NSString stringWithFormat:@"self.%@ = %@", self.propertyItemName, (self.valueBool == YES) ? @"YES" : @"NO"];
    }

    return @"";
}

- (NSString *)deallocItem
{
    return @"";
}

- (NSString *)methodBody
{
    return @"";
}

- (NSString *)userDataItem
{
    return @"";
}

@end
