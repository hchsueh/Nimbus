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
#import "PatternCollection.h"

@interface ViewController()

@property (strong, nonatomic) PaintView *paintView;
@property (strong, nonatomic) ParticleScene *particleScene;
@property (strong, nonatomic) NSTimer *timer;
@property (strong, nonatomic) PatternCollection *collection;

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
    
    self.collection = [[PatternCollection alloc] initWithFirstPattern];
    for (Pattern *pattern in self.collection.patternsInCollection)
    {
        NSLog(@"there's a pattern in the collection named: %@ !", pattern.name);
    }
    
    NSMutableArray *matchedResult = [self.collection matchWithPatternsInCollection:[UIImage imageNamed:@"BabyGoldenSnitchPattern"]];
    NSLog(@"matched result: %d", [[matchedResult objectAtIndex:1] boolValue]);
    
}

- (void)stopDrawing {

    self.paintView.canDraw = false;
    self.particleScene.alpha = 0;
    
}

// Protocol Methods

- (void)pauseDrawing {

    self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0
                                                  target:self
                                                selector:@selector(stopDrawing)
                                                userInfo:nil
                                                 repeats:NO];

}

- (void)startDrawing {
    
    [NSTimer scheduledTimerWithTimeInterval:10.0
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
    [self.timer invalidate];

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
