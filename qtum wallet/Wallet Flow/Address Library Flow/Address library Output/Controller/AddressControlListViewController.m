//
//  AddressControlListViewController.m
//  qtum wallet
//
//  Created by Vladimir Lebedevich on 02.08.17.
//  Copyright © 2017 QTUM. All rights reserved.
//

#import "AddressControlListViewController.h"
#import "AddressControlCell.h"

@interface AddressControlListViewController ()

@property (weak, nonatomic) IBOutlet UILabel *titleTextLabel;
@property (weak, nonatomic) IBOutlet UITableView *tableVew;

@end

@implementation AddressControlListViewController

@synthesize delegate, arrayWithAddressesAndBalances;

- (void)viewDidLoad {
	[super viewDidLoad];
    [self configLocalization];
}

#pragma mark - Configuration

-(void)configLocalization {
    
    self.titleTextLabel.text = NSLocalizedString(@"Manage Addresses", @"Manage Addresses Controllers Title");
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

	AddressControlCell *cell = [tableView dequeueReusableCellWithIdentifier:addressControlCellIdentifire];
	WalletBalancesObject *balanceObject = self.arrayWithAddressesAndBalances[indexPath.row];
	cell.addressLabel.text = balanceObject.addressString;
	cell.valueLabel.text = [[[QTUMBigNumber decimalWithString:balanceObject.longBalanceStringBalance] roundedNumberWithScale:5] stringValue];
	return cell;
}

@end
