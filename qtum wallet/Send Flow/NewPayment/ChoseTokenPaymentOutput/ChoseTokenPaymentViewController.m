//
//  ChoseTokenPaymentViewController.m
//  qtum wallet
//
//  Created by Vladimir Lebedevich on 25.05.17.
//  Copyright © 2017 QTUM. All rights reserved.
//

#import "ChoseTokenPaymentViewController.h"

@interface ChoseTokenPaymentViewController ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation ChoseTokenPaymentViewController

- (void)viewDidLoad {
	[super viewDidLoad];
	self.tableView.delegate = self.delegateDataSource;
	self.tableView.dataSource = self.delegateDataSource;
}

- (void)viewWillAppear:(BOOL) animated {

	[super viewWillAppear:animated];
	[self.tableView reloadData];
}

- (void)updateWithTokens:(NSArray <Contract *> *) tokens {

	self.delegateDataSource.tokens = tokens;

	__weak __typeof (self) weakSelf = self;

	dispatch_async (dispatch_get_main_queue (), ^{

		[weakSelf.tableView reloadData];
	});
}

- (IBAction)didPressedBackAction:(id) sender {

	[self.delegate didPressedBackAction];
}

@end
