//
//  PZClassWriter.m
//  RUBE2Class
//
//  Created by Piotr on 22.02.2014.
//  Copyright (c) 2014 Piotr Zagawa. All rights reserved.
//

#import "PZClassWriter.h"

@implementation PZClassWriter
{
    NSMutableString *_propertiesBlock;
    NSMutableString *_constsBlock;
    NSMutableString *_createBlock;
    NSMutableString *_deallocBlock;
    NSMutableString *_methodsBlock;
    NSMutableString *_userDataMethod;
}

- (id)init
{
    self = [super init];
    
    if (self)
    {
        self->_propertiesBlock = [[NSMutableString alloc] init];
        self->_constsBlock = [[NSMutableString alloc] init];
        self->_createBlock = [[NSMutableString alloc] init];
        self->_deallocBlock = [[NSMutableString alloc] init];
        self->_methodsBlock = [[NSMutableString alloc] init];
        self->_userDataMethod = [[NSMutableString alloc] init];
    }
    
    return self;
}

- (void)addSpace
{
    [self->_createBlock appendString:@"\n"];
}

- (void)addObject:(id<JSONObject>)object
{
    [self->_propertiesBlock appendFormat:@"@property (readonly, nonatomic) %@", object.propertyItem];
    
    [object updateConstItem:self->_constsBlock];
    
    [self->_createBlock appendString:object.createItem];
    
    [self->_deallocBlock appendString:object.deallocItem];
    
    [self->_methodsBlock appendString:object.methodBody];
    
    [self->_userDataMethod appendString:object.userDataItem];
}

- (void)addMethodsText:(NSString *)text
{
    [self->_methodsBlock appendString:text];
}

- (NSString *)textHeaderFileName
{
    return [self.targetName stringByAppendingPathExtension:@"h"];
}

- (NSString *)textSourceFileName
{
    return [self.targetName stringByAppendingPathExtension:@"m"];
}

- (NSString *)textHeaderFile
{
    NSMutableString *text = [[NSMutableString alloc] init];

    [text appendString:@"\n//PhysData file generated from RUBE json.\n"];
    [text appendFormat:@"//%@.\n\n", [[[NSDate alloc] init] description]];

    [text appendString:@"#import <Foundation/Foundation.h>\n"];
    [text appendString:@"#import <Box2D.h>\n\n"];
    [text appendString:@"#import \"PZCharacterPhysData.h\"\n\n"];

    [text appendFormat:@"@interface %@ : PZCharacterPhysData\n\n", self.targetName];

    [text appendString:@"@property b2World *physWorld;\n\n"];

    [text appendString:@"@property int collisionBitsCategory;\n"];
    [text appendString:@"@property int collisionBitsMask;\n\n"];

    [text appendString:self->_propertiesBlock];

    [text appendString:@"\n"];

    [text appendString:@"- (void)create;\n"];
    [text appendString:@"- (void)setUserData:(void *)data;\n"];
    
    [text appendString:@"\n"];

    [text appendString:@"@end\n"];
    
    return text;
}

- (NSString *)textSourceFile
{
    NSMutableString *text = [[NSMutableString alloc] init];

    [text appendString:@"\n//PhysData file generated from RUBE json.\n"];
    [text appendFormat:@"//%@.\n\n", [[[NSDate alloc] init] description]];

    [text appendFormat:@"#import \"%@\"\n", self.textHeaderFileName];

    [text appendString:@"\n"];

    [text appendFormat:@"@implementation %@\n", self.targetName];
    
    [text appendString:@"\n"];

    if (self->_constsBlock.length > 0)
    {
        [text appendFormat:@"%@\n", self->_constsBlock];
    }
    
    [text appendString:@"- (void)create\n"];
    [text appendFormat:@"{\n%@}\n\n", self->_createBlock];
    
    //[text appendString:@"- (void)dealloc\n"];
    //[text appendFormat:@"{\n%@}\n\n", self->_deallocBlock];
    
    [text appendString:@"- (void)setUserData:(void *)data\n"];
    [text appendFormat:@"{\n%@}\n\n", self->_userDataMethod];
    
    [text appendFormat:@"%@", self->_methodsBlock];
    
    [text appendString:@"@end\n"];

    return text;
}

@end
