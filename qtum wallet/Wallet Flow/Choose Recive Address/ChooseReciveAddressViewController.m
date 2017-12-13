//
//  ChooseReciveAddressViewController.m
//  qtum wallet
//
//  Created by Vladimir Lebedevich on 23.08.17.
//  Copyright © 2017 QTUM. All rights reserved.
//

#import "ChooseReciveAddressViewController.h"
#import "ChooseAddressReciveCell.h"

@interface ChooseReciveAddressViewController ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UILabel *titleTextLabel;

@end

@implementation ChooseReciveAddressViewController

@synthesize addresses, delegate, prevAddress;

#pragma mark - Lifecycle

- (void)viewDidLoad {
	[super viewDidLoad];
}

#pragma mark - Configuration

-(void)configLocalization {
    
    self.titleTextLabel.text = NSLocalizedString(@"Addresses", @"Choose Recive Address Controller Title");
}

#pragma mark - Actions

- (IBAction)didPressBackAction:(id) sender {

	[self.delegate didBackPressed];
}

- (void)reloadData {

	dispatch_async (dispatch_get_main_queue (), ^{
		[self.tableView reloadData];
	});
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *) tableView heightForRowAtIndexPath:(NSIndexPath *) indexPath {

	return 46;
}

- (void)tableView:(UITableView *) tableView didSelectRowAtIndexPath:(NSIndexPath *) indexPath {

	[self.delegate didChooseAddress:self.addresses[indexPath.row]];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *) tableView numberOfRowsInSection:(NSInteger) section {

	return self.addresses.count;
}

- (UITableViewCell *)tableView:(UITableView *) tableView cellForRowAtIndexPath:(NSIndexPath *) indexPath {

	ChooseAddressReciveCell *cell = [tableView dequeueReusableCellWithIdentifier:chooseAddressReciveCellIdentifire];

	cell.addressLabel.text = self.addresses[indexPath.row];

	if ([self.addresses[indexPath.row] isEqualToString:self.prevAddress]) {
		[tableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
	}

	return cell;
}

@end
