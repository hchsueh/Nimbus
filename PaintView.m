//
//  PaintView.m
//  painter_test
//
//  Created by Apple on 2014/4/1.
//  Copyright (c) 2014年 Hsueh. All rights reserved.
//

#import "PaintView.h"
#import <QuartzCore/QuartzCore.h>

@implementation PaintView
{
    UIBezierPath *path;
    UIImage *incrImage;
    CGSize viewSize;
    
    CGPoint pts[5];
    uint cnt;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        path = [UIBezierPath bezierPath];
        path.lineWidth = 5.0;
        path.lineCapStyle = kCGLineCapRound;
        self.backgroundColor = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:0.0];
        viewSize = self.bounds.size;
    }
    
    return self;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
//    CGPoint p = [touch locationInView:self];
//    [path moveToPoint:p];
//    
    cnt = 0;
    pts[0] = [touch locationInView:self];
    
    NSLog(@"touch begins!");
}

- (void) touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    CGPoint p = [touch locationInView:self];
    
    cnt++;
    pts[cnt] = p;
    if(cnt==4)
    {
        pts[3] = CGPointMake((pts[2].x + pts[4].x)/2.0, (pts[2].y + pts[4].y)/2.0);
        [path moveToPoint:pts[0]];
        [path addCurveToPoint:pts[3] controlPoint1:pts[1] controlPoint2:pts[2]];
        [self setNeedsDisplay];
//        
//        [path moveToPoint:pts[0]];
//        [path addCurveToPoint:pts[3] controlPoint1:pts[1] controlPoint2:pts[2]];
//        [self setNeedsDisplay];
        
        pts[0] = pts[3];
        pts[1] = pts[4];
        cnt = 1;
        
    }
    
//    [path addLineToPoint:p];
//    [self setNeedsDisplay];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
//    UITouch *touch = [touches anyObject];
//    CGPoint p = [touch locationInView:self];
//    [path addLineToPoint:p];
//    
    [self drawBitmap];
    [self setNeedsDisplay];
    [path removeAllPoints];
    cnt = 0;
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self touchesEnded:touches withEvent:event];
}

- (void)drawRect:(CGRect)rect
{
    [incrImage drawInRect:rect];
    [[UIColor blackColor] setStroke];
    [path stroke];
}

- (void)drawBitmap
{
    UIGraphicsBeginImageContextWithOptions(viewSize, NO, 0.0);
    [[UIColor blackColor] setStroke];
    if (!incrImage) // first draw; paint background white by ...
    {
        UIBezierPath *rectpath = [UIBezierPath bezierPathWithRect:self.bounds]; // enclosing bitmap by a rectangle defined by another UIBezierPath object
        [[UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:0.0] setFill];
        [rectpath fill]; // filling it with white
        NSLog(@"First draw!!");
    }
    [incrImage drawAtPoint:CGPointZero];
    [path stroke];
    
    [self.layer renderInContext:UIGraphicsGetCurrentContext()];
    incrImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    NSLog(@"Touches ended! Draw bitmap!");
}

@end
