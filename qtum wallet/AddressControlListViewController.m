//
//  AddressControlListViewController.m
//  qtum wallet
//
//  Created by Vladimir Lebedevich on 02.08.17.
//  Copyright © 2017 PixelPlex. All rights reserved.
//

#import "AddressControlListViewController.h"
#import "AddressControlCell.h"
#include "NSNumber+Comparison.h"

@interface AddressControlListViewController ()

@property (weak, nonatomic) IBOutlet UITableView *tableVew;

@end

@implementation AddressControlListViewController

@synthesize delegate, addressesValueHashTable;

- (void)viewDidLoad {
    [super viewDidLoad];
}

-(void)reloadData {
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tableVew reloadData];
    });
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
    [self.delegate didPressCellAtIndexPath:indexPath withAddress:self.addressesValueHashTable.allKeys[indexPath.row]];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.addressesValueHashTable.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    AddressControlCell *cell = [tableView dequeueReusableCellWithIdentifier:addressControlCellIdentifire];
    NSString* key = self.addressesValueHashTable.allKeys[indexPath.row];
    cell.addressLabel.text = key;
    cell.valueLabel.text = [NSString stringWithFormat:@"%@",[self.addressesValueHashTable[key] roundedNumberWithScale:5]];
    return cell;
}

@end
