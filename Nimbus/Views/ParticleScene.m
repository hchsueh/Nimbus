//
//  MyScene.m
//  painter_test
//
//  Created by Apple on 2014/3/30.
//  Copyright (c) 2014年 Hsueh. All rights reserved.
//

#import "ParticleScene.h"
#import "Player.h"
#import "Enemy.h"
#import "Magic.h"

static const uint32_t magicCategory = 0x1 << 0;
static const uint32_t enemyCategory = 0x1 << 1;

@interface ParticleScene() <SKPhysicsContactDelegate>

@property (strong, nonatomic) SKEmitterNode *particle;
@property (strong, nonatomic) SKEmitterNode *fire;
@property (strong ,nonatomic) NSMutableArray *particleArray;
@property (strong ,nonatomic) NSMutableArray *fireArray;

@property (strong, nonatomic) NSArray *magicFrames;
@property (strong, nonatomic) Magic *magic;

@property (nonatomic, strong) PBParallaxScrolling * parallaxBackground;

@property (nonatomic, strong) Player *player;
@property (nonatomic, strong) Enemy *enemy;
@end

@implementation ParticleScene

-(id)initWithSize:(CGSize)size {    
    if (self = [super initWithSize:size]) {
        
        self.backgroundColor = [SKColor colorWithRed:0 green:0 blue:0 alpha:1.0];
        
        self.physicsWorld.gravity = CGVectorMake(0, 0);
        self.physicsWorld.contactDelegate = self; // not working ?????
        
        self.physicsBody = [SKPhysicsBody bodyWithEdgeLoopFromRect:self.frame];
        self.scaleMode = SKSceneScaleModeAspectFit;
        NSArray * imageNames = @[@"pForegroundHorizontal",
                                 @"pMiddleHorizontal",
                                 @"pBackgroundHorizontal"];
        self.particleArray = [NSMutableArray array];
        self.fireArray = [NSMutableArray array];
        
        PBParallaxScrolling * parallax = [[PBParallaxScrolling alloc] initWithBackgrounds:imageNames size:size direction:kPBParallaxBackgroundDirectionLeft fastestSpeed:kPBParallaxBackgroundDefaultSpeed*2 andSpeedDecrease:kPBParallaxBackgroundDefaultSpeedDifferential*2];
        
        self.parallaxBackground = parallax;
        [self addChild:parallax];
        
        
        SKTextureAtlas *playerAtlas = [SKTextureAtlas atlasNamed:@"BabyGoldenSnitch"];
        NSString *name1 = [NSString stringWithFormat:@"BabyGoldenSnitch_frame%d",1];
        SKTexture *temp1 = [playerAtlas textureNamed:name1];
        self.player = [[Player alloc] initWithTexture:temp1 AtPosition:CGPointMake(150,400)];
        [self.player runAnimationIdle];
        [self addChild:self.player];
        
        SKTextureAtlas *enemyAtlas = [SKTextureAtlas atlasNamed:@"BabyGoldenSnitch"];
        NSString *name2 = [NSString stringWithFormat:@"BabyGoldenSnitch_frame%d",1];
        SKTexture *temp2 = [enemyAtlas textureNamed:name2];
        self.enemy = [[Enemy alloc] initWithTexture:temp2 AtPosition:CGPointMake(900,400)];
        self.enemy.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:self.enemy.size];
        self.enemy.physicsBody.dynamic = YES;
        self.enemy.physicsBody.categoryBitMask = enemyCategory;
        self.enemy.physicsBody.contactTestBitMask = magicCategory;
        self.enemy.physicsBody.collisionBitMask = 0; // ?
        [self.enemy runAnimationIdle];
        [self addChild:self.enemy];
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
    
//    [self removeAllChildren];
    [self.particle removeFromParent];
    [self.fire removeFromParent];
    
    for( id obj in self.particleArray ){
        [obj removeFromParent];
    }
    for( id obj in self.fireArray ){
        [obj removeFromParent];
    }
    
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
//    [self addChild:self.fire];
//    [self addChild:self.particle];
    
    [self.particleArray addObject:self.particle];
    [self.fireArray addObject:self.fire];
    [self addChild: [self.particleArray lastObject]];
    [self addChild: [self.fireArray lastObject]];

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
    
    NSLog(@"player position: (%f,%f)", self.player.position.x, self.player.position.y);
    self.magic = [[Magic alloc] initWithTexture:temp AtPosition:self.player.position];
    
    self.magic.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:self.magic.size.width/2];
    self.magic.physicsBody.dynamic = YES;
    self.magic.physicsBody.categoryBitMask = magicCategory;
    self.magic.physicsBody.contactTestBitMask = enemyCategory;
    self.magic.physicsBody.collisionBitMask = 0; // ?
    self.magic.physicsBody.usesPreciseCollisionDetection = YES; // magic may be moving fast !
    [self addChild: self.magic];
    [self.magic installHeartWithTargetNode:self];
    [self.magic runAnimationIdle];
}

//-(void)clearAll{
//
//    self.particle.particleAlpha = 0;
//    self.particle.particleAlphaRange = 0;
//    self.fire.particleAlpha = 0;
//    self.fire.particleAlphaRange = 0;
//    
//}

#pragma mark - SK Nodes Collision Handling
-(void) didBeginContact:(SKPhysicsContact *)contact
{
    SKPhysicsBody *firstBody, *secondBody;
    
    if (contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask)
    {
        firstBody = contact.bodyA;
        secondBody = contact.bodyB;
    }
    else
    {
        firstBody = contact.bodyB;
        secondBody = contact.bodyA;
    }
    
    if ((firstBody.categoryBitMask & magicCategory) != 0 &&
        (secondBody.categoryBitMask & enemyCategory) != 0)
    {
        // magic collides with enemy!! Yay!!!
        NSLog(@"smacked the enemy's ass!");
        self.magic.hasHit = YES;
        [self.magic runAnimationHitTarget];
        [self.enemy runAnimationInjured];
    }
    
}

#pragma mark - Default Settings

-(void)update:(CFTimeInterval)currentTime {
    /* Called before each frame is rendered */
    [self.parallaxBackground update:currentTime];
    
    int diff_x = self.enemy.position.x - self.magic.position.x;
    int diff_y = self.enemy.position.y - self.magic.position.y;
    int dist_y = (int) diff_y/diff_x;
    
    if(self.magic.position.x > self.frame.size.width || self.magic.position.y > self.frame.size.height){
        NSLog(@"magic leaves the screen!");
        [self.magic removeFromParent];
        self.magic = nil;
    }
    else if(self.magic.hasHit == NO){
        [self.magic runAction: [SKAction moveByX:40 y:dist_y*40 duration:0.1f]];
    }
}

@end
