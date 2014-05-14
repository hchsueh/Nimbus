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
@property (strong, nonatomic) SKEmitterNode *fire;

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
        self.fire = nil;
    }
    return self;
    
}

-(void) installFireWithTargetNode: (SKNode *) node position: (CGPoint) position boss:(BOOL)boss
{
    if(!boss){
        NSString *firePath = [[NSBundle mainBundle] pathForResource:@"Fire" ofType:@"sks"];
        self.fire = [NSKeyedUnarchiver unarchiveObjectWithFile:firePath];
        self.fire.targetNode = node;
    //    self.fire.particlePosition = position;
        self.fire.particlePosition = CGPointMake(2.0,-65.0);
        self.fire.zPosition = -1.0;
    //    NSLog(@"fire position (%f, %f)", fire.particlePosition.x, fire.particlePosition.y);
        [self addChild: self.fire];
        
        SKSpriteNode *image = [SKSpriteNode spriteNodeWithImageNamed:@"smallFireMonster.png"];
        image.zPosition = 1.0;
        image.name = @"fire";
        [self addChild: image];
    }
    else{
        NSString *firePath = [[NSBundle mainBundle] pathForResource:@"FireBOSS" ofType:@"sks"];
        self.fire = [NSKeyedUnarchiver unarchiveObjectWithFile:firePath];
        self.fire.targetNode = node;
        //    self.fire.particlePosition = position;
        self.fire.particlePosition = CGPointMake(20.0,-55.0);
        self.fire.zPosition = -1.0;
        //    NSLog(@"fire position (%f, %f)", fire.particlePosition.x, fire.particlePosition.y);
        [self addChild: self.fire];
        
        SKSpriteNode *image = [SKSpriteNode spriteNodeWithImageNamed:@"smallFireMonster.png"];
        image.zPosition = 1.0;
        image.name = @"fire";
        image.size = CGSizeMake(image.size.width*2, image.size.height*2);
        [self addChild: image];
    }
    
    
//    self.texture = [SKTexture textureWithImage:[UIImage imageNamed:@"smallFireMonster.png"]];
}

-(void) setAsBoss
{
    [self.fire setParticleBirthRate:1000];
    [self.fire setParticlePositionRange:CGVectorMake(200, 260)];
    [self.fire setParticleColorSequence:nil];
    [self.fire setParticleColorBlendFactor:1.0];
    [self.fire setParticleColor:[UIColor colorWithRed:177/255 green:3/255 blue:252/255 alpha:1]];
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
    [self runAction: [SKAction sequence:@[[SKAction waitForDuration:2.0f],
                                          [SKAction removeFromParent]
                                          ]
                      ]
     ];
    [self runAction: [SKAction fadeOutWithDuration:2.0f]];
    [self.fire setParticleBirthRate: 10];
}


@end
