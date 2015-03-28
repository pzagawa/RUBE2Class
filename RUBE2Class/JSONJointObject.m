//
//  JSONJointObject.m
//  RUBE2Class
//
//  Created by Piotr on 25.02.2014.
//  Copyright (c) 2014 Piotr Zagawa. All rights reserved.
//

#import "JSONJointObject.h"
#import "JSONVectorObject.h"

@implementation JSONJointObject
{
    __weak id<ObjectIndexMapper> _mapper;
}

- (id)initWithJsonObject:(NSDictionary *)joint andMapper:(id<ObjectIndexMapper>)mapper;
{
    self = [super init];
    
    if (self)
    {
        self->_mapper = mapper;
        
        self.name = joint[@"name"];
        
        if ([self.name hasSuffix:@"_test"] == YES)
        {
            self.isTest = YES;
        }

        self.type = [self typeFromString:joint[@"type"]];

        self.anchorA = [JSONVectorObject read:joint[@"anchorA"]];
        self.anchorB = [JSONVectorObject read:joint[@"anchorB"]];

        self.indexBodyA = joint[@"bodyA"];
        self.indexBodyB = joint[@"bodyB"];
        
        self.isCollideConnected = ([(NSNumber *)(joint[@"collideConnected"]) longValue] == 1);
        
        //optional properties
        self.isEnableLimit = ([(NSNumber *)(joint[@"enableLimit"]) longValue] == 1);
        self.isEnableMotor = ([(NSNumber *)(joint[@"enableMotor"]) longValue] == 1);

        self.jointSpeed = joint[@"jointSpeed"];

        self.lowerLimit = joint[@"lowerLimit"];
        self.upperLimit = joint[@"upperLimit"];

        self.maxMotorTorque = joint[@"maxMotorTorque"];
        self.maxMotorForce = joint[@"maxMotorForce"];
        self.motorSpeed = joint[@"motorSpeed"];

        self.refAngle = joint[@"refAngle"];
        self.dampingRatio = joint[@"dampingRatio"];
        self.frequency = joint[@"frequency"];
        self.length = joint[@"length"];

        self.springDampingRatio = joint[@"springDampingRatio"];
        self.springFrequency = joint[@"springFrequency"];

        self.maxLength = joint[@"maxLength"];
        self.maxForce = joint[@"maxForce"];
        self.maxTorque = joint[@"maxTorque"];

        self.correctionFactor = joint[@"correctionFactor"];

        self.localAxisA = [JSONVectorObject read:joint[@"localAxisA"]];
    }
    
    return self;
}

- (NSString *)methodName
{
    return [NSString stringWithFormat:@"create_joint_%@", self.name];
}

- (JSONJointType)typeFromString:(NSString *)text
{
    if ([text isEqualToString:@"revolute"])
    {
        return JointTypeRevolute;
    }
    
    if ([text isEqualToString:@"distance"])
    {
        return JointTypeDistance;
    }
    
    if ([text isEqualToString:@"prismatic"])
    {
        return JointTypePrismatic;
    }
    
    if ([text isEqualToString:@"wheel"])
    {
        return JointTypeWheel;
    }
    
    if ([text isEqualToString:@"rope"])
    {
        return JointTypeRope;
    }
    
    if ([text isEqualToString:@"motor"])
    {
        return JointTypeMotor;
    }

    if ([text isEqualToString:@"weld"])
    {
        return JointTypeWeld;
    }

    if ([text isEqualToString:@"friction"])
    {
        return JointTypeFriction;
    }
    
    [NSException raise:@"Joint type not valid" format:@"type %@ not recognized", text];

    return -1;
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
    return [NSString stringWithFormat:@"joint_%@", self.name];
}

- (NSString *)propertyItem
{
    return [NSString stringWithFormat:@"%@ *%@;\n", self.jointType, self.propertyItemName];
}

- (void)updateConstItem:(NSMutableString *)text
{
}

- (NSString *)createItem
{
    return [NSString stringWithFormat:@"\t[self %@];\n", self.methodName];
}

- (NSString *)deallocItem
{
    return @"";
}

- (NSString *)bodyObjectNameA
{
    return [[self->_mapper bodyByIndex:self.indexBodyA.intValue] propertyItemName];
}

- (NSString *)bodyObjectNameB
{
    return [[self->_mapper bodyByIndex:self.indexBodyB.intValue] propertyItemName];
}

