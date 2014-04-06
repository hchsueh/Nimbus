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
@property (strong, nonatomic) NSTimer *timerMax;
@property (strong, nonatomic) PatternCollection *collection;
@property (strong, nonatomic) UIImage *playerDrawnImage;

-(NSMutableArray*) strokeImageWithColor:(UIColor*) color withPathsInArray:(NSMutableArray *) pathArray;

-(UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize;

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
    
//    [super viewDidLoad];
    
    self.collection = [[PatternCollection alloc] initWithFirstPattern];
    
    NSMutableArray *matchedResult = [self.collection matchWithPatternsInCollection:[UIImage imageNamed:@"BabyGoldenSnitchPattern"]];
    NSLog(@"matched result: %d", [[matchedResult objectAtIndex:1] boolValue]);
    
    self.playerDrawnImage = nil;
    
}

- (void)stopDrawing {

    [self.timer invalidate];
    [self.timerMax invalidate];
    
    self.paintView.canDraw = false;
    self.particleScene.alpha = 0;
    
    NSMutableArray *temp = [self strokeImageWithColor:[UIColor blackColor] withPathsInArray:self.paintView.paths];
    UIImage *rawImage = [temp objectAtIndex:0];
    NSLog(@"rawImage width:%f, height:%f", rawImage.size.width, rawImage.size.height);
    CGRect rawImageBounds = [[temp objectAtIndex:1] CGRectValue];
    
    UIImageView *playerDrawnPathView = [[UIImageView alloc] initWithFrame:rawImageBounds];
    playerDrawnPathView.image = rawImage;
    [playerDrawnPathView.layer setBorderColor: [[UIColor blueColor] CGColor]];
    [playerDrawnPathView.layer setBorderWidth: 1.0];
    [self.view addSubview:playerDrawnPathView];
    
    self.playerDrawnImage = [self imageWithImage:rawImage scaledToSize:CGSizeMake(200, 200)];
    
    NSLog(@"playerDrawnImage get! height: %f, width: %f", self.playerDrawnImage.size.height, self.playerDrawnImage.size.width);

    NSMutableArray *matchedResult = [self.collection matchWithPatternsInCollection:self.playerDrawnImage];
//    NSLog(@"playerDrawnImage matching result: %d", [[matchedResult objectAtIndex:1] boolValue]);
    
}

// Protocol Methods

- (void)pauseDrawing {

    self.timer = [NSTimer scheduledTimerWithTimeInterval:2.0
                                                  target:self
                                                selector:@selector(stopDrawing)
                                                userInfo:nil
                                                 repeats:NO];

}

- (void)startDrawing {
    
    self.timerMax = [NSTimer scheduledTimerWithTimeInterval:10.0
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


-(NSMutableArray*) strokeImageWithColor:(UIColor*) color withPathsInArray:(NSMutableArray *) pathArray;
{
    NSMutableArray *result = [[NSMutableArray alloc] init];
    
    UIBezierPath *connectedPath = [[UIBezierPath alloc] init];
    for( UIBezierPath *path in pathArray)
    {
        [connectedPath appendPath:path];
    }
    
    // adjust bounds to account for extra space needed for lineWidth
    CGFloat width = connectedPath.bounds.size.width + connectedPath.lineWidth * 2;
    CGFloat height = connectedPath.bounds.size.height + connectedPath.lineWidth * 2;
    CGFloat sideLength = MAX(width, height);
    CGRect bounds = CGRectMake(connectedPath.bounds.origin.x, connectedPath.bounds.origin.y, sideLength, sideLength);
    
    // create a view to draw the path in
    UIView *view = [[UIView alloc] initWithFrame:bounds];
    
    // begin graphics context for drawing
    UIGraphicsBeginImageContextWithOptions(view.frame.size, NO, [[UIScreen mainScreen] scale]);
    
    // configure the view to render in the graphics context
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    
    // get reference to the graphics context
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    // translate matrix so that path will be centered in bounds
    CGContextTranslateCTM(context, -(bounds.origin.x - connectedPath.lineWidth), -(bounds.origin.y - connectedPath.lineWidth));
    
    // set color
    [color set];
    
    // draw the stroke
    [connectedPath stroke];
    
    // get an image of the graphics context
    UIImage *viewImage = UIGraphicsGetImageFromCurrentImageContext();
    
    // end the context
    UIGraphicsEndImageContext();
    
    [result addObject:viewImage];
    [result addObject:[NSValue valueWithCGRect:bounds]];
    
    return result;
}

-(UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize
{
    //UIGraphicsBeginImageContext(newSize);
    // In next line, pass 0.0 to use the current device's pixel scaling factor (and thus account for Retina resolution).
    // Pass 1.0 to force exact pixel size.
    UIGraphicsBeginImageContextWithOptions(newSize, NO, 0.0);
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
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
