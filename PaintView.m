//
//  PaintView.m
//  painter_test
//
//  Created by Apple on 2014/4/1.
//  Copyright (c) 2014年 Hsueh. All rights reserved.
//

#import "PaintView.h"
#import <QuartzCore/QuartzCore.h>

@interface PaintView()

@property (strong, nonatomic) UIBezierPath *path;
@property (strong, nonatomic) UIImage *tempImage;
@property (nonatomic) CGSize viewSize;
@property (strong, nonatomic) NSMutableArray *points;
@property (nonatomic) uint index;

@end

@implementation PaintView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.path = [UIBezierPath bezierPath];
        self.path.lineWidth = 5.0;
        self.path.lineCapStyle = kCGLineCapRound;
        self.backgroundColor = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:0.0];
        self.viewSize = self.bounds.size;
        self.points = [[NSMutableArray alloc] initWithCapacity:5];
    }
    
    return self;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    
    self.index = 0;
    self.points[0] = [NSValue valueWithCGPoint:[touch locationInView:self]];
    
    NSLog(@"touch begins!");
}

- (void) touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    CGPoint p = [touch locationInView:self];
    
    self.index++;
    self.points[self.index] = [NSValue valueWithCGPoint:p];
    
    if(self.index==4)
    {
        float x = ([self.points[2] CGPointValue].x + [self.points[4] CGPointValue].x)/2.0;
        float y = ([self.points[2] CGPointValue].y + [self.points[4] CGPointValue].y)/2.0;
        self.points[3] = [NSValue valueWithCGPoint:CGPointMake(x, y)];
        [self.path moveToPoint:[self.points[0] CGPointValue]];
        
        [self.path addCurveToPoint:[self.points[3] CGPointValue] controlPoint1:[self.points[1] CGPointValue]
                                                               controlPoint2:[self.points[2] CGPointValue]];
        [self setNeedsDisplay];

        self.points[0] = self.points[3];
        self.points[1] = self.points[4];
        self.index = 1;
        
    }
    
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{

    [self drawBitmap];
    [self setNeedsDisplay];
    [self.path removeAllPoints];
    self.index = 0;
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self touchesEnded:touches withEvent:event];
}

- (void)drawRect:(CGRect)rect
{
    [self.tempImage drawInRect:rect];
    [[UIColor blackColor] setStroke];
    [self.path stroke];
}

- (void)drawBitmap
{
    UIGraphicsBeginImageContextWithOptions(self.viewSize, NO, 0.0);
    [[UIColor blackColor] setStroke];
    if (!self.tempImage)
    {
        UIBezierPath *rectpath = [UIBezierPath bezierPathWithRect:self.bounds];
        [[UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:0.0] setFill];
        [rectpath fill];
        NSLog(@"First draw!!");
    }
    [self.tempImage drawAtPoint:CGPointZero];
    [self.path stroke];
    
    [self.layer renderInContext:UIGraphicsGetCurrentContext()];
    self.tempImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    NSLog(@"Touches ended! Draw bitmap!");
}

@end