- (NSString *)methodBody
{
    NSMutableString *text = [[NSMutableString alloc] init];
    
    [text appendFormat:@"- (void)%@\n", self.methodName];
    
    [self openBlock:text];
    
    //create joint
    [text appendString:@"\t"];
    [text appendFormat:@"%@ jd;", self.typeDef];
    [text appendString:@"\n\n"];

    [text appendString:@"\t"];
    [text appendFormat:@"jd.bodyA = self->_%@;", self.bodyObjectNameA];
    [text appendString:@"\n"];

    [text appendString:@"\t"];
    [text appendFormat:@"jd.bodyB = self->_%@;", self.bodyObjectNameB];
    [text appendString:@"\n"];

    [text appendString:@"\n"];

    [text appendString:@"\t"];
    [text appendFormat:@"jd.localAnchorA.Set(%@);", self.anchorA.description];
    [text appendString:@"\n"];
    
    [text appendString:@"\t"];
    [text appendFormat:@"jd.localAnchorB.Set(%@);", self.anchorB.description];
    [text appendString:@"\n"];
    
    [text appendString:@"\n"];

    [text appendString:@"\t"];
    [text appendFormat:@"jd.collideConnected = %hhd;", self.isCollideConnected];
    [text appendString:@"\n"];
    
    switch (self.type)
    {
        case JointTypeRevolute:
            [self addPropertiesTypeRevolute:text];
            break;
        case JointTypeDistance:
            [self addPropertiesTypeDistance:text];
            break;
        case JointTypePrismatic:
            [self addPropertiesTypePrismatic:text];
            break;
        case JointTypeWheel:
            [self addPropertiesTypeWheel:text];
            break;
        case JointTypeRope:
            [self addPropertiesTypeRope:text];
            break;
        case JointTypeMotor:
            [self addPropertiesTypeMotor:text];
            break;
        case JointTypeWeld:
            [self addPropertiesTypeWeld:text];
            break;
        case JointTypeFriction:
            [self addPropertiesTypeFriction:text];
            break;
    }
    
    [text appendString:@"\n"];
    
    [text appendString:@"\t"];
    [text appendFormat:@"self.%@ = (%@ *)self.physWorld->CreateJoint(&jd);", self.propertyItemName, self.jointType];
    [text appendString:@"\n"];

    [self closeBlock:text];
    
    return text;
}

- (void)addPropertiesTypeRevolute:(NSMutableString *)text
{
    [text appendString:@"\t"];
    [text appendFormat:@"jd.referenceAngle = %@;", self.refAngle];
    [text appendString:@"\n"];

    [text appendString:@"\t"];
    [text appendFormat:@"jd.lowerAngle = %@;", self.lowerLimit];
    [text appendString:@"\n"];

    [text appendString:@"\t"];
    [text appendFormat:@"jd.upperAngle = %@;", self.upperLimit];
    [text appendString:@"\n"];

    [text appendString:@"\t"];
    [text appendFormat:@"jd.enableLimit = %hhd;", self.isEnableLimit];
    [text appendString:@"\n"];

    [text appendString:@"\t"];
    [text appendFormat:@"jd.enableMotor = %hhd;", self.isEnableMotor];
    [text appendString:@"\n"];

    [text appendString:@"\t"];
    [text appendFormat:@"jd.motorSpeed = %@;", self.motorSpeed];
    [text appendString:@"\n"];

    [text appendString:@"\t"];
    [text appendFormat:@"jd.maxMotorTorque = %@;", self.maxMotorTorque];
    [text appendString:@"\n"];
}

- (void)addPropertiesTypeDistance:(NSMutableString *)text
{
    [text appendString:@"\t"];
    [text appendFormat:@"jd.dampingRatio = %@;", self.dampingRatio];
    [text appendString:@"\n"];

    [text appendString:@"\t"];
    [text appendFormat:@"jd.frequencyHz = %@;", self.frequency];
    [text appendString:@"\n"];

    [text appendString:@"\t"];
    [text appendFormat:@"jd.length = %@;", self.length];
    [text appendString:@"\n"];
}

- (void)addPropertiesTypePrismatic:(NSMutableString *)text
{
    [text appendString:@"\t"];
    [text appendFormat:@"jd.enableLimit = %hhd;", self.isEnableLimit];
    [text appendString:@"\n"];
    
    [text appendString:@"\t"];
    [text appendFormat:@"jd.enableMotor = %hhd;", self.isEnableMotor];
    [text appendString:@"\n"];
    
    [text appendString:@"\t"];
    [text appendFormat:@"jd.localAxisA.Set(%@);", self.localAxisA.description];
    [text appendString:@"\n"];

    [text appendString:@"\t"];
    [text appendFormat:@"jd.referenceAngle = %@;", self.refAngle];
    [text appendString:@"\n"];
    
    [text appendString:@"\t"];
    [text appendFormat:@"jd.lowerTranslation = %@;", self.lowerLimit];
    [text appendString:@"\n"];
    
    [text appendString:@"\t"];
    [text appendFormat:@"jd.upperTranslation = %@;", self.upperLimit];
    [text appendString:@"\n"];

    [text appendString:@"\t"];
    [text appendFormat:@"jd.motorSpeed = %@;", self.motorSpeed];
    [text appendString:@"\n"];

    [text appendString:@"\t"];
    [text appendFormat:@"jd.maxMotorForce = %@;", self.maxMotorForce];
    [text appendString:@"\n"];
}

