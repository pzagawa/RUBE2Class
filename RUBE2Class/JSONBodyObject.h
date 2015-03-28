//
//  JSONBodyObject.h
//  RUBE2Class
//
//  Created by Piotr on 18.02.2014.
//  Copyright (c) 2014 Piotr Zagawa. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSONObject.h"

typedef NS_ENUM(NSUInteger, JSONBodyType)
{
    BodyTypeStatic = 0,
    BodyTypeKinematic = 1,
    BodyTypeDynamic = 2
};

@class JSONVectorObject;

@interface JSONBodyObject : NSObject <JSONObject>

@property BOOL isTest;

@property NSString *name;
@property JSONBodyType type;

@property NSNumber *angle;

@property NSNumber *angularVelocity;
@property JSONVectorObject *linearVelocity;

@property NSNumber *angularDamping;
@property NSNumber *linearDamping;

@property BOOL isAwake;
@property BOOL isFixedRotation;
@property BOOL isBullet;

@property JSONVectorObject *position;
@property JSONVectorObject *massDataCenter;

@property NSMutableArray *fixtures;
@property NSMutableArray *properties;

- (id)initWithJsonObject:(NSDictionary *)body;

- (NSString *)propertyItemName;

- (NSString *)propertyItem;
- (NSString *)createItem;
- (NSString *)deallocItem;
- (NSString *)methodBody;
- (NSString *)userDataItem;

@end
