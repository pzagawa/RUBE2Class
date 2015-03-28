//
//  JSONVerticesObject.h
//  RUBE2Class
//
//  Created by Piotr on 23.02.2014.
//  Copyright (c) 2014 Piotr Zagawa. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSONObject.h"

@interface JSONVerticesObject : NSObject

@property NSArray *list;

- (id)initWithJsonObject:(NSDictionary *)vectorArray;

- (NSString *)textList;

@end
