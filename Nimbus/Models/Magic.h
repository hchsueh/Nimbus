//
//  Magic.h
//  Nimbus
//
//  Created by Apple on 2014/5/10.
//
//

#import <SpriteKit/SpriteKit.h>

@interface Magic : SKSpriteNode

- (id)initWithTexture: (SKTexture *) texture AtPosition:(CGPoint)position;
- (void) runAnimationIdle;
- (void) runAnimationHitTarget;

@end
