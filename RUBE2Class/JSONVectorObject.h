//
//  JSONVector.h
//  RUBE2Class
//
//  Created by Piotr on 18.02.2014.
//  Copyright (c) 2014 Piotr Zagawa. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JSONVectorObject : NSObject

@property float x;
@property float y;

- (id)initWithZero;
- (id)initWithX:(float)x andY:(float)y;
- (id)initWithJsonObject:(NSDictionary *)body;

- (NSString *)description;
- (NSString *)debugDescription;

+ (JSONVectorObject *)read:(id)value;

@end
