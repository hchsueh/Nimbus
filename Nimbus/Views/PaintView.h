//
//  PaintView.h
//  painter_test
//
//  Created by Apple on 2014/4/1.
//  Copyright (c) 2014年 Hsueh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WTMGlyphDetector.h"

@class PaintView;

@protocol PathDelegate

- (void)createPath:(UIBezierPath *)path withTimeInterval:(NSTimeInterval)interval;
- (void)closePath;
- (void)beginPath:(CGPoint)position;
- (void)startDrawing;
- (void)pauseDrawing;

- (void)PaintView:(PaintView*) theView glyphDetected:(WTMGlyph *)glyph withScore:(float)score;

@end

@interface PaintView : UIView <PathDelegate>

@property (strong, nonatomic) NSMutableArray *paths;
@property (assign, nonatomic) id delegate;
@property (nonatomic) BOOL canDraw;

- (void) loadTemplatesWithNames:(NSString*)firstTemplate, ... NS_REQUIRES_NIL_TERMINATION;
- (void) endDrawing;

@end
