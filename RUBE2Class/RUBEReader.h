//
//  RUBEReader.h
//  RUBE2Class
//
//  Created by Piotr on 17.02.2014.
//  Copyright (c) 2014 Piotr Zagawa. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ObjectIndexMapper.h"

@interface RUBEReader : NSObject <ObjectIndexMapper>

@property NSString *targetName;

@property int exitCode;
@property NSString *errorMessage;

- (id)initWithJsonObjectFileName:(NSURL *)file;
- (id)bodyByIndex:(int)index;

- (NSString *)textHeaderFile;
- (NSString *)textSourceFile;

@end
