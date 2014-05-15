//
//  IntroductionView.m
//  Nimbus
//
//  Created by Apple on 2014/5/11.
//
//

#import "IntroductionView.h"
#import <SpriteKit/SpriteKit.h>

@implementation IntroductionView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor blackColor];
        
        UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMidX(self.frame)-250, CGRectGetMidY(self.frame)-250, 500, 500)];
        title.font = [UIFont fontWithName:@"Baskerville-SemiBoldItalic" size:16];
        title.numberOfLines = 0;
        title.text = @"本來沒空打字辣....但都日出了\n就打下去吧\n\n\n\n\n\n這塊大地已被聖光籠罩了千年\n但是有一天\n那令人恐懼的一天\n天火降臨大地\n燃盡一切的一切\n兇殘的火靈到處肆虐\n\n\nNimbus\n作為一個小不點幽靈\n不知自己從何而來 欲去何方\n不過他發現自己擁有神奇的魔法召喚天賦......\n於是  為了這片曾經美好的大地\n就算是蚍蜉撼樹 也在所不惜...\n\n通宵後寫出的文案有夠鳥";
        title.textColor = [UIColor whiteColor];
        title.textAlignment = NSTextAlignmentCenter;
        
        CGSize labelSize = [title.text sizeWithFont: title.font
                                  constrainedToSize:title.frame.size
                                      lineBreakMode:title.lineBreakMode];
        title.frame = CGRectMake(title.frame.origin.x, title.frame.origin.y, title.frame.size.width, labelSize.height);
        
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
