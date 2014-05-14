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
        self.position = position;
        self.playerState = PlayerAnimationStateIdle;
        self.health = 15;
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
                      ]
            withKey:@"idle1"
     ];
    
    [self runAction: [SKAction repeatActionForever:[SKAction sequence:
                                                    @[[SKAction fadeAlphaTo:0.6 duration:0.4f],
                                                      [SKAction fadeAlphaTo:1 duration:0.4f],
                                                      [SKAction waitForDuration:2.0f withRange:0.9f]]
                                                    ]
                      ]
            withKey:@"idle2"
     ];
    
//    [self runAction:[SKAction repeatActionForever:
//                     [SKAction animateWithTextures:self.playerIdleFrames
//                                      timePerFrame:0.1f
//                                            resize:NO
//                                           restore:YES]] withKey:@"playerIdle"];
}

- (void) runAnimationInjured
{
    [self runAction: [SKAction rotateByAngle:2*M_PI duration:0.4f]];
}

- (void) runAnimationDead
{
    [self removeActionForKey:@"idle1"];
    [self removeActionForKey:@"idle2"];
    [self runAction: [SKAction sequence:@[[SKAction waitForDuration:1.0f],
                                         [SKAction removeFromParent]
                                         ]
                     ]
    ];
    [self runAction: [SKAction fadeOutWithDuration:1.0f]];
    [self runAction: [SKAction scaleBy:0.1 duration:1.0f]];
}

-(void) animationDidComplete: (PlayerAnimationState) state
{
    //..
}

@end
