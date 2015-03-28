//
//  PZClassWriter.h
//  RUBE2Class
//
//  Created by Piotr on 22.02.2014.
//  Copyright (c) 2014 Piotr Zagawa. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSONObject.h"

@interface PZClassWriter : NSObject

@property NSString *targetName;

- (void)addSpace;
- (void)addObject:(id<JSONObject>)object;
- (void)addMethodsText:(NSString *)text;

- (NSString *)textHeaderFile;
- (NSString *)textSourceFile;

@end
