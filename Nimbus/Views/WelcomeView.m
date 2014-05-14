//
//  WelcomeView.m
//  Nimbus
//
//  Created by Apple on 2014/5/11.
//
//

#import "WelcomeView.h"
#import <SpriteKit/SpriteKit.h>

@implementation WelcomeView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    
        self.backgroundColor = [UIColor blackColor];
        
//        UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMidX(self.frame)-100, CGRectGetMidY(self.frame)-100, 200, 200)];
//        title.font = [UIFont fontWithName:@"Baskerville-SemiBoldItalic" size:30];
//        title.text = @"Nimbus";
//        title.textColor = [UIColor whiteColor];
//        title.textAlignment = NSTextAlignmentCenter;
        
//        [self addSubview:title];
        
        UIImageView *bgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Welcome"]];
        [self addSubview:bgView];
        UIImageView *breathView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"breathe"]];
        NSLog(@"Welcome view");
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
