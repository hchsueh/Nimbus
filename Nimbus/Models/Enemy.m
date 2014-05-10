//
//  Enemy.m
//  Nimbus
//
//  Created by Apple on 2014/5/10.
//
//

#import "Enemy.h"

@interface Enemy()

@property (strong, nonatomic) NSArray *idleFrames;

@end


@implementation Enemy

- (id)initWithTexture: (SKTexture *) texture AtPosition:(CGPoint)position
{
    self = [super initWithTexture: texture];
    
    if(self){
        [self setupIdleFrames];
        self.position = position;
    }
    return self;
    
}

-(void) setupIdleFrames
{
    SKTextureAtlas *enemyAtlas = [SKTextureAtlas atlasNamed:@"BabyGoldenSnitch"];
    NSMutableArray *frames = [NSMutableArray array];
    for(int i=1; i<=enemyAtlas.textureNames.count; i++){
        NSString *name = [NSString stringWithFormat:@"BabyGoldenSnitch_frame%d",i];
        SKTexture *temp = [enemyAtlas textureNamed:name];
        [frames addObject:temp];
    }
    self.idleFrames = frames;
    [self runAction: [SKAction scaleBy:0.5 duration:0.5f]];
}

- (void) runAnimationIdle
{
    [self runAction: [SKAction repeatActionForever:[SKAction sequence:
                                                    @[[SKAction moveByX:0 y:10 duration:0.2f],
                                                      [SKAction moveByX:0 y:-20 duration:0.2f],
                                                      [SKAction moveByX:0 y:10 duration:0.2f]
                                                      ]
                                                    ]
                      ]];
    
    [self runAction:[SKAction repeatActionForever:
                     [SKAction animateWithTextures:self.idleFrames
                                      timePerFrame:0.1f
                                            resize:NO
                                           restore:YES]] withKey:@"enemyIdle"];
}

-(void) runAnimationInjured
{
    [self runAction: [SKAction rotateByAngle:2*M_PI duration:0.5f]];
}

@end
