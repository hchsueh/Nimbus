//
//  GameOverView.m
//  Nimbus
//
//  Created by Apple on 2014/5/14.
//
//

#import "GameOverView.h"

@implementation GameOverView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor blackColor];
        
        UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMidX(self.frame)-200, CGRectGetMidY(self.frame)-200, 400, 400)];
        title.font = [UIFont fontWithName:@"Baskerville-SemiBoldItalic" size:30];
        title.text = @"~ GAME OVER Orz ~";
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
