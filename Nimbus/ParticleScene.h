//
//  MyScene.h
//  painter_test
//

//  Copyright (c) 2014年 Hsueh. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface ParticleScene : SKScene

-(void)followPath:(UIBezierPath *)path withTimeInterval:(NSTimeInterval)interval;
-(void)endMoving;
-(void)beginMoving:(CGPoint)position;
-(void)clearAll;

@end
