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
#import "MagicFromEnemy.h"

#define MAX_IMG_NUM 5
#define SLOWING_THRESHOLD 100
#define ENEMY_ATTACK_TIME 10
#define ENEMY_ATTACK_RANGE 1

static const uint32_t magicCategory          = 0x1 << 0;
static const uint32_t enemyCategory          = 0x1 << 1;
static const uint32_t magicFromEnemyCategory = 0x1 << 2;
static const uint32_t playerCategory         = 0x1 << 3;



@interface ParticleScene() <SKPhysicsContactDelegate>

@property (strong, nonatomic) SKEmitterNode *particle;
@property (strong, nonatomic) SKEmitterNode *fire;
@property (strong ,nonatomic) NSMutableArray *particleArray;
@property (strong ,nonatomic) NSMutableArray *fireArray;

@property (strong, nonatomic) NSArray *magicFrames;
@property (strong, nonatomic) Magic *magic;
//@property (strong, nonatomic) NSMutableArray *magic;

@property (nonatomic, strong) NSMutableDictionary *backgroundInformation;
@property (nonatomic, strong) NSMutableDictionary *backgroundImages;
@property (nonatomic) float speedFactor;
@property (nonatomic) BOOL isSlowingDown;
@property (nonatomic) BOOL isSpeedingUp;

@property (nonatomic, strong) Player *player;
@property (nonatomic, strong) Enemy *enemy;
@property (nonatomic, strong) NSTimer *enemyAttackTimer;
//@property (nonatomic, strong) MagicFromEnemy *magicFromEnemy;
@property (nonatomic, strong) NSMutableArray *magicFromEnemy;
@property (nonatomic, strong) NSTimer *gameOverTimer;

@property (strong, nonatomic) NSMutableArray *stageInformation;
@property (nonatomic) int currentSubstageNum;
@property (strong, nonatomic) NSTimer *stageTransitionTimer;
@property (strong, nonatomic) NSDate *startOffTime;

@property (nonatomic) BOOL isReady;

@end

@implementation ParticleScene

-(id)initWithSize:(CGSize)size {    
    if (self = [super initWithSize:size]) {
        
//        NSLog(@"ParticleScene initWithSize");
        self.backgroundColor = [SKColor colorWithRed:1 green:1 blue:1 alpha:1];
        self.particleArray = [NSMutableArray array];
        self.fireArray = [NSMutableArray array];

        self.physicsWorld.gravity = CGVectorMake(0, 0);
        self.physicsWorld.contactDelegate = self; // not working ?????
        self.physicsBody = [SKPhysicsBody bodyWithEdgeLoopFromRect:self.frame];
        self.scaleMode = SKSceneScaleModeAspectFit;
        
        // background
        self.speedFactor = 1.0f;
//        self.speedFactor = SLOWING_THRESHOLD + 1;
        self.isSlowingDown = NO;
        self.isSpeedingUp = NO;
        self.backgroundInformation = [NSMutableDictionary dictionary];
        self.backgroundImages = [NSMutableDictionary dictionary];
        NSString *path = [[NSBundle mainBundle] pathForResource:@"ImageSet" ofType:@"plist"];
        [self setupBackgroundWithImageSet:[NSArray arrayWithContentsOfFile:path]];
//        NSLog(@"image set: %@", [NSArray arrayWithContentsOfFile:path]);
        
        UIImage *playerImage = [UIImage imageNamed:@"char.png"];
        SKTexture *playerTexture= [SKTexture textureWithCGImage:playerImage.CGImage];
        self.player = [[Player alloc] initWithTexture:playerTexture AtPosition:CGPointMake(150,400)];
        self.player.size = CGSizeMake(self.player.size.width/2, self.player.size.height/2);
        self.player.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:50];
        self.player.physicsBody.dynamic = YES;
        self.player.physicsBody.categoryBitMask = playerCategory;
        self.player.physicsBody.contactTestBitMask = magicFromEnemyCategory;
        self.player.physicsBody.collisionBitMask = 0; // ?
        self.player.physicsBody.usesPreciseCollisionDetection = YES; // magic may be moving fast !
        [self.player runAnimationIdle];
        [self addChild:self.player];
        
//        UIImage *enemyImage = [UIImage imageNamed:@"smallFireMonster.png"];
//        SKTexture *enemyTexture = [SKTexture textureWithCGImage:enemyImage.CGImage];
//        self.enemy = [[Enemy alloc] initWithTexture:enemyTexture AtPosition:CGPointMake(900,400)];
//        self.enemy.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:self.enemy.size];
//        self.enemy.physicsBody.dynamic = YES;
//        self.enemy.physicsBody.categoryBitMask = enemyCategory;
//        self.enemy.physicsBody.contactTestBitMask = magicCategory;
//        self.enemy.physicsBody.collisionBitMask = 0; // ?
//        self.enemy.health = 10;
//        [self.enemy installFireWithTargetNode:self position:self.enemy.position];
//        [self.enemy runAnimationIdle];
//        [self addChild:self.enemy];
        
        self.enemyAttackTimer = nil;
        self.magicFromEnemy = [NSMutableArray array];
        self.gameOverTimer = nil;
        
        NSMutableDictionary *stage1 = [NSMutableDictionary dictionaryWithObjects:@[@3, @[@"smallFire", @"smallFire", @"bigFire"]] forKeys:@[@"substageCount", @"monsters"]];
        NSMutableDictionary *stage2 = [NSMutableDictionary dictionaryWithObjects:@[@3, @[@"smallFire", @"smallFire", @"bigFire"]] forKeys:@[@"substageCount", @"monsters"]];
        self.stageInformation = [NSMutableArray arrayWithObjects:stage1, stage2, nil];

        self.currentSubstageNum = 0;
        self.currentStage = 1;
        NSLog(@"currentStage = %d", self.currentStage);
        self.stageTransitionTimer = nil;
        self.isReady = YES;
        self.startOffTime = [NSDate date];
    }
    return self;
}

