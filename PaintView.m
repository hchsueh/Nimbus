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

@property (strong, nonatomic) UIImage *storedImage;
@property (strong, nonatomic) UIImage *glowPathImage;
@property (nonatomic) CGSize viewSize;
@property (strong, nonatomic) NSMutableArray *points;
@property (nonatomic) uint index;
@property (strong, nonatomic) NSDate *pathBeganTime;
@property (nonatomic) BOOL isFirstDraw;

@end

@implementation PaintView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.viewSize = self.bounds.size;
        self.points = [[NSMutableArray alloc] initWithCapacity:5];
        self.paths = [NSMutableArray array];
        self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0];
        self.isFirstDraw = true;

    }
    
    return self;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    if(self.canDraw){
        
        UITouch *touch = [touches anyObject];
        
        // initiate path
        UIBezierPath *path = [UIBezierPath bezierPath];
        [self.paths addObject:path];
        
        self.index = 0;
        CGPoint p = [touch locationInView:self];
        self.points[0] = [NSValue valueWithCGPoint:p];
        
        self.pathBeganTime = [NSDate date];
        
        [self.delegate beginPath: CGPointMake(p.x, self.frame.size.height - p.y)];
        if(self.isFirstDraw){
        
            self.isFirstDraw = false;
            [self.delegate startDrawing];
        
        }
    }
}

- (void) touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    if(self.canDraw){
        UITouch *touch = [touches anyObject];
        CGPoint p = [touch locationInView:self];
        
        self.index++;
        self.points[self.index] = [NSValue valueWithCGPoint:p];
        
        if(self.index == 4){
            
            [self.delegate createPath:[self createBezier] withTimeInterval:[self.pathBeganTime timeIntervalSinceNow]*(-1)];
            self.pathBeganTime = [NSDate date];
            
        }
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self drawBitmap];
    self.index = 0;
    [self.delegate closePath];
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self touchesEnded:touches withEvent:event];
}

- (void)drawRect:(CGRect)rect
{
//    CGContextRef context = UIGraphicsGetCurrentContext();
//    
//    // clear context
//    CGContextClearRect(context, self.bounds);
//
//    // draw stored image
//    [self.storedImage drawInRect:rect];
//
//    // set color of path and shadow/glow
//    CGContextSetStrokeColorWithColor(context, [UIColor whiteColor].CGColor);
//    CGContextSetShadowWithColor(context, CGSizeMake(0, 0), 5.0, [UIColor whiteColor].CGColor);
//    
//    // put path on
//    CGContextAddPath(context, [[self.paths lastObject] CGPath]);
//    CGContextSetLineWidth(context,  1);
//    CGContextStrokePath(context);
}

- (void)drawBitmap
{
    UIGraphicsBeginImageContextWithOptions(self.viewSize, NO, 0.0);
    [self.storedImage drawAtPoint:CGPointZero];
    [self.layer renderInContext:UIGraphicsGetCurrentContext()];
    self.storedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
}

- (UIBezierPath *)createBezier
{
    
    float x = ([self.points[2] CGPointValue].x + [self.points[4] CGPointValue].x)/2.0;
    float y = ([self.points[2] CGPointValue].y + [self.points[4] CGPointValue].y)/2.0;
    self.points[3] = [NSValue valueWithCGPoint:CGPointMake(x, y)];
    
    UIBezierPath *pathSegment = [UIBezierPath bezierPath];
    [[self.paths lastObject] moveToPoint:[self.points[0] CGPointValue]];
    [pathSegment moveToPoint:[self.points[0] CGPointValue]];
    
    [[self.paths lastObject] addCurveToPoint:[self.points[3] CGPointValue]
            controlPoint1:[self.points[1] CGPointValue]
            controlPoint2:[self.points[2] CGPointValue]];
    [pathSegment addCurveToPoint:[self.points[3] CGPointValue]
                   controlPoint1:[self.points[1] CGPointValue]
                   controlPoint2:[self.points[2] CGPointValue]];
    
    self.points[0] = self.points[3];
    self.points[1] = self.points[4];
    self.index = 1;
    
    [self setNeedsDisplay];
    return pathSegment;
    
}

@end
