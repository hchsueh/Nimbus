//
//  PaintView.h
//  painter_test
//
//  Created by Apple on 2014/4/1.
//  Copyright (c) 2014年 Hsueh. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PathDelegate

- (void)createPath:(UIBezierPath *)path withTimeInterval:(NSTimeInterval)interval;
- (void)closePath;
- (void)beginPath:(CGPoint)position;
- (void)startDrawing;

@end

@interface PaintView : UIView <PathDelegate>

@property (strong, nonatomic) NSMutableArray *paths;
@property (assign, nonatomic) id delegate;
@property (nonatomic) BOOL canDraw;

@end
