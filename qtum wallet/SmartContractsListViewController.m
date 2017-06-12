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

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self.delegate didSelectContractWithIndexPath:indexPath withContract:self.contracts[indexPath.row]];
}

- (void)tableView:(UITableView *)tableView didHighlightRowAtIndexPath:(NSIndexPath *)indexPath{
    
    SmartContractListItemCell* cell = (SmartContractListItemCell*)[tableView cellForRowAtIndexPath:indexPath];
    cell.typeIdentifire.backgroundColor =
    cell.creationDate.textColor =
    cell.contractName.textColor = customBlackColor();
    
    cell.typeIdentifire.textColor = customRedColor();
}

- (void)tableView:(UITableView *)tableView didUnhighlightRowAtIndexPath:(NSIndexPath *)indexPath {
    
    SmartContractListItemCell* cell = (SmartContractListItemCell*)[tableView cellForRowAtIndexPath:indexPath];
    cell.typeIdentifire.backgroundColor =
    cell.creationDate.textColor =
    cell.contractName.textColor = customBlueColor();
    
    cell.typeIdentifire.textColor = customBlackColor();
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
