//
//  SubscribeTokenCoordinator.m
//  qtum wallet
//
//  Created by Vladimir Lebedevich on 03.03.17.
//  Copyright © 2017 PixelPlex. All rights reserved.
//

#import "SubscribeTokenCoordinator.h"
#import "SubscribeTokenViewController.h"
#import "SubscribeTokenDataDisplayManagerDark.h"
#import "AddNewTokensViewController.h"
#import "QRCodeViewController.h"
#import "ContractInterfaceManager.h"

@interface SubscribeTokenCoordinator () <SubscribeTokenOutputDelegate>

@property (strong, nonatomic) UINavigationController* navigationController;
@property (weak, nonatomic) id <SubscribeTokenOutput> subscribeTokenOutput;

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
    
    NSObject <SubscribeTokenOutput>* output = (NSObject <SubscribeTokenOutput>*)[[ControllersFactory sharedInstance] createSubscribeTokenViewController];
    output.delegate = self;
    output.delegateDataSource = [[TableSourcesFactory sharedInstance] createSubscribeTokenDataDisplayManager];
    output.tokensArray = [self sortingContractsByDate:[[ContractManager sharedInstance] allTokens]];
    output.delegateDataSource.delegate = output;
    self.subscribeTokenOutput = output;
    [self.navigationController pushViewController:[output toPresent] animated:YES];
}

#pragma mark - SubscribeTokenOutputDelegate

-(void)didBackButtonPressed{
    [self.navigationController popToRootViewControllerAnimated:YES];
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


@end
