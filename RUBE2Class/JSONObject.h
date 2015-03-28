//
//  JSONObject.h
//  RUBE2Class
//
//  Created by Piotr on 22.02.2014.
//  Copyright (c) 2014 Piotr Zagawa. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol JSONObject

- (NSString *)propertyItem;
- (void)updateConstItem:(NSMutableString *)text;
- (NSString *)createItem;
- (NSString *)deallocItem;
- (NSString *)methodBody;
- (NSString *)userDataItem;

@end
