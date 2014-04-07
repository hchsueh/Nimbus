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

@end

@implementation ParticleScene

-(id)initWithSize:(CGSize)size {    
    if (self = [super initWithSize:size]) {
        
//        self.backgroundColor = [SKColor colorWithRed:0 green:0 blue:0 alpha:1.0];
        self.backgroundColor = [SKColor colorWithRed:0.3 green:0.3 blue:0.8 alpha:1.0];
        
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

-(void)endMoving{

//    self.particle.particleAlpha = 0;
//    self.fire.particleAlpha = 0;


}

-(void)beginMoving:(CGPoint)position{

    NSString *particlePath = [[NSBundle mainBundle] pathForResource:@"Particle" ofType:@"sks"];
    NSString *firePath = [[NSBundle mainBundle] pathForResource:@"Fire" ofType:@"sks"];
    self.particle = [NSKeyedUnarchiver unarchiveObjectWithFile:particlePath];
    self.fire = [NSKeyedUnarchiver unarchiveObjectWithFile:firePath];
    self.particle.targetNode = self;
    self.fire.targetNode = self;
    self.particle.position = position;
    self.fire.position = position;
    [self addChild:self.particle];
    [self addChild:self.fire];

}

//-(void)clearAll{
//
//    self.particle.particleAlpha = 0;
//    self.particle.particleAlphaRange = 0;
//    self.fire.particleAlpha = 0;
//    self.fire.particleAlphaRange = 0;
//    
//}

-(void)update:(CFTimeInterval)currentTime {
    /* Called before each frame is rendered */
}

@end
