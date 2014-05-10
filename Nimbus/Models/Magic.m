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

@end


@implementation Magic

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
    SKTextureAtlas *magicAtlas = [SKTextureAtlas atlasNamed:@"BabyGoldenSnitch"];
    NSMutableArray *frames = [NSMutableArray array];
    for(int i=1; i<=magicAtlas.textureNames.count; i++){
        NSString *name = [NSString stringWithFormat:@"BabyGoldenSnitch_frame%d",i];
        SKTexture *temp = [magicAtlas textureNamed:name];
        [frames addObject:temp];
    }
    self.idleFrames = frames;    
    [self runAction: [SKAction scaleBy:0.2 duration:0.1f]];
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
    [self runAction: [SKAction sequence:@[[SKAction rotateByAngle:4*M_PI duration:0.5f],
                                          [SKAction removeFromParent]
                                          ]]];
}


@end
