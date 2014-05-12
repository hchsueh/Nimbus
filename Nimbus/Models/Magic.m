//
//  Magic.m
//  Nimbus
//
//  Created by Apple on 2014/5/10.
//
//

#import "Magic.h"

@interface Magic()

@property (strong, nonatomic) NSArray *idleFrames;
@property (strong, nonatomic) SKEmitterNode *heart;

@end


@implementation Magic

- (id)initWithTexture: (SKTexture *) texture AtPosition:(CGPoint)position
{
    self = [super initWithTexture: texture];
    
    if(self){
        self.hasHit = NO;
        self.position = position;
        [self setupIdleFrames];
    }
    return self;
    
}

-(void) setupIdleFrames
{
    SKTextureAtlas *magicAtlas = [SKTextureAtlas atlasNamed:@"BabyGoldenSnitch"];
    NSMutableArray *frames = [NSMutableArray array];
    for(int i=1; i<=magicAtlas.textureNames.count; i++){
        NSString *name = [NSString stringWithFormat:@"BabyGoldenSnitch_frame%d",i];
        SKTexture *temp = [magicAtlas textureNamed:name];
        [frames addObject:temp];
    }
    self.idleFrames = frames;    
    [self runAction: [SKAction scaleBy:0.4 duration:0.1f]];
}

-(void) installHeartWithTargetNode: (SKNode *) node
{    
    NSString *particlePath = [[NSBundle mainBundle] pathForResource:@"BabyGoldenSnitchHeart" ofType:@"sks"];
    self.heart = [NSKeyedUnarchiver unarchiveObjectWithFile:particlePath];
    self.heart.targetNode = node;
    self.heart.position = CGPointMake(self.frame.origin.x, self.frame.origin.y + 100);
    [self addChild: self.heart];
}

- (void) runAnimationIdle
{
    [self runAction:[SKAction repeatActionForever:
                     [SKAction animateWithTextures:self.idleFrames
                                      timePerFrame:0.1f
                                            resize:NO
                                           restore:YES]] withKey:@"magicIdle"];
}

-(void) runAnimationHitTarget
{
    [self runAction: [SKAction sequence:@[[SKAction rotateByAngle:2*M_PI duration:0.5f],
                                          [SKAction removeFromParent]
                                          ]]];
    [self runAction: [SKAction scaleBy:0.1 duration:0.5f]];
}


@end
