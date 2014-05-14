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
        
        UIImageView *bgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"StageClear"]];
        [self addSubview:bgView];
        UIImageView *breathView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"breathe"]];
        [self addSubview:breathView];
        
        [UIView animateWithDuration:2.8
                              delay:0
                            options: UIViewAnimationOptionCurveEaseInOut | UIViewAnimationOptionAutoreverse | UIViewAnimationOptionRepeat
                         animations:^{
                             breathView.alpha = 0.0;
                         }
                         completion:nil];
        
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
