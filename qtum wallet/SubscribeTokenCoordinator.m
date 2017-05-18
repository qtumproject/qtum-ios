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
    AddNewTokensViewController* controller = (AddNewTokensViewController*)[[ControllersFactory sharedInstance] createAddNewTokenViewController];
    [self.navigationController pushViewController:controller animated:YES];
    controller.delegate = self;
    self.addNewTokenViewController = controller;
}

#pragma mark - SubscribeTokenCoordinatorDelegate

-(void)didBackButtonPressed{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

@end
