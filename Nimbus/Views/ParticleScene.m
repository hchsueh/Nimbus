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

#define MAX_IMG_NUM 5
#define SLOWING_THRESHOLD 100

static const uint32_t magicCategory = 0x1 << 0;
static const uint32_t enemyCategory = 0x1 << 1;

@interface ParticleScene() <SKPhysicsContactDelegate>

@property (strong, nonatomic) SKEmitterNode *particle;
@property (strong, nonatomic) SKEmitterNode *fire;
@property (strong ,nonatomic) NSMutableArray *particleArray;
@property (strong ,nonatomic) NSMutableArray *fireArray;

@property (strong, nonatomic) NSArray *magicFrames;
@property (strong, nonatomic) Magic *magic;

@property (nonatomic, strong) NSMutableDictionary *backgroundInformation;
@property (nonatomic, strong) NSMutableDictionary *backgroundImages;
@property (nonatomic) float speedFactor;
@property (nonatomic) BOOL isSlowingDown;
@property (nonatomic) BOOL isSpeedingUp;

@property (nonatomic, strong) Player *player;
@property (nonatomic, strong) Enemy *enemy;
@end

@implementation ParticleScene

-(id)initWithSize:(CGSize)size {    
    if (self = [super initWithSize:size]) {
        
        self.backgroundColor = [SKColor colorWithRed:1 green:1 blue:1 alpha:1];
        self.particleArray = [NSMutableArray array];
        self.fireArray = [NSMutableArray array];

        self.physicsWorld.gravity = CGVectorMake(0, 0);
        self.physicsWorld.contactDelegate = self; // not working ?????
        self.physicsBody = [SKPhysicsBody bodyWithEdgeLoopFromRect:self.frame];
        self.scaleMode = SKSceneScaleModeAspectFit;
        
        // background
        self.speedFactor = 1.0f;
        self.isSlowingDown = NO;
        self.isSpeedingUp = NO;
        self.backgroundInformation = [NSMutableDictionary dictionary];
        self.backgroundImages = [NSMutableDictionary dictionary];
        NSString *path = [[NSBundle mainBundle] pathForResource:@"ImageSet" ofType:@"plist"];
        [self setupBackgroundWithImageSet:[NSArray arrayWithContentsOfFile:path]];
        NSLog(@"image set: %@", [NSArray arrayWithContentsOfFile:path]);
        
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

#pragma Background

- (void)setupBackgroundWithImageSet:(NSArray *)imageSet{

    NSLog(@"self size: %@", NSStringFromCGSize(self.size));
    int z = 0;
    for(NSDictionary *imageData in imageSet){
        
        // get image name
        BOOL moving = ![[imageData objectForKey:@"direction"] isEqualToString:@"still"];
        NSString *key = [imageData objectForKey:@"name"];
        if(moving){
            
            for(int i = 1; i <= MAX_IMG_NUM; i++){
            
                NSString *name = [NSString stringWithFormat:@"%@_0%d", key, i];
                SKSpriteNode *node = [[SKSpriteNode alloc] initWithImageNamed:name];
                node.zPosition = -100 - z;
                node.position = CGPointMake(self.size.width*2, self.size.height/2);
                [self addChild:node];
                
                NSMutableArray *arr = [self.backgroundImages objectForKey:key];
                if(arr) [arr addObject:node];
                else{
                    
                    arr = [NSMutableArray arrayWithObject:node];
                    [self.backgroundImages setObject:arr forKey:key];
                    
                }

            }
            
            /******************************************************/
            /***************** Performance Tuning *****************/
            /******** No need to store last, current, next ********/
            /*********** Knowing currentIndex is enough ***********/
            /******************************************************/

            // save background info
            NSNumber *currentIndex = [NSNumber numberWithInt:2];
            NSNumber *offset = [NSNumber numberWithFloat:0.0f];
            NSNumber *speed = [imageData objectForKey:@"speed"];
            NSString *direction = [imageData objectForKey:@"direction"];
            SKSpriteNode *last = [[self.backgroundImages objectForKey:key] objectAtIndex:0];
            SKSpriteNode *current = [[self.backgroundImages objectForKey:key] objectAtIndex:1];
            SKSpriteNode *next = [[self.backgroundImages objectForKey:key] objectAtIndex:2];
            
            NSMutableDictionary *info = [NSMutableDictionary
                                  dictionaryWithObjects:@[currentIndex, offset, speed, direction, last, current, next]
                                  forKeys:@[@"currentIndex", @"offset", @"speed", @"direction", @"last", @"current", @"next"]];
            [self.backgroundInformation setObject:info forKey:key];
            
            // put node on
            if([direction isEqualToString:@"left"]){
                
                last.position = CGPointMake(last.size.width/2, self.size.height/2);
                current.position = CGPointMake(current.size.width/2 + last.size.width, self.size.height/2);
                next.position = CGPointMake(next.size.width/2 + last.size.width + current.size.width, self.size.height/2);
                
            }
            else if([direction isEqualToString:@"right"]){
            
                last.position = CGPointMake(last.size.width/2 - next.size.width - current.size.width, self.size.height/2);
                current.position = CGPointMake(current.size.width/2 - next.size.width, self.size.height/2);
                next.position = CGPointMake(next.size.width/2, self.size.height/2);
                
            }
        
        }
        else{

            SKSpriteNode *node = [[SKSpriteNode alloc] initWithImageNamed:key];
            if([key isEqualToString:@"moon"]) node.position = CGPointMake(self.size.width*0.85, self.size.height*0.9);
            else node.position = CGPointMake(self.size.width/2, self.size.height/2);
            node.zPosition = -100 - z;
            [self addChild:node];
        
        }
        z++;
        
    }

}

- (void)moveBackground{

    for(id key in self.backgroundInformation){

        // get information
        NSMutableDictionary *info = [self.backgroundInformation objectForKey:key];
        float offset = [[info objectForKey:@"offset"] floatValue];
        int currentIndex = [[info objectForKey:@"currentIndex"] integerValue];
        NSString *direction = [info objectForKey:@"direction"];
        SKSpriteNode *last = [info objectForKey:@"last"];
        SKSpriteNode *current = [info objectForKey:@"current"];
        SKSpriteNode *next = [info objectForKey:@"next"];
        
        float speed = [[info objectForKey:@"speed"] floatValue];
        if(!([key isEqualToString:@"fog_back"] || [key isEqualToString:@"fog_front"])){
            
            speed /= self.speedFactor;
            if(self.speedFactor > SLOWING_THRESHOLD){
                
                self.isSlowingDown = NO;
                speed = 0;
                
            }
        }
        
        // calculate offset
        if([direction isEqualToString:@"left"]){
            
            last.position = CGPointMake(last.position.x - speed, last.position.y);
            current.position = CGPointMake(current.position.x - speed, current.position.y);
            next.position = CGPointMake(next.position.x - speed, next.position.y);
            
            offset-=speed;
            
            // offset exceeds screen width => load next image
            if(fabsf(offset) >= self.size.width){
                
                currentIndex++;
                if(currentIndex > 5) currentIndex = 1;
                [info setObject:[NSNumber numberWithInt:currentIndex] forKey:@"currentIndex"];
                last = current;
                current = next;
                [info setObject:last forKey:@"last"];
                [info setObject:current forKey:@"current"];

                int nextIndex = currentIndex+1;
                if(nextIndex > 5) nextIndex = 1;
//                if([key isEqualToString:@"fog_back"]) NSLog(@"chage from %d to %d", currentIndex, nextIndex);
                next = [[self.backgroundImages objectForKey:key] objectAtIndex:nextIndex-1];
                next.position = CGPointMake(current.position.x + current.size.width, self.size.height/2);
                [info setObject:next forKey:@"next"];
                if([key isEqualToString:@"fog_back"]) NSLog(@"last: %@, current: %@, next: %@", last, current, next);
                offset = 0.0f;
                
            }
        
        }
        else if([direction isEqualToString:@"right"]){
            
            last.position = CGPointMake(last.position.x + speed, last.position.y);
            current.position = CGPointMake(current.position.x + speed, current.position.y);
            next.position = CGPointMake(next.position.x + speed, next.position.y);
            
            offset+=speed;
            
            // offset exceeds screen width => load next image
            if(fabsf(offset) >= self.size.width){
                
                currentIndex--;
                if(currentIndex < 1) currentIndex = 5;
                [info setObject:[NSNumber numberWithInt:currentIndex] forKey:@"currentIndex"];
                next = current;
                current = last;
                [info setObject:next forKey:@"next"];
                [info setObject:current forKey:@"current"];
                
                int lastIndex = currentIndex-1;
                if(lastIndex < 1) lastIndex = 5;
//                if([key isEqualToString:@"fog_back"]) NSLog(@"chage from %d to %d", currentIndex, nextIndex);
                last = [[self.backgroundImages objectForKey:key] objectAtIndex:lastIndex-1];
                last.position = CGPointMake(current.position.x - last.size.width, self.size.height/2);
                [info setObject:last forKey:@"last"];
                if([key isEqualToString:@"fog_back"]) NSLog(@"last: %@, current: %@, next: %@", last, current, next);
                offset = 0.0f;
                
            }
            
        }
        [info setObject:[NSNumber numberWithFloat:offset] forKey:@"offset"];
    
    }
    
}

-(void)slowDown{

    self.isSlowingDown = YES;
    self.isSpeedingUp = NO;

}

-(void)speedUp{

    self.isSpeedingUp = YES;
    self.isSlowingDown = NO;

}

#pragma Drawing Path

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
    
    [self speedUp];
    
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
    
    [self slowDown];

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

    // handle acceleration
    if(self.isSlowingDown){
    
        self.speedFactor *= 2;
    
    }
    else if(self.isSpeedingUp){
    
        self.speedFactor /= 2;
        if(self.speedFactor == 1) self.isSpeedingUp = NO;
    
    }
    
    [self moveBackground];
    
}

@end
