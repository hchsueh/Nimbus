//
//  ViewController.m
//  painter_test
//
//  Created by Apple on 2014/3/30.
//  Copyright (c) 2014年 Hsueh. All rights reserved.
//

#import "ViewController.h"
#import "MyScene.h"
#import "PaintView.h"

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    
    // Configure the view.
    SKView * skView = (SKView *)self.view;
    skView.showsFPS = YES;
    skView.showsNodeCount = YES;
    
    // Create and configure the scene.
    SKScene * scene = [MyScene sceneWithSize: skView.bounds.size];
    scene.scaleMode = SKSceneScaleModeAspectFill;
    
    // Present the scene.
    [skView presentScene: scene];
    

    PaintView *paint = [[PaintView alloc]initWithFrame: self.view.bounds];
    [self.view addSubview: paint];


    [super viewDidLoad];
    
    
}

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
