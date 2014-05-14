//
//  MagicFromEnemy.h
//  Nimbus
//
//  Created by Apple on 2014/5/14.
//
//

#import <SpriteKit/SpriteKit.h>

//@interface MagicFromEnemy : SKSpriteNode
@interface MagicFromEnemy : SKSpriteNode

@property (nonatomic) BOOL hasHit;
-(id) initAtPosition: (CGPoint) position;
-(void) addParticleWithTargetNode: (SKNode *) node;
-(void) runAnimationHitTarget;
-(void) runAnimationBlocked;

@end
