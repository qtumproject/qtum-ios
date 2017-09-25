//
//  SmartContractsListViewController.m
//  qtum wallet
//
//  Created by Vladimir Lebedevich on 30.05.17.
//  Copyright © 2017 QTUM. All rights reserved.
//

#import "SmartContractsListViewController.h"
#import "SmartContractListItemCell.h"

@interface SmartContractsListViewController () <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation SmartContractsListViewController

@synthesize delegate, contracts, smartContractPretendents;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section != 0) {
        
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        [self.delegate didSelectContractWithIndexPath:indexPath withContract:self.contracts[indexPath.row]];
    }
}


#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (section == 0) {
        return self.smartContractPretendents.count;
    } else {
        return self.contracts.count;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        
        return [self configContractPretendentCellWithTableView:tableView ForRowAtIndexPath:indexPath];
    } else {
        
        return [self configContractCellWithTableView:tableView ForRowAtIndexPath:indexPath];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    if (section == 0) {
        return 31;
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 45;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    if (section == 0) {
        UITableViewCell *headerCell = [tableView dequeueReusableCellWithIdentifier:@"ContractsHeaderView"];
        return  headerCell;
    }
    return nil;
}

#pragma mark - Configuration 

-(SmartContractListItemCell*)configContractCellWithTableView:(UITableView *)tableView ForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    Contract* contract = self.contracts[indexPath.row];
    SmartContractListItemCell* cell = [tableView dequeueReusableCellWithIdentifier:smartContractListItemCellIdentifire];
    cell.contractName.text = contract.localName;
    cell.typeIdentifire.text = [contract.templateModel.templateTypeString uppercaseString];
    cell.creationDate.text = contract.creationDateString;
    return cell;
}

-(SmartContractListItemCell*)configContractPretendentCellWithTableView:(UITableView *)tableView ForRowAtIndexPath:(NSIndexPath *)indexPath {
 
    NSDictionary* pretendentDict = self.smartContractPretendents.allValues[indexPath.row];
    TemplateModel* template = pretendentDict[kTemplateModel];
    NSString* localName = pretendentDict[kLocalContractName];
    SmartContractListItemCell* cell = [tableView dequeueReusableCellWithIdentifier:smartContractListItemCellIdentifire];
    cell.contractName.text = localName;
    cell.typeIdentifire.text = [template.templateTypeString uppercaseString];
    cell.creationDate.text = NSLocalizedString(@"Unconfirmed", nil);
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

#pragma mark - Actions

- (IBAction)didPressedBackAction:(id)sender {
    [self.delegate didPressedBack];
}

@end
