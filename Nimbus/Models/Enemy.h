//
//  Enemy.h
//  Nimbus
//
//  Created by Apple on 2014/5/10.
//
//

#import <SpriteKit/SpriteKit.h>

@interface Enemy : SKSpriteNode

- (id)initWithTexture: (SKTexture *) texture AtPosition:(CGPoint)position;
- (void) runAnimationIdle;
- (void) runAnimationInjured;

@end
