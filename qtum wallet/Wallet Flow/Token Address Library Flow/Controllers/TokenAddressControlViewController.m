//
//  TokenAddressControlViewController.m
//  qtum wallet
//
//  Created by Vladimir Lebedevich on 03.08.17.
//  Copyright © 2017 QTUM. All rights reserved.
//

#import "TokenAddressControlViewController.h"
#import "TokenAddressContolCell.h"

@interface TokenAddressControlViewController ()

@property (weak, nonatomic) IBOutlet UILabel *titleTextLabel;
@property (weak, nonatomic) IBOutlet UITableView *tableVew;

@end

@implementation TokenAddressControlViewController

@synthesize delegate, arrayWithAddressesAndBalances, symbol;


#pragma mark - Lifecycle

- (void)viewDidLoad {
	[super viewDidLoad];
    [self configLocalization];
}

- (void)viewDidAppear:(BOOL) animated {

	[super viewDidAppear:animated];
	[self.tableVew layoutSubviews];
}

#pragma mark - Configuration

-(void)configLocalization {
    self.titleTextLabel.text = NSLocalizedString(@"Manage Addresses", @"Token Manage Addresses Controllers Title");
}

- (void)reloadData {

	dispatch_async (dispatch_get_main_queue (), ^{
		[self.tableVew reloadData];
	});
}

#pragma mark - Actions

- (IBAction)actionBack:(id) sender {

	[self.delegate didBackPress];
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *) tableView heightForRowAtIndexPath:(NSIndexPath *) indexPath {

	return 46;
}

- (void)tableView:(UITableView *) tableView didSelectRowAtIndexPath:(NSIndexPath *) indexPath {

	[tableView deselectRowAtIndexPath:indexPath animated:YES];
	[self.delegate didPressCellAtIndexPath:indexPath withAddress:self.arrayWithAddressesAndBalances[indexPath.row].addressString];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *) tableView numberOfRowsInSection:(NSInteger) section {

	return self.arrayWithAddressesAndBalances.count;
}

- (UITableViewCell *)tableView:(UITableView *) tableView cellForRowAtIndexPath:(NSIndexPath *) indexPath {

	TokenAddressContolCell *cell = [tableView dequeueReusableCellWithIdentifier:tokenAddressControlCellIdentifire];
	ContracBalancesObject *addressObject = self.arrayWithAddressesAndBalances[indexPath.row];
	cell.addressLabel.text = addressObject.addressString;
	cell.valueLabel.text = addressObject.longBalanceStringBalance;
	cell.symbolLabel.text = self.symbol;
	cell.shortBalance = addressObject.shortBalanceStringBalance;
	[cell setNeedsLayout];
	return cell;
}

@end
