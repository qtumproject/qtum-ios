//
//  SubscribeTokenCoordinator.m
//  qtum wallet
//
//  Created by Никита Федоренко on 03.03.17.
//  Copyright © 2017 PixelPlex. All rights reserved.
//

#import "SubscribeTokenCoordinator.h"
#import "SubscribeTokenViewController.h"
#import "SubscribeTokenDataSourceDelegate.h"
#import "AddNewTokensViewController.h"
#import "QRCodeViewController.h"

@interface SubscribeTokenCoordinator () <QRCodeViewControllerDelegate>

@property (strong, nonatomic) UINavigationController* navigationController;
@property (weak, nonatomic) AddNewTokensViewController* addNewTokenViewController;
@property (weak, nonatomic) SubscribeTokenViewController* subscribeTokenViewController;
@property (weak, nonatomic) QRCodeViewController* qrCodeViewController;

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
    self.subscribeTokenViewController = controller;
}

-(void)showAddnewTokensViewController{
    AddNewTokensViewController* controller = (AddNewTokensViewController*)[[ControllersFactory sharedInstance] createAddNewTokenViewController];
    [self.navigationController pushViewController:controller animated:YES];
    controller.delegate = self;
    self.addNewTokenViewController = controller;
}

-(void)showScanViewController{
    QRCodeViewController *controller = (QRCodeViewController*)[[ControllersFactory sharedInstance] createQRCodeViewController];
    [self.navigationController pushViewController:controller animated:YES];
    controller.delegate = self;
    self.qrCodeViewController = controller;
}

#pragma mark - SubscribeTokenCoordinatorDelegate

-(void)didBackButtonPressed{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

-(void)didAddButtonPressed{
    [self showAddnewTokensViewController];
}

-(void)didScanButtonPressed{
    [self showScanViewController];
}

-(void)didBackButtonPressedFromAddNewToken{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - QRCodeViewControllerDelegate

- (void)qrCodeScanned:(NSDictionary *)dictionary{
    [self.navigationController popToViewController:self.subscribeTokenViewController animated:YES];
}

- (void)backButtonPressed{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
