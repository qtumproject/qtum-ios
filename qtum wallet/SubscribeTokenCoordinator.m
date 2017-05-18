//
//  SubscribeTokenCoordinator.m
//  qtum wallet
//
//  Created by Никита Федоренко on 03.03.17.
//  Copyright © 2017 Designsters. All rights reserved.
//

#import "SubscribeTokenCoordinator.h"
#import "SubscribeTokenViewController.h"
#import "SubscribeTokenDataSourceDelegate.h"
#import "AddNewTokensViewController.h"

@interface SubscribeTokenCoordinator ()

@property (strong, nonatomic) UINavigationController* navigationController;
@property (weak, nonatomic) AddNewTokensViewController* addNewTokenViewController;
@property (weak, nonatomic) SubscribeTokenViewController* subscribeTokenViewController;

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

#pragma mark - SubscribeTokenCoordinatorDelegate

-(void)didBackButtonPressed{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

-(void)didAddButtonPressed{
    [self showAddnewTokensViewController];
}

-(void)didBackButtonPressedFromAddNewToken{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
