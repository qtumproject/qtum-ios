//
//  ChooseReciveAddressViewController.m
//  qtum wallet
//
//  Created by Vladimir Lebedevich on 23.08.17.
//  Copyright © 2017 PixelPlex. All rights reserved.
//

#import "ChooseReciveAddressViewController.h"
#import "ChooseAddressReciveCell.h"

@interface ChooseReciveAddressViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation ChooseReciveAddressViewController

@synthesize addresses, delegate;

- (void)viewDidLoad {
    [super viewDidLoad];
}

#pragma mark - Actions

- (IBAction)didPressBackAction:(id)sender {
    
    [self.delegate didBackPressed];
}

-(void)reloadData {
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tableView reloadData];
    });
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 46;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self.delegate didChooseAddress:self.addresses[indexPath.row]];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.addresses.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ChooseAddressReciveCell *cell = [tableView dequeueReusableCellWithIdentifier:chooseAddressReciveCellIdentifire];

    cell.addressLabel.text = self.addresses[indexPath.row];
    return cell;
}

@end
