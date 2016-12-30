//
//  StartNavigationCoordinator.m
//  qtum wallet
//
//  Created by Никита Федоренко on 27.12.16.
//  Copyright © 2016 Designsters. All rights reserved.
//

#import "StartNavigationCoordinator.h"
#import "PinViewController.h"
#import "CreatePinViewController.h"
#import "ControllersFactory.h"
#import "UIViewController+Extension.h"

@interface StartNavigationCoordinator () <UIGestureRecognizerDelegate>

@property (strong,nonatomic) NSString* firstPin;
@property (strong,nonatomic) NSString* walletName;
@property (strong,nonatomic) NSString* walletPin;
@property (strong,nonatomic) NSArray* walletBrainKey;

@end

@implementation StartNavigationCoordinator

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationBar.hidden = YES;
    self.interactivePopGestureRecognizer.delegate = self;
    self.interactivePopGestureRecognizer.enabled = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Navigation


-(void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated{
    if ([viewController isKindOfClass:[CreatePinViewController class]]) {
        CreatePinViewController* controller = (CreatePinViewController*)viewController;
        controller.delegate = self;
    }
    [super pushViewController:viewController animated:animated];
}

#pragma mark - PinCoordinator

-(void)confirmPin:(NSString*)pin andCompletision:(void(^)(BOOL success)) completision{
    if (self.firstPin && [self.firstPin isEqualToString:pin]) {
        completision(YES);
        [self addPin:pin];
        [self createKeyChainEndGoToExport];
    } else if(self.firstPin) {
        completision(NO);
    } else {
        self.firstPin = pin;
        [self goToRepeateStep];
    }
}

-(void)goToRepeateStep{
    CreatePinViewController *controller = (CreatePinViewController*)[UIViewController controllerInStoryboard:@"Start" withIdentifire:@"RepeatePinViewController"];
    [self pushViewController:controller animated:YES];
}

-(void)goToRepeateExportBrainKey{
    CreatePinViewController *controller = (CreatePinViewController*)[UIViewController controllerInStoryboard:@"Start" withIdentifire:@"ExportBrainKeyViewController"];
    [self pushViewController:controller animated:YES];
}

-(void)createKeyChainEndGoToExport{
    __weak typeof (self) weakSelf = self;
    [SVProgressHUD show];
    [[WalletManager sharedInstance] createNewWalletWithName:self.walletName pin:self.walletPin withSuccessHandler:^(Wallet *newWallet) {
        [SVProgressHUD showSuccessWithStatus:@"Done"];
        [[WalletManager sharedInstance] storePin:weakSelf.walletPin];
        [weakSelf goToRepeateExportBrainKey];
    } andFailureHandler:^{
        [SVProgressHUD showErrorWithStatus:@"Some Error"];
    }];
}


#pragma mark - 

-(void)addWalletName:(NSString*)name {
    self.walletName = name;
}

-(void)addPin:(NSString*)pin {
    self.walletPin = pin;
}

-(void)addBrainKey:(NSArray*)key {
    self.walletBrainKey = key;
}

-(void)clear{
    self.firstPin = nil;
    self.walletBrainKey = nil;
    self.walletName = nil;
    self.walletPin = nil;
}

@end
