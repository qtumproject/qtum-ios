//
//  StartViewController.m
//  qtum wallet
//
//  Created by Sharaev Vladimir on 17.11.16.
//  Copyright © 2016 Designsters. All rights reserved.
//

#import "StartViewController.h"
#import "ImportKeyViewController.h"
#import "ApplicationCoordinator.h"
#import "StartNavigationCoordinator.h"

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
    __block __typeof (self) weakSelf = self;
    
    [weakSelf performSegueWithIdentifier:@"createWalletName" sender:nil];
}

- (void)createAndShowMainVC
{

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

#pragma mark - Unwing seque

-(IBAction)unwingToStart:(UIStoryboardSegue *)segue {
    StartNavigationCoordinator* coordinator = (StartNavigationCoordinator*)self.navigationController;
    [coordinator clear];
}

@end
