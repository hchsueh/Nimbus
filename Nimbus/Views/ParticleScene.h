//
//  MyScene.h
//  painter_test
//

//  Copyright (c) 2014年 Hsueh. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@protocol gameSceneDelegate

-(void) stageEnded;

@end

@interface ParticleScene : SKScene <gameSceneDelegate>

@property (nonatomic) int currentStage;
@property (assign, nonatomic) id delegate;

-(void)followPath:(UIBezierPath *)path withTimeInterval:(NSTimeInterval)interval;
-(void)endMoving;
-(void)pauseMoving;
-(void)beginMoving:(CGPoint)position;
//-(void)clearAll;

-(void) displayAnimation;

@end
