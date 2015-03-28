//
//  JSONShapeObject.m
//  RUBE2Class
//
//  Created by Piotr on 23.02.2014.
//  Copyright (c) 2014 Piotr Zagawa. All rights reserved.
//

#import "JSONShapeObject.h"
#import "JSONVectorObject.h"
#import "JSONVerticesObject.h"

@implementation JSONShapeObject

+ (JSONShapeObject *)fromFixture:(NSDictionary *)fixture
{
    id shape = nil;
    
    shape = fixture[@"circle"];
    if (shape != nil)
    {
        return [[JSONShapeObject alloc] initWithJsonObject:shape ofType:ShapeTypeCircle];
    }
    
    shape = fixture[@"polygon"];
    if (shape != nil)
    {
        return [[JSONShapeObject alloc] initWithJsonObject:shape ofType:ShapeTypePolygon];
    }
    
    shape = fixture[@"chain"];
    if (shape != nil)
    {
        return [[JSONShapeObject alloc] initWithJsonObject:shape ofType:ShapeTypeChain];
    }
    
    return nil;
}

- (id)initWithJsonObject:(NSDictionary *)shape ofType:(JSONShapeType)shapeType
{
    self = [super init];
    
    if (self)
    {
        //shape type and vertices
        self.shapeType = shapeType;
        
        if (self.shapeType == ShapeTypeCircle)
        {
            self.center = [JSONVectorObject read:shape[@"center"]];
            self.radius = shape[@"radius"];
        }
        
        if (self.shapeType == ShapeTypePolygon)
        {
            self.vertices = [[JSONVerticesObject alloc] initWithJsonObject:shape[@"vertices"]];
        }

        if (self.shapeType == ShapeTypeChain)
        {
            self.vertices = [[JSONVerticesObject alloc] initWithJsonObject:shape[@"vertices"]];
        }
        
        //other
        self.hasNextVertex = shape[@"hasNextVertex"];
        self.hasPrevVertex = shape[@"hasPrevVertex"];

        self.nextVertex = [JSONVectorObject read:shape[@"nextVertex"]];
        self.prevVertex = [JSONVectorObject read:shape[@"prevVertex"]];
    }
    
    return self;
}

- (NSString *)shapeText
{
    if (self.shapeType == ShapeTypeCircle)
    {
        return @"circle";
    }
    
    if (self.shapeType == ShapeTypePolygon)
    {
        return @"polygon";
    }
    
    if (self.shapeType == ShapeTypeChain)
    {
        return @"chain";
    }
    
    return @"(shape not set)";
}

- (NSString *)propertyItem
{
    return @"";
}

- (void)updateConstItem:(NSMutableString *)text
{
}

- (NSString *)createItem
{
    return @"";
}

- (NSString *)deallocItem
{
    return @"";
}

- (NSString *)hasNextVertexText
{
    if (self.hasNextVertex)
    {
        return (self.hasNextVertex.intValue == 1) ? @"true" : @"false";
    }
    
    return @"false";
}

- (NSString *)hasPrevVertexText
{
    if (self.hasPrevVertex)
    {
        return (self.hasPrevVertex.intValue == 1) ? @"true" : @"false";
    }
    
    return @"false";
}

- (NSString *)methodBody
{
    NSMutableString *text = [[NSMutableString alloc] init];
    
    [text appendString:@"\n\t\t"];
    [text appendFormat:@"//create shape: %@\n", self.shapeText];
    
    if (self.shapeType == ShapeTypeCircle)
    {
        [text appendString:@"\t\t"];
        [text appendString:@"b2CircleShape shape;"];
        [text appendString:@"\n\n"];

        [text appendString:@"\t\t"];
        [text appendFormat:@"shape.m_radius = %@;", self.radius];
        [text appendString:@"\n"];

        [text appendString:@"\t\t"];
        [text appendFormat:@"shape.m_p.Set(%@);", self.center.description];
        [text appendString:@"\n\n"];

        [text appendString:@"\t\t"];
        [text appendString:@"fd.shape = &shape;"];
        [text appendString:@"\n"];
    }
    
    if (self.shapeType == ShapeTypePolygon)
    {
        [text appendString:@"\t\t"];
        [text appendString:@"b2PolygonShape shape;"];
        [text appendString:@"\n"];
        [text appendString:@"\t\t"];
        [text appendString:@"b2Vec2 vs[8];"];
        [text appendString:@"\n\n"];

        [text appendString:self.vertices.textList];
        
        [text appendString:@"\t\t"];
        [text appendFormat:@"shape.Set(vs, %lu);", (unsigned long)self.vertices.list.count];
        [text appendString:@"\n"];
        
        [text appendString:@"\t\t"];
        [text appendString:@"fd.shape = &shape;"];
        [text appendString:@"\n"];
    }
    
    if (self.shapeType == ShapeTypeChain)
    {
        [text appendString:@"\t\t"];
        [text appendString:@"b2ChainShape shape;"];
        [text appendString:@"\n"];
        [text appendString:@"\t\t"];
        [text appendFormat:@"b2Vec2 vs[%lu];", (unsigned long)self.vertices.list.count];
        [text appendString:@"\n\n"];

        [text appendString:self.vertices.textList];

        [text appendString:@"\t\t"];
        [text appendFormat:@"shape.CreateChain(vs, %lu);", (unsigned long)self.vertices.list.count];
        [text appendString:@"\n"];
        [text appendString:@"\n"];

        //next/prev vertex
        [text appendString:@"\t\t"];
        [text appendFormat:@"shape.m_hasNextVertex = %@;", self.hasNextVertexText];
        [text appendString:@"\n"];

        [text appendString:@"\t\t"];
        [text appendFormat:@"shape.m_hasPrevVertex = %@;", self.hasPrevVertexText];
        [text appendString:@"\n"];

        [text appendString:@"\n"];
        
        if (self.nextVertex)
        {
            [text appendString:@"\t\t"];
            [text appendFormat:@"shape.m_nextVertex.Set(%@);", self.nextVertex.description];
            [text appendString:@"\n"];
        }

        if (self.prevVertex)
        {
            [text appendString:@"\t\t"];
            [text appendFormat:@"shape.m_prevVertex.Set(%@);", self.prevVertex.description];
            [text appendString:@"\n"];
        }

        if (self.nextVertex != nil || self.prevVertex != nil)
        {
            [text appendString:@"\n"];
        }
  
        [text appendString:@"\t\t"];
        [text appendString:@"fd.shape = &shape;"];
        [text appendString:@"\n"];
    }
    
    return text;
}

- (NSString *)userDataItem
{
    return @"";
}

@end
