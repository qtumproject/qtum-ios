//
//  SubscribeTokenCoordinator.m
//  qtum wallet
//
//  Created by Vladimir Lebedevich on 03.03.17.
//  Copyright © 2017 PixelPlex. All rights reserved.
//

#import "SubscribeTokenCoordinator.h"
#import "SubscribeTokenViewController.h"
#import "SubscribeTokenDataSourceDelegate.h"
#import "AddNewTokensViewController.h"
#import "QRCodeViewController.h"
#import "ContractInterfaceManager.h"

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

#pragma mark - Private Methods

-(NSArray <Contract*>*)sortingContractsByDate:(NSArray <Contract*>*) contracts {
    NSArray <Contract*>* sortedArray;
    sortedArray = [contracts sortedArrayUsingComparator:^NSComparisonResult(Contract* a, Contract* b) {
        NSDate *first = [(Contract*)a creationDate];
        NSDate *second = [(Contract*)b creationDate];
        return [first compare:second];
    }];
    return sortedArray;
}

#pragma mark - Coordinatorable

-(void)start {
    
    SubscribeTokenViewController* controller = (SubscribeTokenViewController*)[[ControllersFactory sharedInstance] createSubscribeTokenViewController];
    [self.navigationController pushViewController:controller animated:YES];
    controller.delegate = self;
    controller.delegateDataSource = [SubscribeTokenDataSourceDelegate new];
    controller.tokensArray = [self sortingContractsByDate:[[ContractManager sharedInstance] allTokens]];
    controller.delegateDataSource.delegate = controller;
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

-(void)didSelectContract:(Contract*) contract {
    
    contract.isActive = !contract.isActive;
    if (contract.isActive) {
        [[ContractManager sharedInstance] startObservingForSpendable:contract];
    } else {
        [[ContractManager sharedInstance] stopObservingForSpendable:contract];
    }
    [[ContractManager sharedInstance] spendableDidChange:contract];
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
            [[ContractManager sharedInstance] addNewTokenWithContractAddress:contractAddress];
        }
    }
}

-(void)didAddNewTokenWithAddress:(NSString*) address{
    if (address) {
        [[ContractManager sharedInstance] addNewTokenWithContractAddress:address];
    }
}
@end
