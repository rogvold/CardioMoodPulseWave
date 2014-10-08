//
//  BezierVC.m
//  CMPulseWave
//
//  Created by nastia on 08.10.14.
//  Copyright (c) 2014 Анастасия. All rights reserved.
//

#import "BezierVC.h"

@interface BezierVC ()

@end

@implementation BezierVC

#pragma Drawing Bezier Logic

-(NSArray *) xDots{
    NSArray *dots = @[@(10), @(20), @(30), @(40)];
    return dots;
}
-(NSArray *) yDots{
    NSArray *dots = @[@(10), @(50), @(160), @(512)];
    return dots;
}

//self.setNeedsDisplay

-(void)drawRect:(CGRect)rect{
    [super drawRect:rect];
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGAffineTransform transform = CGAffineTransformIdentity;
    transform = CGAffineTransformScale(transform, 1.0f, -1.0f);
    transform = CGAffineTransformTranslate(transform, 0, -self.bounds.size.height);
    CGContextConcatCTM(context, transform);
    
    [self drawingWithYDots:self.yDots andXDots:self.xDots inContext:context];
    CGPoint next = CGPointMake(50, 50);
}

-(void)drawingWithYDots:(NSArray *)yDots andXDots:(NSArray *)xDots inContext:(CGContextRef)context{
    
    //line
    CGContextSetRGBStrokeColor(context, 1.0, 1.0, 1.0, 1);
    CGContextSetLineWidth(context, 2);
    
    // Draw a bezier curve with end points and control points
    CGPoint start = CGPointMake([xDots.firstObject integerValue], [yDots.firstObject integerValue]);
    CGPoint end = CGPointMake([xDots.lastObject integerValue], [yDots.lastObject integerValue]);
    CGPoint p1 = CGPointMake([xDots[1] integerValue], [yDots[1] integerValue]);
    CGPoint p2 = CGPointMake([xDots[2] integerValue], [yDots[2] integerValue]);
    
    CGContextMoveToPoint(context, start.x, start.y);
    CGContextAddCurveToPoint(context, p1.x, p1.y, p2.x, p2.y,end.x, end.y);
    CGContextStrokePath(context);
    
}

@end
