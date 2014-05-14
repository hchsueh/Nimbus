//
//  StageclearView.m
//  Nimbus
//
//  Created by Apple on 2014/5/14.
//
//

#import "StageclearView.h"

@implementation StageclearView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor blackColor];
        
        UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMidX(self.frame)-100, CGRectGetMidY(self.frame)-100, 200, 200)];
        title.font = [UIFont fontWithName:@"Baskerville-SemiBoldItalic" size:30];
        title.text = @"~ Stage Cleared ~";
        title.textColor = [UIColor whiteColor];
        title.textAlignment = NSTextAlignmentCenter;
        
        [self addSubview:title];
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
