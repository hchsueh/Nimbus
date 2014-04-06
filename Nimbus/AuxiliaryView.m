//
//  AuxiliaryView.m
//  Nimbus
//
//  Created by Apple on 2014/4/6.
//
//

#import "AuxiliaryView.h"

@interface AuxiliaryView()

@property (nonatomic) CGRect AuxiliaryRectBounds;

@end

@implementation AuxiliaryView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor clearColor];
        self.opaque = NO;
        self.AuxiliaryRectBounds = CGRectMake(20, 20, 200, 200);
    }
    return self;
}

-(void) drawAuxiliaryRectWithBound:(CGRect) bound
{
    self.AuxiliaryRectBounds = bound;
    [self setNeedsDisplay];
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    NSLog(@"drawAuxRect! h: %f, w:%f, origin(%f, %f)", self.AuxiliaryRectBounds.size.height, self.AuxiliaryRectBounds.size.width, self.AuxiliaryRectBounds.origin.x, self.AuxiliaryRectBounds.origin.y);
    CGRect rectangle = self.AuxiliaryRectBounds;
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [UIColor clearColor].CGColor);   //this is the transparent color
    CGContextSetRGBStrokeColor(context, 0.0, 0.0, 0.0, 0.5);
    CGContextFillRect(context, rectangle);
    CGContextStrokeRect(context, rectangle);
}


@end
