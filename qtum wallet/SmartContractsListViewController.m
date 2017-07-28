//
//  SmartContractsListViewController.m
//  qtum wallet
//
//  Created by Vladimir Lebedevich on 30.05.17.
//  Copyright © 2017 PixelPlex. All rights reserved.
//

#import "SmartContractsListViewController.h"
#import "SmartContractListItemCell.h"

@interface SmartContractsListViewController () <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation SmartContractsListViewController

@synthesize delegate, contracts;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self.delegate didSelectContractWithIndexPath:indexPath withContract:self.contracts[indexPath.row]];
}


#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.contracts.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    Contract* contract = self.contracts[indexPath.row];
    SmartContractListItemCell* cell = [tableView dequeueReusableCellWithIdentifier:smartContractListItemCellIdentifire];
    cell.contractName.text = contract.localName;
    cell.typeIdentifire.text = [contract.templateModel.templateTypeString uppercaseString];
    cell.creationDate.text = contract.creationDateString;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 31;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 45;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UITableViewCell *headerCell = [tableView dequeueReusableCellWithIdentifier:@"ContractsHeaderView"];
    return  headerCell;
}

- (IBAction)didPressedBackAction:(id)sender {
    [self.delegate didPressedBack];
}

@end
