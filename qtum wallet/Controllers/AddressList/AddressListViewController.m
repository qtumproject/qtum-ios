//
//  AddressListViewController.m
//  qtum wallet
//
//  Created by Sharaev Vladimir on 18.11.16.
//  Copyright © 2016 QTUM. All rights reserved.
//

#import "AddressListViewController.h"
#import "AddressTableViewCell.h"
#import "KeyViewController.h"

@interface AddressListViewController () <UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

- (IBAction)backButtonPressed:(id) sender;

- (IBAction)createNewButtonWasPressed:(id) sender;
@end

@implementation AddressListViewController

- (void)viewDidLoad {
	[super viewDidLoad];

	self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
}

- (IBAction)backButtonPressed:(id) sender {
	[self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Actions

- (IBAction)createNewButtonWasPressed:(id) sender {
	[SLocator.popUpsManager showLoaderPopUp];

}

#pragma mark - UITableViewDataSource, UITableViewDelegate

- (NSInteger)tableView:(UITableView *) tableView numberOfRowsInSection:(NSInteger) section {
	return 2;
}

- (UITableViewCell *)tableView:(UITableView *) tableView cellForRowAtIndexPath:(NSIndexPath *) indexPath {
	AddressTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AddressTableViewCell"];
	if (!cell) {
		cell = [[AddressTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"AddressTableViewCell"];
	}

	return cell;
}

- (void)tableView:(UITableView *) tableView didSelectRowAtIndexPath:(NSIndexPath *) indexPath {
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - ImportKeyViewControllerDelegate

- (void)addressImported {
	[self.tableView reloadData];
}

#pragma mark - Methods

- (void)createAndPresentPublicKeyVCWithKey:(BTCKey *) key {
	UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
	KeyViewController *vc = (KeyViewController *)[mainStoryboard instantiateViewControllerWithIdentifier:@"KeyViewController"];
	vc.key = key;

	[self presentViewController:vc animated:YES completion:nil];
}

#pragma mark -

- (void)prepareForSegue:(UIStoryboardSegue *) segue sender:(id) sender {
}

@end
