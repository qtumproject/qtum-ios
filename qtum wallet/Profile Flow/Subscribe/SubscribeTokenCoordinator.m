//
//  SubscribeTokenCoordinator.m
//  qtum wallet
//
//  Created by Vladimir Lebedevich on 03.03.17.
//  Copyright © 2017 QTUM. All rights reserved.
//

#import "SubscribeTokenCoordinator.h"
#import "SubscribeTokenViewController.h"

@interface SubscribeTokenCoordinator () <SubscribeTokenOutputDelegate>

@property (strong, nonatomic) UINavigationController *navigationController;
@property (weak, nonatomic) id <SubscribeTokenOutput> subscribeTokenOutput;

@end

@implementation SubscribeTokenCoordinator

- (instancetype)initWithNavigationController:(UINavigationController *) navigationController {
	self = [super init];
	if (self) {
		_navigationController = navigationController;
	}
	return self;
}

#pragma mark - Private Methods

- (NSArray <Contract *> *)sortingContractsByDate:(NSArray <Contract *> *) contracts {
	NSArray <Contract *> *sortedArray;
	sortedArray = [contracts sortedArrayUsingComparator:^NSComparisonResult(Contract *a, Contract *b) {
		NSDate *first = [(Contract *)a creationDate];
		NSDate *second = [(Contract *)b creationDate];
		return [first compare:second];
	}];
	return sortedArray;
}

#pragma mark - Coordinatorable

- (void)start {

	NSObject <SubscribeTokenOutput> *output = (NSObject <SubscribeTokenOutput> *)[SLocator.controllersFactory createSubscribeTokenViewController];
	output.delegate = self;
	output.delegateDataSource = [SLocator.tableSourcesFactory createSubscribeTokenDataDisplayManager];
	output.tokensArray = [self sortingContractsByDate:[SLocator.contractManager allTokens]];
	output.delegateDataSource.delegate = output;
	self.subscribeTokenOutput = output;
	[self.navigationController pushViewController:[output toPresent] animated:YES];
}

#pragma mark - SubscribeTokenOutputDelegate

- (void)didBackButtonPressed {
	[self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)didSelectContract:(Contract *) contract {

	contract.isActive = !contract.isActive;
	if (contract.isActive) {
		[SLocator.contractManager startObservingForSpendable:contract];
	} else {
		[SLocator.contractManager stopObservingForSpendable:contract];
	}
	[SLocator.contractManager spendableDidChange:contract];
}


@end
