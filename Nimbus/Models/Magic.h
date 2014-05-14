//
//  Magic.h
//  Nimbus
//
//  Created by Apple on 2014/5/10.
//
//

#import <SpriteKit/SpriteKit.h>

@interface Magic : SKSpriteNode

@property (nonatomic) bool hasHit;
@property (nonatomic) bool hasShownOff;
- (id)initWithTexture: (SKTexture *) texture AtPosition:(CGPoint)position;
- (void) installHeartWithTargetNode: (SKNode *) node;
- (void) runAnimationIdle;
- (void) runAnimationHitTarget;

@end
