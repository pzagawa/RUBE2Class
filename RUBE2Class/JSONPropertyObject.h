//
//  JSONPropertyObject.h
//  RUBE2Class
//
//  Created by Piotr on 09.03.2014.
//  Copyright (c) 2014 Piotr Zagawa. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSONObject.h"

typedef NS_ENUM(NSUInteger, JSONPropertyType)
{
    PropertyTypeInt = 1,
    PropertyTypeFloat = 2,
    PropertyTypeString = 3,
    PropertyTypeBool = 4
};

@interface JSONPropertyObject : NSObject <JSONObject>

@property NSString *namePrefix;

@property NSString *name;

@property JSONPropertyType type;

@property int valueInteger;
@property float valueFloat;
@property BOOL valueBool;
@property NSString *valueString;

- (id)initWithJsonObject:(NSDictionary *)property;

@end
