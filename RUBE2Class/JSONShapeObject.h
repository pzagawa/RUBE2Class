//
//  JSONShapeObject.h
//  RUBE2Class
//
//  Created by Piotr on 23.02.2014.
//  Copyright (c) 2014 Piotr Zagawa. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSONObject.h"

typedef NS_ENUM(NSUInteger, JSONShapeType)
{
    ShapeTypeCircle = 0,
    ShapeTypePolygon = 1,
    ShapeTypeChain = 2
};

@class JSONVectorObject;
@class JSONVerticesObject;

@interface JSONShapeObject : NSObject <JSONObject>

@property JSONShapeType shapeType;

@property JSONVectorObject *center;
@property NSNumber *radius;
@property JSONVerticesObject *vertices;

@property NSNumber *hasNextVertex;
@property NSNumber *hasPrevVertex;

@property JSONVectorObject *nextVertex;
@property JSONVectorObject *prevVertex;

+ (JSONShapeObject *)fromFixture:(NSDictionary *)fixture;

- (id)initWithJsonObject:(NSDictionary *)shape ofType:(JSONShapeType)shapeType;

- (NSString *)shapeText;

- (NSString *)propertyItem;
- (NSString *)createItem;
- (NSString *)deallocItem;
- (NSString *)methodBody;
- (NSString *)userDataItem;

@end
