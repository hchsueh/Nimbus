//
//  StageclearViewController.m
//  Nimbus
//
//  Created by Apple on 2014/5/14.
//
//

#import "StageclearViewController.h"
#import "StageclearView.h"
#import "AFNetworking.h"

@interface StageclearViewController ()

@end

@implementation StageclearViewController

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
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSUUID *deviceid = [UIDevice currentDevice].identifierForVendor;
    
    NSDictionary *params = @{@"time": self.gameDuration,
                             @"life": self.gamePlayerHealthLeft,
                             @"UUID": [deviceid UUIDString],
                             @"stage": self.gameStage};
    [manager POST:@"http://140.112.245.144:3000/record" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
}

-(void) viewDidAppear:(BOOL)animated
{
    StageclearView *stageclearView = [[StageclearView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:stageclearView];
    NSLog(@"stage info: playerHealthLeft: %d, gameDuration: %e", self.gamePlayerHealthLeft.integerValue, self.gameDuration.doubleValue);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self performSegueWithIdentifier:@"SEGUE_BACK_TO_LOBBY" sender:self];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
