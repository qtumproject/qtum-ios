//
//  AddressControlListViewController.m
//  qtum wallet
//
//  Created by Vladimir Lebedevich on 02.08.17.
//  Copyright © 2017 PixelPlex. All rights reserved.
//

#import "AddressControlListViewController.h"
#import "AddressControllCell.h"

@interface AddressControlListViewController ()

@property (weak, nonatomic) IBOutlet UITableView *tableVew;

@end

@implementation AddressControlListViewController

@synthesize delegate, addresses;

- (void)viewDidLoad {
    [super viewDidLoad];
}

#pragma mark - Actions

- (IBAction)actionBack:(id)sender {
    [self.delegate didBackPress];
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 46;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self.delegate didPressCellAtIndexPath:indexPath];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.addresses.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    AddressControllCell *cell = [tableView dequeueReusableCellWithIdentifier:addressControllCellIdentifire];
    cell.addressLabel.text = self.addresses[indexPath.row];
    return cell;
}

@end
