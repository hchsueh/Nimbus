//
//  LobbyView.m
//  Nimbus
//
//  Created by Apple on 2014/5/11.
//
//

#import "LobbyView.h"

@implementation LobbyView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
       
        

    }
    return self;
}

- (id)initWithStage:(int)stage
{
    self = [super init];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor blackColor];
        if(!stage) stage = 1;
        UIImageView *bgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"map%d", stage]]];
        NSLog(@"%d", stage);
        [self addSubview:bgView];
        
        
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
