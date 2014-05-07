//
//  ViewController.m
//  painter_test
//
//  Created by Apple on 2014/3/30.
//  Copyright (c) 2014年 Hsueh. All rights reserved.
//

#import "ViewController.h"
#import "ParticleScene.h"
#import "PaintView.h"

#define GESTURE_SCORE_THRESHOLD         2.0f

@interface ViewController()

@property (strong, nonatomic) PaintView *paintView;
@property (strong, nonatomic) ParticleScene *particleScene;
@property (strong, nonatomic) NSTimer *timerPause;
@property (strong, nonatomic) NSTimer *timerStop;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Configure the view.
    SKView * skView = (SKView *)self.view;
    skView.showsFPS = NO;
    skView.showsNodeCount = NO;
    
    // Create and configure the scene.
    self.particleScene = [ParticleScene sceneWithSize: skView.bounds.size];
    self.particleScene.scaleMode = SKSceneScaleModeAspectFill;
    
    // Present the scene.
    [skView presentScene: self.particleScene];
    
    // put paintView
    self.paintView = [[PaintView alloc] initWithFrame: self.view.bounds];
    self.paintView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self.paintView loadTemplatesWithNames:@"N",@"W", @"V", @"circle", nil];
    self.paintView.delegate = self;
    self.paintView.canDraw = true;
    [self.view addSubview: self.paintView];

    [super viewDidLoad];
    
    
}

- (void)stopDrawing {

//    self.paintView.canDraw = false;
//    self.particleScene.alpha = 0;
    [self.timerStop invalidate];
    [self.particleScene endMoving]; // tells ParticleScene to remove all children
    [self.paintView endDrawing]; // tells paintView to start glyph detection

}

// Protocol Methods

- (void)pauseDrawing {
    [self.particleScene endMoving];
    self.timerPause = [NSTimer scheduledTimerWithTimeInterval:1.0
                                                  target:self
                                                selector:@selector(stopDrawing)
                                                userInfo:nil
                                                 repeats:NO];

}

- (void)startDrawing {
    
    self.timerStop = [NSTimer scheduledTimerWithTimeInterval:10.0
                                    target:self
                                  selector:@selector(stopDrawing)
                                  userInfo:nil
                                   repeats:NO];
    
}

- (void)createPath:(UIBezierPath *)path withTimeInterval:(NSTimeInterval)interval {

    [self.particleScene followPath:path withTimeInterval:interval];

}

- (void)closePath{

//    [self.particleScene endMoving];
    NSLog(@"call particleScene endMoving");
//    [self.paintView endDrawing];
}

- (void)beginPath:(CGPoint)position{

    [self.particleScene beginMoving:position];
    [self.timerPause invalidate];

}

#pragma mark - Delegate

- (void)PaintView:(PaintView*)theView glyphDetected:(WTMGlyph *)glyph withScore:(float)score
{
    //Reject detection when quality too low
    //More info: http://britg.com/2011/07/17/complex-gesture-recognition-understanding-the-score/
    
    //    if (score < GESTURE_SCORE_THRESHOLD){
    //        NSLog(@"not a recognized shape! hightes score: %.3f", score);
    //        return;
    //    }
    
    NSLog(@"ViewController serves as delegate to execute method!");
    
    if(score < GESTURE_SCORE_THRESHOLD){
        NSLog(@"No gesture detected!\nScore: %.3f (highest)", score);
    }
    else{
        NSLog(@"Last gesture detected: %@\nScore: %.3f", glyph.name, score);
        [self.particleScene displayAnimation];
    }
    
}

#pragma mark - Default Settings

- (BOOL)shouldAutorotate
{
    return NO;
}

- (NSUInteger)supportedInterfaceOrientations
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return UIInterfaceOrientationMaskAllButUpsideDown;
    } else {
        return UIInterfaceOrientationMaskAll;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

@end
