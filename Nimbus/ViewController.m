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

@interface ViewController()

@property (strong, nonatomic) PaintView *paintView;
@property (strong, nonatomic) ParticleScene *particleScene;

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
    self.paintView.delegate = self;
    self.paintView.canDraw = true;
    [self.view addSubview: self.paintView];

    [super viewDidLoad];
    
    
}

- (void)stopDrawing {

    [self.particleScene clearAll];
    self.paintView.canDraw = false;

}

// Protocol Methods

- (void)startDrawing {

    [NSTimer scheduledTimerWithTimeInterval:2.0
                                     target:self
                                   selector:@selector(stopDrawing)
                                   userInfo:nil
                                    repeats:NO];

}

- (void)createPath:(UIBezierPath *)path withTimeInterval:(NSTimeInterval)interval {

    [self.particleScene followPath:path withTimeInterval:interval];

}

- (void)closePath{

    [self.particleScene endMoving];

}

- (void)beginPath:(CGPoint)position{

    [self.particleScene beginMoving:position];

}

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
