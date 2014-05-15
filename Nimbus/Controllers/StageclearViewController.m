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
#import "LobbyViewController.h"

//#define SERVER_URL @"http://140.112.245.144:3000/record"
#define SERVER_URL @"http://140.112.18.200:3000/record"



@interface StageclearViewController ()
@property (nonatomic) BOOL canTouch;
@property (nonatomic, strong) StageclearView *stageclearView;
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
    
    self.canTouch = NO;
    
//    // POST
//    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
//    NSUUID *deviceid = [UIDevice currentDevice].identifierForVendor;
//    
//    NSDictionary *params = @{@"time": self.gameDuration,
//                             @"life": self.gamePlayerHealthLeft,
//                             @"UUID": [deviceid UUIDString],
//                             @"stage": self.gameStage};
//    [manager POST:SERVER_URL parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
//              
//        NSLog(@"JSON: %@", responseObject);
//        self.canTouch = YES;
//        NSError *err;
//        NSLog(@"%@", [responseObject class]);
//        NSDictionary *data = [NSDictionary dictionaryWithDictionary:responseObject];
////        [self.stageclearView updateLabel:[responseObject objectForKey:@"rank"] ];
//        NSLog(@"FFUEHGILAEKEQ");
//        [self.stageclearView updateLabel:[NSNumber numberWithInt:12]];
//        
//        
////        NSDictionary *data = [NSDictionary dictionaryWithDictionary: [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:&err]];
////        self.stageclearView.rank = [[data objectForKey:@"rank"] integerValue];
////        NSLog(@"%d", self.stageclearView.rank);
//        
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        
//        NSLog(@"Error: %@", error);
//        
//    }];
    
}

-(void) viewDidAppear:(BOOL)animated
{

    
    // POST
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSUUID *deviceid = [UIDevice currentDevice].identifierForVendor;
    
    NSDictionary *params = @{@"time": self.gameDuration,
                             @"life": self.gamePlayerHealthLeft,
                             @"UUID": [deviceid UUIDString],
                             @"stage": self.gameStage};
    [manager POST:SERVER_URL parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSLog(@"JSON: %@", responseObject);
        self.canTouch = YES;
        NSError *err;
        NSLog(@"%@", [responseObject class]);
        NSDictionary *data = [NSDictionary dictionaryWithDictionary:responseObject];
        //        [self.stageclearView updateLabel:[responseObject objectForKey:@"rank"] ];
        NSLog(@"FFUEHGILAEKEQ");
//        [self.stageclearView updateLabel:[NSNumber numberWithInt:12]];
        //    self.stageclearView = [[StageclearView alloc] initWithFrame:self.view.bounds];
        self.stageclearView = [[StageclearView alloc] initWithRank:[responseObject objectForKey:@"rank"]];
        [self.view addSubview:self.stageclearView];
        NSLog(@"stage info: playerHealthLeft: %d, gameDuration: %e", self.gamePlayerHealthLeft.integerValue, self.gameDuration.doubleValue);
        

        
        
        //        NSDictionary *data = [NSDictionary dictionaryWithDictionary: [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:&err]];
        //        self.stageclearView.rank = [[data objectForKey:@"rank"] integerValue];
        //        NSLog(@"%d", self.stageclearView.rank);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"Error: %@", error);
        
    }];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    if(self.canTouch) [self performSegueWithIdentifier:@"SEGUE_BACK_TO_LOBBY" sender:self];
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if([[segue identifier] isEqualToString:@"SEGUE_BACK_TO_LOBBY"])
    {
        LobbyViewController *vc = [segue destinationViewController];
        vc.stage = 2;
    }
}
@end
