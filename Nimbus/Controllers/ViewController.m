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
#import "StageclearViewController.h"

#define GESTURE_SCORE_THRESHOLD         2.55f

@interface ViewController()

@property (strong, nonatomic) NSMutableArray *gameInfo;
@property (strong, nonatomic) PaintView *paintView;
@property (strong, nonatomic) ParticleScene *particleScene;
//@property (strong, nonatomic) WelcomeScene *welcomeScene;
@property (strong, nonatomic) NSTimer *timerPause;
@property (strong, nonatomic) NSTimer *timerStop;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
//    NSLog(@"view did load");
    
    // Configure the view.
    SKView * skView = (SKView *)self.view;
    skView.showsFPS = YES;
    skView.showsNodeCount = YES;
    
    // Create and configure the scene.
    self.particleScene = [ParticleScene sceneWithSize: CGSizeMake(skView.bounds.size.height, skView.bounds.size.width)];
    self.particleScene.currentStage = self.currentStage;
    self.particleScene.scaleMode = SKSceneScaleModeAspectFill;
    self.particleScene.delegate = self;
    [skView presentScene: self.particleScene];
    
    // put paintView
    self.paintView = [[PaintView alloc] initWithFrame: self.view.bounds];
    self.paintView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self.paintView loadTemplatesWithNames:@"W", @"V", @"shieldPattern", nil];
    self.paintView.delegate = self;
    self.paintView.canDraw = true;
    [self.view addSubview: self.paintView];
    
//    [super viewDidLoad];
}

#pragma mark - Drawing methods
- (void)stopDrawing {

//    self.paintView.canDraw = false;
//    self.particleScene.alpha = 0;
    [self.timerStop invalidate];
    [self.particleScene endMoving]; // tell ParticleScene to remove all children
    [self.paintView endDrawing]; // tell paintView to start glyph detection

}

#pragma mark - PaintView Delegate Protocol Methods
- (void)pauseDrawing {
    [self.particleScene pauseMoving];
    self.timerPause = [NSTimer scheduledTimerWithTimeInterval:0.5
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
//    NSLog(@"call particleScene endMoving");
//    [self.paintView endDrawing];
}

- (void)beginPath:(CGPoint)position{

    [self.particleScene beginMoving:position];
    [self.timerPause invalidate];

}

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
        if( [glyph.name isEqualToString:@"W"]){
            [self.particleScene displayAnimationWithPatternNum:1];
            NSLog(@"W means RACHAEL!!! ARGHHHHHHHH");
        }
        else if( [glyph.name isEqualToString:@"V"] ){
            [self.particleScene displayAnimationWithPatternNum:2];
            NSLog(@"V means babyGoldenSnitch!!!");
        }
        else {
            [self.particleScene displayAnimationWithPatternNum:3];
            NSLog(@"Come'n Shield Pattern!!!");
        }
    }
    
}

#pragma mark - particleScene Delegate Methods

-(void) stageEndedWithInformation: (NSMutableArray *) information;
{
    self.gameInfo = information;
    if([[self.gameInfo objectAtIndex:0] boolValue]) {
        [self performSegueWithIdentifier:@"SEGUE_TO_STAGECLEAR" sender:self];
    }
    else {
        [self performSegueWithIdentifier:@"SEGUE_TO_GAMEOVER" sender:self];
    }
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if([[segue identifier] isEqualToString:@"SEGUE_TO_STAGECLEAR"])
    {
        StageclearViewController *vc = [segue destinationViewController];
        vc.gameStage = [self.gameInfo objectAtIndex:1];
        vc.gamePlayerHealthLeft = [self.gameInfo objectAtIndex:2];
        vc.gameDuration = [self.gameInfo objectAtIndex:3];
    }
}

#pragma mark - Default Settings

- (BOOL)shouldAutorotate
{
    return YES;
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
