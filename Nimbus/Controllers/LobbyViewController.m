//
//  LobbyViewController.m
//  Nimbus
//
//  Created by Apple on 2014/5/11.
//
//

#import "LobbyViewController.h"
#import "LobbyView.h"
#import "ViewController.h"

@interface LobbyViewController ()

@end

@implementation LobbyViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

-(void) viewDidAppear:(BOOL)animated
{
    LobbyView *lobbyView = [[LobbyView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:lobbyView];
}

-(void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self performSegueWithIdentifier:@"SEGUE_TO_GAME" sender:self];
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
    // Dispose of any resources that can be recreated.
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if([[segue identifier] isEqualToString:@"SEGUE_TO_GAME"])
    {
//        NSLog(@"segue SEGUE_TO_GAME taken!");
        ViewController *vc = [segue destinationViewController];
        vc.currentStage = 1;
//        NSLog(@"vc.currentStage = %d", vc.currentStage);
    }
}


@end
