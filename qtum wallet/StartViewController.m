//
//  StartViewController.m
//  qtum wallet
//
//  Created by Sharaev Vladimir on 17.11.16.
//  Copyright © 2016 Designsters. All rights reserved.
//

#import "StartViewController.h"
#import "KeysManager.h"

@interface StartViewController ()

@property (weak, nonatomic) IBOutlet UIButton *createButton;
@property (weak, nonatomic) IBOutlet UIButton *restoreButton;

- (IBAction)createNewButtonWasPressed:(id)sender;
- (IBAction)restoreButtonWasPressed:(id)sender;

@end

@implementation StartViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.restoreButton.backgroundColor = [customBlueColor() colorWithAlphaComponent:0.6f];

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
    [[KeysManager sharedInstance] createNewKey];
    [KeysManager sharedInstance].keyRegistered = ^(BOOL registered){
        if (registered) {
            [SVProgressHUD showSuccessWithStatus:@"Done"];
            [weakSelf createAndShowMainVC];
        }else{
            [SVProgressHUD showErrorWithStatus:@"Some Error"];
        }
        [KeysManager sharedInstance].keyRegistered = nil;
    };
}

- (IBAction)restoreButtonWasPressed:(id)sender
{
    
}

- (void)createAndShowMainVC
{
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UIViewController *vc = [mainStoryboard instantiateViewControllerWithIdentifier:@"MainViewController"];
    [self presentViewController:vc animated:YES completion:nil];
}
@end