#pragma Background

- (void)setupBackgroundWithImageSet:(NSArray *)imageSet{

//    NSLog(@"self size: %@", NSStringFromCGSize(self.size));
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
//                if([key isEqualToString:@"fog_back"]) NSLog(@"last: %@, current: %@, next: %@", last, current, next);
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
//                if([key isEqualToString:@"fog_back"]) NSLog(@"last: %@, current: %@, next: %@", last, current, next);
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
//    NSLog(@"%f", interval);
    
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
    
    
    self.magic = [[Magic alloc] initWithTexture:temp
                                     AtPosition:CGPointMake(self.player.position.x + 50, self.player.position.y + 50)];
    
    self.magic.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:self.magic.size.width/2];
    self.magic.physicsBody.dynamic = YES;
    self.magic.physicsBody.categoryBitMask = magicCategory;
    self.magic.physicsBody.contactTestBitMask = enemyCategory;
    self.magic.physicsBody.collisionBitMask = 0; // ?
    self.magic.physicsBody.usesPreciseCollisionDetection = YES; // magic may be moving fast !
    [self addChild: self.magic];
    [self.magic installHeartWithTargetNode:self];
    [self.magic runAnimationIdle];
    
//    [self.magic addObject:magic];
//    [self magicShowOff];
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
        if(self.enemy){
            // magic collides with enemy!! Yay!!!
            self.magic.hasHit = YES;
            [self.magic runAnimationHitTarget];
            
            self.enemy.health -= 5;
            NSLog(@"Smack the enemy's ass! Now the enemy's health is %d", self.enemy.health);
            
            if(self.enemy.health <= 0) {
                [self.enemy runAnimationDead];
                [self.enemyAttackTimer invalidate];
                self.enemy = nil;
                [self speedUp];
                [self gotoNextSubstage];
            }
            else {
                [self.enemy runAnimationInjured];
                double attackTime = arc4random_uniform(ENEMY_ATTACK_RANGE) + ENEMY_ATTACK_TIME;
                [self.enemyAttackTimer invalidate];
                self.enemyAttackTimer = [NSTimer scheduledTimerWithTimeInterval:attackTime target:self selector:@selector(enemyAttackTimerRings) userInfo:nil repeats:YES];
            }
        }
    }
    
    if ((firstBody.categoryBitMask & magicFromEnemyCategory) != 0 &&
        (secondBody.categoryBitMask & playerCategory) != 0)
    {
        for( MagicFromEnemy *obj in self.magicFromEnemy ){
            if( (obj.position.x <= self.player.position.x) && (obj.hasHit == NO) ){
                NSLog(@"contact: player hit by magicFromEnemy");
                obj.hasHit = YES;
                [obj runAnimationHitTarget];
                [self.magicFromEnemy removeObject:obj];
                
                self.player.health -= 5;
                NSLog(@"contact: Your ass got kicked! Now your health is %d", self.player.health);
                
                if(self.player.health <= 0) {
                    [self.player runAnimationDead];
                    self.player = nil;
                    self.gameOverTimer = [NSTimer scheduledTimerWithTimeInterval:2.5 target:self selector:@selector(gameOver) userInfo:nil repeats:NO];
                }
                else {
                    [self.player runAnimationInjured];
                }

            }
        }
    }
    
}

