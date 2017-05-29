//
//  SubscribeTokenCoordinator.m
//  qtum wallet
//
//  Created by Vladimir Lebedevich on 03.03.17.
//  Copyright © 2017 Designsters. All rights reserved.
//

#import "SubscribeTokenCoordinator.h"
#import "SubscribeTokenViewController.h"
#import "SubscribeTokenDataSourceDelegate.h"
#import "AddNewTokensViewController.h"
#import "QRCodeViewController.h"
#import "ContractManager.h"

@interface SubscribeTokenCoordinator () <QRCodeViewControllerDelegate>

@property (strong, nonatomic) UINavigationController* navigationController;
@property (weak, nonatomic) SubscribeTokenViewController* subscribeViewController;

@end

@implementation SubscribeTokenCoordinator

-(instancetype)initWithNavigationController:(UINavigationController*)navigationController{
    self = [super init];
    if (self) {
        _navigationController = navigationController;
    }
    return self;
}

#pragma mark - Coordinatorable

-(void)start{
    SubscribeTokenViewController* controller = (SubscribeTokenViewController*)[[ControllersFactory sharedInstance] createSubscribeTokenViewController];
    [self.navigationController pushViewController:controller animated:YES];
    controller.delegate = self;
    controller.delegateDataSource = [SubscribeTokenDataSourceDelegate new];
    controller.delegateDataSource.tokensArray = (NSArray <Spendable>*)[[TokenManager sharedInstance] gatAllTokens];
    self.subscribeViewController = controller;
}

#pragma mark - SubscribeTokenCoordinatorDelegate

-(void)didBackButtonPressed{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

-(void)didAddNewPressed {
    AddNewTokensViewController* controller = (AddNewTokensViewController*)[[ControllersFactory sharedInstance] createAddNewTokensViewController];
    controller.delegate = self;
    [self.navigationController pushViewController:controller animated:YES];
}

-(void)didBackButtonPressedFromAddNewToken{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)didScanButtonPressed {
    QRCodeViewController* controller = (QRCodeViewController*)[[ControllersFactory sharedInstance] createQRCodeViewControllerForSubscribe];
    controller.delegate = self;
    [self.navigationController pushViewController:controller animated:YES];
}

#pragma mark - QRCodeViewControllerDelegate

- (void)showNextVC {
    
}

- (void)backButtonPressed{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)qrCodeScanned:(NSDictionary *)dictionary {
    [self.navigationController popViewControllerAnimated:YES];
    if ([dictionary[EXPORT_CONTRACTS_TOKENS_KEY] isKindOfClass:[NSArray class]]) {
        for (NSString* contractAddress in dictionary[EXPORT_CONTRACTS_TOKENS_KEY]) {
            [[TokenManager sharedInstance] addNewTokenWithContractAddress:contractAddress];
        }
    }
}

-(void)didAddNewTokenWithAddress:(NSString*) address{
    if (address) {
        [[TokenManager sharedInstance] addNewTokenWithContractAddress:address];
    }
}
@end
