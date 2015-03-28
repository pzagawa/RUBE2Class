//
//  RUBEReader.m
//  RUBE2Class
//
//  Created by Piotr on 17.02.2014.
//  Copyright (c) 2014 Piotr Zagawa. All rights reserved.
//

#import "RUBEReader.h"
#import "JSONBodyObject.h"
#import "JSONJointObject.h"
#import "PZClassWriter.h"
#import <sysexits.h>

@implementation RUBEReader
{
    NSMutableDictionary *_mapBodies;
    PZClassWriter *_writer;
}

- (id)initWithJsonObjectFileName:(NSURL *)file
{
    self = [super init];
    
    if (self)
    {
        self->_writer = [[PZClassWriter alloc] init];
        self->_mapBodies = [[NSMutableDictionary alloc] init];
        
        id json = [self jsonObjectFromFile:file];
        
        if (json == nil)
        {
            self.exitCode = EX_NOINPUT;
        }
        else
        {
            self.exitCode = [self parseJsonObject:json];
        }
    }
    
    return self;
}

- (id)jsonObjectFromFile:(NSURL *)file
{
    NSError *error = nil;
    
    if ([file checkResourceIsReachableAndReturnError:&error] == YES)
    {
        NSData *data = [NSData dataWithContentsOfURL:file];
        
        if (data == nil)
        {
            self.errorMessage = @"file can not be loaded";
        }
        else
        {
            return [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
        }
    }
    else
    {
        self.errorMessage = [NSString stringWithFormat:@"source file has not been found: %@", error.localizedDescription];
    }
    
    return nil;
}

- (int)parseJsonObject:(id)json
{
    if ([json isKindOfClass:[NSDictionary class]])
    {
        NSDictionary *root = (NSDictionary *)json;
        
        NSArray *bodyList = root[@"body"];
        NSArray *jointList = root[@"joint"];
        
        if (bodyList != nil)
        {
            if ([bodyList isKindOfClass:[NSArray class]] == NO)
            {
                self.errorMessage = @"bad format/body object is not an Array";
                return EX_DATAERR;
            }
        }

        if (jointList != nil)
        {
            if ([jointList isKindOfClass:[NSArray class]] == NO)
            {
                self.errorMessage = @"bad format/joint object is not an Array";
                return EX_DATAERR;
            }
        }
        
        //parse body list
        {
            int index = 0;
            
            [self->_writer addMethodsText:[NSString stringWithFormat:@"//CREATE BODIES SECTION. COUNT: %lu\n\n", (unsigned long)bodyList.count]];

            for (NSDictionary *bodyObject in bodyList)
            {
                [self processBodyObject:bodyObject atIndex:index];
                
                index++;
            }
        }

        [self->_writer addSpace];

        //parse joint list
        {
            [self->_writer addMethodsText:[NSString stringWithFormat:@"//CREATE JOINTS SECTION. COUNT: %lu\n\n", (unsigned long)jointList.count]];

            for (NSDictionary *jointObject in jointList)
            {
                [self processJointObject:jointObject];
            }
        }

        return EX_OK;
    }
    else
    {
        self.errorMessage = @"bad format/root object is not a Dictionary";
        return EX_DATAERR;
    }
}

- (void)processBodyObject:(NSDictionary *)bodyObject atIndex:(int)index
{
    JSONBodyObject *object = [[JSONBodyObject alloc] initWithJsonObject:bodyObject];
    
    if (object.isTest)
    {
        NSLog(@"Skipping test body: %@", object.name);
        return;
    }
    
    [self->_writer addObject:object];
    
    NSNumber *key = [NSNumber numberWithInt:index];

    [self->_mapBodies setObject:object forKey:key];
}

- (void)processJointObject:(NSDictionary *)jointObject
{
    JSONJointObject *object = [[JSONJointObject alloc] initWithJsonObject:jointObject andMapper:self];
    
    if (object.isTest)
    {
        NSLog(@"Skipping test joint: %@", object.name);
        return;
    }
    
    [self->_writer addObject:object];
}

- (id)bodyByIndex:(int)index
{
    NSNumber *key = [NSNumber numberWithInt:index];
    
    return [self->_mapBodies objectForKey:key];
}

- (NSString *)textHeaderFile
{
    return [self->_writer textHeaderFile];
}

- (NSString *)textSourceFile
{
    return [self->_writer textSourceFile];
}

- (void)setTargetName:(NSString *)targetName
{
    self->_writer.targetName = targetName;
}

- (NSString *)targetName
{
    return self->_writer.targetName;
}

@end
