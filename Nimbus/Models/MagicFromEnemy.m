//
//  MagicFromEnemy.m
//  Nimbus
//
//  Created by Apple on 2014/5/14.
//
//

#import "MagicFromEnemy.h"

@implementation MagicFromEnemy

-(id) initAtPosition: (CGPoint) position
{
    self = [super init];
    if(self)
    {
        self.hasHit = NO;
        self.position = position;
    }
    return self;
}

-(void) addParticleWithTargetNode: (SKNode *) node
{
    NSString *particlePath = [[NSBundle mainBundle] pathForResource:@"smallFireBall" ofType:@"sks"];
    SKEmitterNode *particle = [NSKeyedUnarchiver unarchiveObjectWithFile:particlePath];
    particle.targetNode = node;
    particle.particlePosition = CGPointMake(0.0,0.0);
    //        particle.zPosition = -1.0; // add heart within the body !
    [self addChild: particle];
}

-(void) runAnimationHitTarget
{
    [self runAction: [SKAction sequence:@[[SKAction rotateByAngle:2*M_PI duration:0.5f],
                                          [SKAction removeFromParent]
                                          ]]];
    [self runAction: [SKAction scaleBy:0.1 duration:0.5f]];
}


@end
