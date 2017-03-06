//
//  CreateTokenStep2ViewController.m
//  qtum wallet
//
//  Created by Никита Федоренко on 03.03.17.
//  Copyright © 2017 Designsters. All rights reserved.
//

#import "CreateTokenStep2ViewController.h"
#import "CreateTokenCoordinator.h"

@interface CreateTokenStep2ViewController ()

@property (weak, nonatomic) IBOutlet UISwitch *freazingOfAssetsSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *autoScrollingAndBuingSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *AutorefillSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *proofOfWorkSwitch;
@property (assign, nonatomic)BOOL freazingOfAssets;
@property (assign, nonatomic)BOOL autoScrollingAndBuing;
@property (assign, nonatomic)BOOL Autorefill;
@property (assign, nonatomic)BOOL proofOfWork;


@end

@implementation CreateTokenStep2ViewController

#pragma mark - Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Actions

- (IBAction)actionNext:(id)sender {
    NSDictionary* param = @{@"freazingOfAssets" : @(self.freazingOfAssets),
                            @"autoScrollingAndBuing" : @(self.autoScrollingAndBuing),
                            @"autorefill" : @(self.Autorefill),
                            @"proofOfWork" : @(self.proofOfWork)
                            };
    [self.delegate createStepTwoNextDidPressedWithParam:param];
}

- (IBAction)actionBack:(id)sender {
    [self.delegate createStepTwoBackDidPressed];
}

- (IBAction)actionSwitchTapped:(UISwitch*) sender {
    if ([sender isEqual:self.freazingOfAssetsSwitch]) {
        self.freazingOfAssets = sender.isOn;
    } else if([sender isEqual:self.autoScrollingAndBuingSwitch]){
        self.autoScrollingAndBuing = sender.isOn;
    } else if([sender isEqual:self.AutorefillSwitch]){
        self.Autorefill = sender.isOn;
    } else if([sender isEqual:self.proofOfWorkSwitch]){
        self.proofOfWork = sender.isOn;
    }
}


@end
