//
//  AuthCoordinator.m
//  qtum wallet
//
//  Created by Vladimir Lebedevich on 21.02.17.
//  Copyright © 2017 Designsters. All rights reserved.
//

#import "AuthCoordinator.h"
#import "FirstAuthViewController.h"
#import "WalletNameViewController.h"
#import "RestoreWalletViewController.h"
#import "RepeateViewController.h"
#import "CreatePinViewController.h"
#import "ExportWalletBrandKeyViewController.h"

@interface AuthCoordinator ()

@property (nonatomic, strong) UINavigationController *navigationController;
@property (nonatomic, weak) FirstAuthViewController *firstController;
@property (nonatomic, weak) WalletNameViewController *createWalletController;
@property (nonatomic, weak) RestoreWalletViewController *restoreWalletController;
@property (nonatomic, weak) CreatePinViewController *createPinController;
@property (nonatomic, weak) RepeateViewController *repeatePinController;
@property (nonatomic, weak) ExportWalletBrandKeyViewController *exportWalletController;
@property (copy, nonatomic) NSString* firstPin;
@property (copy, nonatomic) NSString* walletName;
@property (copy, nonatomic) NSString* walletPin;
@property (copy, nonatomic) NSArray* walletBrainKey;
@property (assign, nonatomic, getter=isWalletExported) BOOL walletExported;


@end

@implementation AuthCoordinator

-(instancetype)initWithNavigationViewController:(UINavigationController*)navigationController{
    self = [super init];
    if (self) {
        _navigationController = navigationController;
    }
    return self;
}
    
-(void)start{
    [self resetToRootAnimated:NO];
}

-(void)resetToRootAnimated:(BOOL)animated{
    FirstAuthViewController* controller = (FirstAuthViewController*)[[ControllersFactory sharedInstance] createFirstAuthController];
    controller.delegate = self;
    animated ? [self.navigationController popToRootViewControllerAnimated:YES] : [self.navigationController setViewControllers:@[controller]];
    self.firstController = controller;
}

-(void)gotoCreateWallet{
    WalletNameViewController* controller = (WalletNameViewController*)[[ControllersFactory sharedInstance] createWalletNameCreateController];
    controller.delegate = self;
    [self.navigationController pushViewController:controller animated:YES];
    self.createWalletController = controller;
}

-(void)gotoRestoreWallet{
    RestoreWalletViewController* controller = (RestoreWalletViewController*)[[ControllersFactory sharedInstance] createRestoreWalletController];
    controller.delegate = self;
    [self.navigationController pushViewController:controller animated:YES];
    self.restoreWalletController = controller;
}

-(void)gotoCreatePin{
    //[self resetToRootAnimated:NO];
    
    CreatePinViewController* controller = (CreatePinViewController*)[[ControllersFactory sharedInstance] createCreatePinController];
    controller.delegate = self;
    [self.navigationController pushViewController:controller animated:YES];
    self.createPinController = controller;
}

-(void)gotoRepeatePin{
    RepeateViewController* controller = (RepeateViewController*)[[ControllersFactory sharedInstance] createRepeatePinController];
    controller.delegate = self;
    [self.navigationController pushViewController:controller animated:YES];
    self.repeatePinController = controller;
}

-(void)gotoExportWallet{
    ExportWalletBrandKeyViewController* controller = (ExportWalletBrandKeyViewController*)[[ControllersFactory sharedInstance] createExportWalletBrandKeyViewController];
    controller.delegate = self;
    [self.navigationController pushViewController:controller animated:YES];
    self.exportWalletController = controller;
}

-(void)gotoCreatePinAgain{
    [self resetToRootAnimated:YES];
    [self gotoCreatePin];
}

#pragma mark - AuthCoordinatorDelegate

-(void)didCreatedWalletName:(NSString*)name{
    self.walletName = name;
    [self gotoCreatePin];
}

-(void)didEnteredFirstTimePass:(NSString*)pass{
    self.walletPin = pass;
    [self gotoRepeatePin];
}

-(void)didEnteredSecondTimePass:(NSString*)pass{
    __weak __typeof(self)weakSelf = self;
    if ([self.walletPin isEqualToString:pass] && !self.isWalletExported) {
        [weakSelf.repeatePinController startCreateWallet];
        [[WalletManager sharedInstance] createNewWalletWithName:self.walletName pin:self.walletPin withSuccessHandler:^(Wallet *newWallet) {
            [[WalletManager sharedInstance] storePin:weakSelf.walletPin];
            [weakSelf.repeatePinController endCreateWalletWithError:nil];
        } andFailureHandler:^{
            [weakSelf.repeatePinController endCreateWalletWithError:[NSError new]];
        }];
    } else if ([self.walletPin isEqualToString:pass]){
        [[WalletManager sharedInstance] storePin:weakSelf.walletPin];
        [weakSelf.repeatePinController endCreateWalletWithError:nil];
    }else {
        self.walletPin = nil;
        [self gotoCreatePinAgain];
    }
}

-(void)didRestorePressedWithWords:(NSArray*)words{
    __weak __typeof(self)weakSelf = self;
    [[WalletManager sharedInstance] importWalletWithName:@"" pin:@"" seedWords:words withSuccessHandler:^(Wallet *newWallet) {
        [weakSelf.restoreWalletController restoreSucces];
    } andFailureHandler:^{
        [weakSelf.restoreWalletController restoreFailed];
    }];
}

-(void)didCreateWalletPressedFromRestore{
    
}

-(void)restoreWalletCancelDidPressed{
    [self resetToRootAnimated:YES];
}

-(void)didCreateWallet{
    [self gotoExportWallet];
}

-(void)didRestoreWallet{
    self.walletExported = YES;
    [self gotoCreateWallet];
}

-(void)cancelCreateWallet{
    [self resetToRootAnimated:YES];
    self.walletExported = NO;
}

-(void)restoreButtonPressed{
    [self gotoRestoreWallet];
}

-(void)createNewButtonPressed{
    [self gotoCreateWallet];
}

-(void)didExportWallet{
    if ([self.delegate respondsToSelector:@selector(coordinatorDidAuth:)]) {
        [self.delegate coordinatorDidAuth:self];
    }
}


@end
