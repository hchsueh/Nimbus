//
//  Player.m
//  Nimbus
//
//  Created by Apple on 2014/5/10.
//
//

#import "Player.h"

@interface Player()

@property (strong, nonatomic) NSArray *playerIdleFrames;

@end

@implementation Player

#pragma mark - Initialization
- (id)initWithTexture: (SKTexture *) texture AtPosition:(CGPoint)position {
    self = [super initWithTexture: texture];
    
    if(self){
        SKTextureAtlas *PlayerAtlas = [SKTextureAtlas atlasNamed:@"BabyGoldenSnitch"];
        NSMutableArray *frames = [NSMutableArray array];
        for(int i=1; i<=PlayerAtlas.textureNames.count; i++){
            NSString *name = [NSString stringWithFormat:@"BabyGoldenSnitch_frame%d",i];
            SKTexture *temp = [PlayerAtlas textureNamed:name];
            [frames addObject:temp];
        }
        self.playerIdleFrames = frames;
        NSLog(@"playerIdleFrames count: %d", self.playerIdleFrames.count);
        self.position = position;
        NSLog(@"player initAtPosition");
        self.playerState = PlayerAnimationStateIdle;
    }
    return self;
}

-(void) runAnimationIdle
{
    [self runAction: [SKAction repeatActionForever:[SKAction sequence:
                                                    @[[SKAction moveByX:0 y:10 duration:0.2f],
                                                      [SKAction moveByX:0 y:-20 duration:0.2f],
                                                      [SKAction moveByX:0 y:10 duration:0.2f]
                                                      ]
                                                    ]
                      ]];
    
    [self runAction:[SKAction repeatActionForever:
                     [SKAction animateWithTextures:self.playerIdleFrames
                                      timePerFrame:0.1f
                                            resize:NO
                                           restore:YES]] withKey:@"playerIdle"];
}

-(void) animationDidComplete: (PlayerAnimationState) state
{
    //..
}

@end
