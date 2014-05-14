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
//    self = [super initWithTexture: texture];
    self = [super init];
    if(self){
//        [self setupAnimation];
        self.position = position;
        self.health = 10;
    }
    return self;
    
}

-(void) installFireWithTargetNode: (SKNode *) node position: (CGPoint) position;
{
    NSString *firePath = [[NSBundle mainBundle] pathForResource:@"Fire" ofType:@"sks"];
    SKEmitterNode *fire = [NSKeyedUnarchiver unarchiveObjectWithFile:firePath];
    fire.targetNode = node;
//    fire.particlePosition = position;
    fire.particlePosition = CGPointMake(2.0,-65.0);
    fire.zPosition = -1.0;
//    NSLog(@"fire position (%f, %f)", fire.particlePosition.x, fire.particlePosition.y);
    [self addChild: fire];
    
    SKSpriteNode *image = [SKSpriteNode spriteNodeWithImageNamed:@"smallFireMonster.png"];
    image.zPosition = 1.0;
    [self addChild: image];
    
//    self.texture = [SKTexture textureWithImage:[UIImage imageNamed:@"smallFireMonster.png"]];
}

- (void) runAnimationIdle
{
    [self runAction: [SKAction repeatActionForever:[SKAction sequence:
                                                    @[[SKAction moveByX:0 y:2 duration:0.2f],
                                                      [SKAction moveByX:0 y:-4 duration:0.2f],
                                                      [SKAction moveByX:0 y:2 duration:0.2f]
                                                      ]
                                                    ]
                      ]];
    
//    [self runAction:[SKAction repeatActionForever:
//                     [SKAction animateWithTextures:self.idleFrames
//                                      timePerFrame:0.1f
//                                            resize:NO
//                                           restore:YES]] withKey:@"enemyIdle"];
}

-(void) runAnimationInjured
{
    [self runAction: [SKAction rotateByAngle:2*M_PI duration:0.4f]];
}

- (void) runAnimationDead
{
    [self runAction: [SKAction sequence:@[[SKAction rotateByAngle:2*M_PI duration:2.0f],
                                          [SKAction removeFromParent]
                                          ]
                      ]
     ];
    [self runAction: [SKAction fadeOutWithDuration:2.0f]];
    [self runAction: [SKAction scaleBy:0.1 duration:2.0f]];
}


@end
