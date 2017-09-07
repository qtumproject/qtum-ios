//
//  TokenAddressControlViewController.m
//  qtum wallet
//
//  Created by Vladimir Lebedevich on 03.08.17.
//  Copyright © 2017 PixelPlex. All rights reserved.
//

#import "TokenAddressControlViewController.h"
#import "TokenAddressContolCell.h"
#import "NSNumber+Format.h"

@interface TokenAddressControlViewController ()

@property (weak, nonatomic) IBOutlet UITableView *tableVew;

@end

@implementation TokenAddressControlViewController

@synthesize delegate, addressesValueHashTable, symbol;

- (void)viewDidLoad {
    [super viewDidLoad];
}

-(void)viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];
    [self.tableVew layoutSubviews];
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
    
    TokenAddressContolCell *cell = [tableView dequeueReusableCellWithIdentifier:tokenAddressControlCellIdentifire];
    NSString* key = self.addressesValueHashTable.allKeys[indexPath.row];
    cell.addressLabel.text = key;
    cell.valueLabel.text = [NSString stringWithFormat:@"%@",self.addressesValueHashTable[key]];
    cell.symbolLabel.text = self.symbol;
    cell.shortBalance = [self.addressesValueHashTable[key] shortFormatOfNumber];
    [cell setNeedsLayout];
    return cell;
}

@end
