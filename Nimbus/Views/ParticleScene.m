//
//  MyScene.m
//  painter_test
//
//  Created by Apple on 2014/3/30.
//  Copyright (c) 2014年 Hsueh. All rights reserved.
//

#import "ParticleScene.h"

@interface ParticleScene()

@property (strong, nonatomic) SKEmitterNode *particle;
@property (strong, nonatomic) SKEmitterNode *fire;
@property (strong, nonatomic) NSArray *magicFrames;
@property (strong, nonatomic) SKSpriteNode *magic;

@end

@implementation ParticleScene

-(id)initWithSize:(CGSize)size {    
    if (self = [super initWithSize:size]) {
        
        self.backgroundColor = [SKColor colorWithRed:0 green:0 blue:0 alpha:1.0];
        
//        SKTextureAtlas *BabyGoldenSnitchAtlas = [SKTextureAtlas atlasNamed:@"BabyGoldenSnitch"];
//        NSMutableArray *frames = [NSMutableArray array];
//        for(int i=1; i<=BabyGoldenSnitchAtlas.textureNames.count; i++){
//            NSString *name = [NSString stringWithFormat:@"BabyGoldenSnitch_frame%d",i];
//            SKTexture *temp = [BabyGoldenSnitchAtlas textureNamed:name];
//            [frames addObject:temp];
//        }
//        self.magicFrames = frames;
//        SKTexture *temp = self.magicFrames[0];
//        self.magic = [SKSpriteNode spriteNodeWithTexture:temp];
//        self.magic.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame));
//        //        self.magic.hidden = YES;
//        [self addChild: self.magic];
//        [self startMagicAnimation];

    }
    return self;
}

-(void)followPath:(UIBezierPath *)path withTimeInterval:(NSTimeInterval)interval{


    [path applyTransform:CGAffineTransformMakeScale(1.0, -1.0)];
    [path applyTransform:CGAffineTransformMakeTranslation(0, self.frame.size.height)];
    SKAction *track = [SKAction followPath:path.CGPath asOffset:NO orientToPath:YES duration:interval];
    [self.particle runAction:track];
    [self.fire runAction:track];
    NSLog(@"%f", interval);
    
}

-(void)pauseMoving{
    
//    [self removeAllChildren];
    [self.particle removeFromParent];
    self.fire.particleBirthRate = 0;
    
}

-(void)endMoving{
    
    [self removeAllChildren];
    
}

-(void)beginMoving:(CGPoint)position{

    NSString *particlePath = [[NSBundle mainBundle] pathForResource:@"Spark" ofType:@"sks"];
    NSString *firePath = [[NSBundle mainBundle] pathForResource:@"Path" ofType:@"sks"];
    self.particle = [NSKeyedUnarchiver unarchiveObjectWithFile:particlePath];
    self.fire = [NSKeyedUnarchiver unarchiveObjectWithFile:firePath];
    self.particle.targetNode = self;
    self.fire.targetNode = self;
    self.particle.position = position;
    self.fire.position = position;
    [self addChild:self.fire];
    [self addChild:self.particle];

}

#pragma mark - Magic Animation

-(void) displayAnimation{
    NSLog(@"display animation!");
    
    // initialize magic animation
    SKTextureAtlas *BabyGoldenSnitchAtlas = [SKTextureAtlas atlasNamed:@"BabyGoldenSnitch"];
    NSMutableArray *frames = [NSMutableArray array];
    for(int i=1; i<=BabyGoldenSnitchAtlas.textureNames.count; i++){
        NSString *name = [NSString stringWithFormat:@"BabyGoldenSnitch_frame%d",i];
        SKTexture *temp = [BabyGoldenSnitchAtlas textureNamed:name];
        [frames addObject:temp];
    }
    self.magicFrames = frames;
    SKTexture *temp = self.magicFrames[0];
    self.magic = [SKSpriteNode spriteNodeWithTexture:temp];
    self.magic.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame));
    [self addChild: self.magic];
    [self startMagicAnimation];
}

-(void) startMagicAnimation{
    [self.magic runAction:[SKAction repeatActionForever:
                          [SKAction animateWithTextures:self.magicFrames
                                           timePerFrame:0.1f
                                                 resize:NO
                                                restore:YES]] withKey:@"thisIsMagic"];
    return;
}

//-(void)clearAll{
//
//    self.particle.particleAlpha = 0;
//    self.particle.particleAlphaRange = 0;
//    self.fire.particleAlpha = 0;
//    self.fire.particleAlphaRange = 0;
//    
//}

#pragma mark - Default Settings

-(void)update:(CFTimeInterval)currentTime {
    /* Called before each frame is rendered */
}

@end
