//
//  JSONFixtureObject.h
//  RUBE2Class
//
//  Created by Piotr on 22.02.2014.
//  Copyright (c) 2014 Piotr Zagawa. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSONObject.h"

@class JSONVectorObject;
@class JSONShapeObject;

@interface JSONFixtureObject : NSObject <JSONObject>

@property BOOL isTest;

@property NSString *name;

@property NSNumber *density;
@property NSNumber *friction;
@property NSNumber *restitution;

@property NSNumber *filterCategoryBits;
@property NSNumber *filterMaskBits;
@property NSNumber *filterGroupIndex;

@property BOOL isSensor;

@property JSONShapeObject *shapeObject;

- (id)initWithJsonObject:(NSDictionary *)fixture;

- (NSString *)propertyItemName;

- (NSString *)propertyItem;
- (void)updateConstItem:(NSMutableString *)text;
- (NSString *)createItem;
- (NSString *)deallocItem;
- (NSString *)methodBody;
- (NSString *)userDataItem;

- (NSString *)methodBodyEnd:(NSString *)parentName;

@end
