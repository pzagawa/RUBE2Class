//
//  JSONJointObject.h
//  RUBE2Class
//
//  Created by Piotr on 25.02.2014.
//  Copyright (c) 2014 Piotr Zagawa. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ObjectIndexMapper.h"
#import "JSONObject.h"

typedef NS_ENUM(NSUInteger, JSONJointType)
{
    JointTypeRevolute = 0,
    JointTypeDistance = 1,
    JointTypePrismatic = 2,
    JointTypeWheel = 3,
    JointTypeRope = 4,
    JointTypeMotor = 5,
    JointTypeWeld = 6,
    JointTypeFriction = 7,
};

@class JSONVectorObject;

@interface JSONJointObject : NSObject <JSONObject>

@property BOOL isTest;

//common properties for all joints
@property NSString *name;
@property JSONJointType type;

@property JSONVectorObject *anchorA;
@property JSONVectorObject *anchorB;

@property NSNumber *indexBodyA;
@property NSNumber *indexBodyB;

@property BOOL isCollideConnected;

//other properties shared by some types
@property BOOL isEnableLimit;
@property BOOL isEnableMotor;

@property NSNumber *jointSpeed;

@property NSNumber *lowerLimit;
@property NSNumber *upperLimit;

@property NSNumber *maxMotorTorque;
@property NSNumber *maxMotorForce;
@property NSNumber *motorSpeed;

@property NSNumber *refAngle;
@property NSNumber *dampingRatio;
@property NSNumber *frequency;
@property NSNumber *length;

@property NSNumber *springDampingRatio;
@property NSNumber *springFrequency;

@property NSNumber *maxLength;
@property NSNumber *maxForce;
@property NSNumber *maxTorque;

@property NSNumber *correctionFactor;

@property JSONVectorObject *localAxisA;

- (id)initWithJsonObject:(NSDictionary *)joint andMapper:(id<ObjectIndexMapper>)mapper;

- (NSString *)propertyItemName;

- (NSString *)propertyItem;
- (NSString *)createItem;
- (NSString *)deallocItem;
- (NSString *)methodBody;
- (NSString *)userDataItem;

@end
