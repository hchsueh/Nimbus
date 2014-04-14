//
//  ViewController.h
//  painter_test
//

//  Copyright (c) 2014年 Hsueh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SpriteKit/SpriteKit.h>

@interface ViewController : UIViewController

- (void)createPath:(UIBezierPath *)path withTimeInterval:(NSTimeInterval)interval;
- (void)closePath;
- (void)beginPath;
- (void)pauseDrawing;
- (void)startDrawing;

@end