#pragma mark - Default Settings

-(void)update:(CFTimeInterval)currentTime {
    /* Called before each frame is rendered */
    
    if(self.isReady){
        self.isReady = NO; //turns it off to avoid everlasting scene restart !
        [self gotoNextSubstage];
    }
    
    int diff_x = self.enemy.position.x - self.magic.position.x;
    int diff_y = self.enemy.position.y - self.magic.position.y;
    int dist_y = 0;
    if(diff_x!=0){
        dist_y = (int) diff_y/diff_x;
    }
    int moveX = 20;
    int moveY = (self.enemy) ? dist_y*20 : 0;
    
    if(self.magic){
        if(self.magic.position.x > self.frame.size.width || self.magic.position.y > self.frame.size.height){
            NSLog(@"magic leaves the screen!");
            [self.magic removeFromParent];
            self.magic = nil;
        }
        else if(!self.magic.hasHit/* && self.magic.hasShownOff*/){
            [self.magic runAction: [SKAction moveByX:moveX y:moveY duration:0.1f]];
        }
    }

    // magicFromEnemy
    for( MagicFromEnemy *obj in self.magicFromEnemy ){
//        if(obj.hasHit) obj.hasHit = NO;
//        else if( obj.position.x <= self.player.position.x ) obj.hasHit = YES;
        
        diff_x = obj.position.x - self.player.position.x;
        diff_y = obj.position.y - self.player.position.y;
        dist_y = 0;
        if(diff_x!=0){
            dist_y = (int) diff_y/diff_x;
        }
        moveX = -10;
        moveY = dist_y * -10;
        
//        if(self.magicFromEnemy){
        if(obj.position.x < 0){
            NSLog(@"magicFromEnemy leaves the screen!");
            [obj removeFromParent];
            [self.magicFromEnemy removeObject:obj];
            NSLog(@"self.magicFromEnemy count:%d", self.magicFromEnemy.count);
            
        }
//        else if ( (obj.hasHit == YES) && self.player) {
//            NSLog(@"Your ass got kicked! Now your health is %d", self.player.health);
//            [obj removeFromParent];
////            [obj runAnimationHitTarget];
//            
//            self.player.health -= 5;
//            if(self.player.health <= 0) {
//                [self.player runAnimationDead];
//                self.player = nil;
//                self.gameOverTimer = [NSTimer scheduledTimerWithTimeInterval:2.5 target:self selector:@selector(gameOver) userInfo:nil repeats:NO];
//            }
//            else {
//                [self.player runAnimationInjured];
//            }
//        }
        else if(!obj.hasHit){
            [obj runAction: [SKAction moveByX:moveX y:moveY duration:0.1f]];
//            if(obj.hasHit) NSLog(@"hasHit and moving!");
        }
//        }
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


#pragma mark - Animation Methods

-(void) magicShowOff {
    [self.magic runAction: [SKAction sequence:@[ [SKAction moveByX:50.0 y:100.0 duration:0.3f],
                                                 [SKAction waitForDuration:0.7f]
                                                 ]
                            ]
     ];
    
//    [self.magic runAction:[SKAction speedBy:-5 duration:0.3f]];
    self.magic.hasShownOff = YES;
}

#pragma mark - Stage Control Methods

-(void) gotoNextSubstage {
//    NSLog(@"gotoNextSubstage");
    self.currentSubstageNum ++;
//    NSLog(@"currentSubstageNum = %d, currentStage = %d", self.currentSubstageNum, self.currentStage);
//    NSLog(@"substageCount = %d", [[[self.stageInformation objectAtIndex:self.currentStage-1] objectForKey:@"substageCount"] integerValue]);
    
    if(self.currentSubstageNum > [[[self.stageInformation objectAtIndex:self.currentStage-1] objectForKey:@"substageCount"] integerValue]){
        [self stageEnding];
    }
    else {
        NSLog(@"starts timer 2.5s");
//        [self speedUp];
        self.stageTransitionTimer = [NSTimer scheduledTimerWithTimeInterval:2.5 target:self selector:@selector(setupNewSubstage:) userInfo:nil repeats:NO];
    }
}

-(void) setupNewSubstage: (NSTimer *) timer
{
    self.stageTransitionTimer = nil;
    NSLog(@"setNewSubstage");
    [self slowDown];
    UIImage *enemyImage = [UIImage imageNamed:@"smallFireMonster.png"];
    SKTexture *enemyTexture = [SKTexture textureWithCGImage:enemyImage.CGImage];
    self.enemy = [[Enemy alloc] initWithTexture:enemyTexture AtPosition:CGPointMake(1200,400)];
    self.enemy.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:self.enemy.size];
    self.enemy.physicsBody.dynamic = YES;
    self.enemy.physicsBody.categoryBitMask = enemyCategory;
    self.enemy.physicsBody.contactTestBitMask = magicCategory;
    self.enemy.physicsBody.collisionBitMask = 0; // ?
    
    if(self.currentSubstageNum == [[[self.stageInformation objectAtIndex:self.currentStage-1] objectForKey:@"substageCount"] integerValue]){
        NSLog(@" final Substage! The BOSS's coming ...");
        self.enemy.health = 15;
        self.enemy.size = CGSizeMake(self.enemy.size.width*5, self.enemy.size.height*5);
    }
    else {
        self.enemy.health = 10;
    }
    
    [self.enemy installFireWithTargetNode:self position:self.enemy.position];
    [self.enemy runAnimationIdle];
    [self addChild:self.enemy];
    [self enemyEntering];
    double attackTime = arc4random_uniform(ENEMY_ATTACK_RANGE) + ENEMY_ATTACK_TIME;
    self.enemyAttackTimer = [NSTimer scheduledTimerWithTimeInterval:attackTime target:self selector:@selector(enemyAttackTimerRings) userInfo:nil repeats:YES];

}

-(void) enemyAttackTimerRings
{
    NSLog(@"Enemy Attacks!");
    MagicFromEnemy *magicFromEnemy = [[MagicFromEnemy alloc] initAtPosition:
                                      CGPointMake(self.enemy.position.x - 20, self.enemy.position.y)];
    [magicFromEnemy addParticleWithTargetNode:self];
    magicFromEnemy.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:50];
    magicFromEnemy.physicsBody.dynamic = YES;
    magicFromEnemy.physicsBody.categoryBitMask = magicFromEnemyCategory;
    magicFromEnemy.physicsBody.contactTestBitMask = playerCategory;
    magicFromEnemy.physicsBody.collisionBitMask = 0; // ?
    magicFromEnemy.physicsBody.usesPreciseCollisionDetection = YES; // magic may be moving fast !
    [self addChild: magicFromEnemy];
    [self.magicFromEnemy addObject:magicFromEnemy];
    NSLog(@"self.magicFromEnemy count: %d", [self.magicFromEnemy count]);
    
}

