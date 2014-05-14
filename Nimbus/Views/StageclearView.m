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
        
        [UIView animateWithDuration:1.7
                              delay:0
                            options: UIViewAnimationOptionCurveEaseInOut | UIViewAnimationOptionAutoreverse | UIViewAnimationOptionRepeat
                         animations:^{
                             breathView.alpha = 0.0;
                         }
                         completion:nil];
        
            }
    return self;
}

-(void) updateLabel:(int)rank
{
    NSLog(@"updateLabel rank: %d" ,rank);

    UILabel *rankLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMidX(self.frame)-100, CGRectGetMidY(self.frame)-100, 200, 200)];
    rankLabel.text = [NSString stringWithFormat:@"rank: %d", rank];
    rankLabel.textColor = [UIColor whiteColor];
    rankLabel.textAlignment = NSTextAlignmentCenter;
    
    [self addSubview:rankLabel];
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