- (void)addPropertiesTypeWheel:(NSMutableString *)text
{
    [text appendString:@"\t"];
    [text appendFormat:@"jd.localAxisA.Set(%@);", self.localAxisA.description];
    [text appendString:@"\n"];

    [text appendString:@"\t"];
    [text appendFormat:@"jd.enableMotor = %hhd;", self.isEnableMotor];
    [text appendString:@"\n"];
    
    [text appendString:@"\t"];
    [text appendFormat:@"jd.maxMotorTorque = %@;", self.maxMotorTorque];
    [text appendString:@"\n"];

    [text appendString:@"\t"];
    [text appendFormat:@"jd.motorSpeed = %@;", self.motorSpeed];
    [text appendString:@"\n"];

    [text appendString:@"\t"];
    [text appendFormat:@"jd.dampingRatio = %@;", self.springDampingRatio];
    [text appendString:@"\n"];

    [text appendString:@"\t"];
    [text appendFormat:@"jd.frequencyHz = %@;", self.springFrequency];
    [text appendString:@"\n"];
}

- (void)addPropertiesTypeRope:(NSMutableString *)text
{
    [text appendString:@"\t"];
    [text appendFormat:@"jd.maxLength = %@;", self.maxLength];
    [text appendString:@"\n"];
}

- (void)addPropertiesTypeMotor:(NSMutableString *)text
{
    [text appendString:@"\t"];
    [text appendFormat:@"jd.linearOffset.Set(%@);", self.anchorA.description];
    [text appendString:@"\n"];

    [text appendString:@"\t"];
    [text appendFormat:@"jd.correctionFactor = %@;", self.correctionFactor];
    [text appendString:@"\n"];
    
    [text appendString:@"\t"];
    [text appendFormat:@"jd.maxForce = %@;", self.maxForce];
    [text appendString:@"\n"];

    [text appendString:@"\t"];
    [text appendFormat:@"jd.maxTorque = %@;", self.maxTorque];
    [text appendString:@"\n"];
}

- (void)addPropertiesTypeWeld:(NSMutableString *)text
{
    [text appendString:@"\t"];
    [text appendFormat:@"jd.referenceAngle = %@;", self.refAngle];
    [text appendString:@"\n"];

    [text appendString:@"\t"];
    [text appendFormat:@"jd.frequencyHz = %@;", self.frequency];
    [text appendString:@"\n"];

    [text appendString:@"\t"];
    [text appendFormat:@"jd.dampingRatio = %@;", self.dampingRatio];
    [text appendString:@"\n"];
}

- (void)addPropertiesTypeFriction:(NSMutableString *)text
{
    [text appendString:@"\t"];
    [text appendFormat:@"jd.maxForce = %@;", self.maxForce];
    [text appendString:@"\n"];
    
    [text appendString:@"\t"];
    [text appendFormat:@"jd.maxTorque = %@;", self.maxTorque];
    [text appendString:@"\n"];
}

- (NSString *)typeDef
{
    switch (self.type)
    {
        case JointTypeRevolute:
            return @"b2RevoluteJointDef";
        case JointTypeDistance:
            return @"b2DistanceJointDef";
        case JointTypePrismatic:
            return @"b2PrismaticJointDef";
        case JointTypeWheel:
            return @"b2WheelJointDef";
        case JointTypeRope:
            return @"b2RopeJointDef";
        case JointTypeMotor:
            return @"b2MotorJointDef";
        case JointTypeWeld:
            return @"b2WeldJointDef";
        case JointTypeFriction:
            return @"b2FrictionJointDef";
    }

    return @"b2_UNDEFINED_TYPE";
}

- (NSString *)jointType
{
    switch (self.type)
    {
        case JointTypeRevolute:
            return @"b2RevoluteJoint";
        case JointTypeDistance:
            return @"b2DistanceJoint";
        case JointTypePrismatic:
            return @"b2PrismaticJoint";
        case JointTypeWheel:
            return @"b2WheelJoint";
        case JointTypeRope:
            return @"b2RopeJoint";
        case JointTypeMotor:
            return @"b2MotorJoint";
        case JointTypeWeld:
            return @"b2WeldJoint";
        case JointTypeFriction:
            return @"b2FrictionJoint";
    }
    
    return @"b2_UNDEFINED_TYPE";
}

- (NSString *)userDataItem
{
    return @"";
}

@end
