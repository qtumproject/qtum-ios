//
//  AddNewTokensViewController.m
//  qtum wallet
//
//  Created by Sharaev Vladimir on 18.05.17.
//  Copyright © 2017 Designsters. All rights reserved.
//

#import "AddNewTokensViewController.h"
#import "SubscribeTokenCoordinator.h"

@interface AddNewTokensViewController ()

@property (weak, nonatomic) IBOutlet UITextField *tokenAddressTextField;

- (IBAction)acitonBack:(id)sender;
- (IBAction)actionAddTokens:(id)sender;

@end

@implementation AddNewTokensViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (IBAction)acitonBack:(id)sender
{
    [self.delegate didBackButtonPressed];
}

- (IBAction)actionAddTokens:(id)sender
{
    
}

@end