-(void) enemyEntering
{
    [self.enemy runAction: [SKAction moveByX:-300 y:0 duration:1.5f]];
}

-(void) stageEnding {
    // ending animation, goto ending scene
    NSLog(@"This stage ends!");
    NSMutableArray *info = [NSMutableArray array];
    
    [info addObject: [NSNumber numberWithBool:YES]];
    [info addObject: [NSNumber numberWithInt:self.currentStage]];
    [info addObject: [NSNumber numberWithInt:self.player.health]]; // an integer

    NSDate *endTime = [NSDate date];
    NSTimeInterval gameDuration = [endTime timeIntervalSinceDate:self.startOffTime];
    [info addObject: [NSNumber numberWithDouble:gameDuration]]; // a double
    
    [self.delegate stageEndedWithInformation: info];

}

-(void) gameOver
{
    NSLog(@"Game OVERRRRRRRR Orz");
    NSMutableArray *info = [NSMutableArray array];
    [info addObject: [NSNumber numberWithBool:NO]];
    
    [self.enemyAttackTimer invalidate];
    self.enemyAttackTimer = nil;
    self.enemy = nil;
    self.magic = nil;
    [self.magicFromEnemy removeAllObjects];
    [self removeAllChildren];
    
    [self.delegate stageEndedWithInformation: info];
}

@end
