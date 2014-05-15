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
@property (strong, nonatomic) NSMutableArray *healthPoints;
@property (strong, nonatomic) NSTimer *rachaelTimer;
@property (strong, nonatomic) SKSpriteNode *rachael;
@property (nonatomic) BOOL isRachael;

@property (strong, nonatomic) SKLabelNode *label1;
@property (strong, nonatomic) SKLabelNode *label2;


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
        self.healthPoints = [NSMutableArray array];
        self.rachaelTimer = nil;
        self.rachael = nil;
        self.isRachael = NO;
    
        self.label1 = [SKLabelNode labelNodeWithFontNamed:@"TimesNewRoman"];
        self.label1.text = @"";
        self.label1.fontSize = 20;
        self.label1.fontColor = [UIColor whiteColor];
        self.label1.position = CGPointMake(-50, 80);
        self.label1.zPosition = 10000;
        self.label1.zRotation = M_PI/20;
        [self addChild:self.label1];
        
        self.label2 = [SKLabelNode labelNodeWithFontNamed:@"TimesNewRoman"];
        self.label2.text = @"";
        self.label2.fontSize = 20;
        self.label2.fontColor = [UIColor whiteColor];
        self.label2.position = CGPointMake(50, 90);
        self.label2.zPosition = 10000;
        self.label2.zRotation = -M_PI/20;
        self.label2.color = [UIColor clearColor];
        [self addChild:self.label2];
    }
    return self;
}

-(void) runAnimationIdle
{
    [self runAction: [SKAction repeatActionForever:[SKAction sequence:
                                                    @[[SKAction moveByX:0 y:10 duration:0.4f],
                                                      [SKAction moveByX:0 y:-20 duration:0.4f],
                                                      [SKAction moveByX:0 y:10 duration:0.4f]
                                                      ]
                                                    ]
                      ]
            withKey:@"idle1"
     ];
    
    [self runAction: [SKAction repeatActionForever:[SKAction sequence:
                                                    @[[SKAction fadeAlphaTo:0.6 duration:0.4f],
                                                      [SKAction fadeAlphaTo:1 duration:0.4f],
                                                      [SKAction waitForDuration:2.0f withRange:0.4f]]
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
    if(self.isRachael) {
        if(self.health == 10){
            self.label1.text = @"我好雷...";
        }
        else if(self.health == 5){
            self.label2.text = @"我超雷...";
        }
    }
    else {
        [self runAction: [SKAction rotateByAngle:2*M_PI duration:0.4f]];
    }
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

-(void) toGODDAMNRachael
{
    self.rachael = [[SKSpriteNode alloc] initWithImageNamed:@"Rachael.png"];
    self.rachael.size = CGSizeMake(self.rachael.size.width/3, self.rachael.size.height/3);
    [self removeActionForKey:@"idle1"];
    [self removeActionForKey:@"idle2"];
    [self addChild:self.rachael];
    self.isRachael = YES;
    self.rachaelTimer = [NSTimer scheduledTimerWithTimeInterval:20.0 target:self selector:@selector(byebyeRachael) userInfo:nil repeats:NO];
}

-(void) byebyeRachael
{
    [self.rachael removeFromParent];
    self.rachael = nil;
    self.isRachael = NO;
    self.label1 = nil;
    self.label2 = nil;
}

@end
