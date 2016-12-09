//
//  StartViewController.m
//  qtum wallet
//
//  Created by Sharaev Vladimir on 17.11.16.
//  Copyright © 2016 Designsters. All rights reserved.
//

#import "StartViewController.h"
#import "KeysManager.h"
#import "ImportKeyViewController.h"

@interface StartViewController () <ImportKeyViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UIButton *createButton;
@property (weak, nonatomic) IBOutlet UIButton *restoreButton;

- (IBAction)createNewButtonWasPressed:(id)sender;

@end

@implementation StartViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.restoreButton setBackgroundColor:[UIColor colorWithWhite:1.0f alpha:0.3f]];
    [self.createButton setBackgroundColor:[UIColor colorWithWhite:1.0f alpha:0.3f]];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)createNewButtonWasPressed:(id)sender
{
    [SVProgressHUD show];
    
    __weak typeof(self) weakSelf = self;
    [KeysManager sharedInstance].keyRegistered = ^(BOOL registered){
        if (registered) {
            [SVProgressHUD showSuccessWithStatus:@"Done"];
            [weakSelf createAndShowMainVC];
        }else{
            [SVProgressHUD showErrorWithStatus:@"Some Error"];
        }
        [KeysManager sharedInstance].keyRegistered = nil;
    };
    [[KeysManager sharedInstance] createNewKey];
}

- (void)createAndShowMainVC
{
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UIViewController *vc = [mainStoryboard instantiateViewControllerWithIdentifier:@"MainViewController"];
    __weak typeof(self) weakSelf = self;
    [self presentViewController:vc animated:YES completion:nil];
}

#pragma mark - ImportKeyViewControllerDelegate

- (void)addressImported
{
    [self createAndShowMainVC];
}

#pragma mark - 

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSString *segueID = segue.identifier;
    
    if ([segueID isEqualToString:@"StartToImport"]) {
        ImportKeyViewController *vc = (ImportKeyViewController *)segue.destinationViewController;
        vc.delegate = self;
    }
}

@end
