//
//  Player.h
//  Nimbus
//
//  Created by Apple on 2014/5/10.
//
//

#import <SpriteKit/SpriteKit.h>

typedef enum : uint8_t {
    PlayerAnimationStateIdle = 0,
    PlayerAnimationStateInjured
} PlayerAnimationState;

@interface Player : SKSpriteNode

@property (nonatomic) PlayerAnimationState playerState;

- (id)initWithTexture: (SKTexture *) texture AtPosition:(CGPoint)position;
- (void) runAnimationIdle;

@end
